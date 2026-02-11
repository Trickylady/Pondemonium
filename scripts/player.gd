extends CharacterBody2D
class_name Player

@export var walk_speed := Manager.TILE_SIZE.x * 4.0
@onready var directiontimer: Timer = $Directiontimer
@onready var last_bubblet_timer: Timer = $last_bubblet_timer

signal bubblets_changed
signal diededed
signal glue_picked_up(duration: float)
signal shield_picked_up(duration: float)
signal last_bubblet_started
signal pick_up_collected(pickup: Pickup)

var input_dir: Vector2
var direction: Vector2 = Vector2.ZERO
var target_position: Vector2
var moving: bool = false
var bubblets_remaining: int:
	set(value):
		bubblets_remaining = value
		bubblets_changed.emit()
var init_pos: Vector2
var is_dead: bool
var is_respawning: bool:
	set(value):
		is_respawning = value
		$CollisionShape2D.set_deferred("disabled", is_respawning)
var is_shielded: bool = false

func _init() -> void:
	Manager.catfish = self

func _ready() -> void:
	Manager.snap_to_grid(self)
	init_pos = position
	direction = Vector2.RIGHT
	$RichTextLabel.hide()
	if Manager.mode == Manager.Difficulty.HARD:
		bubblets_remaining = Manager.bubblets_amount
		if Manager.level.boss_level:
			bubblets_remaining += 5

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	if Input.is_action_just_pressed(&"shoot") and can_shoot():
		shoot()
	if not moving:
		var previous: Vector2 = input_dir
		input_dir = Vector2(
			Input.get_action_strength(&"right") - Input.get_action_strength(&"left"),
			Input.get_action_strength(&"down") - Input.get_action_strength(&"up")
		)
		var input_changed: bool = previous != input_dir
		if input_dir != Vector2.ZERO:
			if input_dir.y > 0: direction = Vector2.DOWN
			elif input_dir.y < 0: direction = Vector2.UP
			elif input_dir.x > 0: direction = Vector2.RIGHT
			elif input_dir.x < 0: direction = Vector2.LEFT
			if input_changed:
				if directiontimer.is_stopped():
					directiontimer.start()
				return
			if not directiontimer.is_stopped():
				return
			if is_respawning:
				return
			var next_pos = position + direction * Manager.TILE_SIZE
			if not test_move(global_transform, direction * Manager.TILE_SIZE):
				target_position = next_pos
				moving = true
	if moving:
		var final_speed: float = walk_speed
		final_speed *= delta
		position = position.move_toward(target_position, final_speed)
		if position == target_position:
			moving = false

func _process(_delta: float) -> void:
	%Sprite.flip_h = direction == Vector2.LEFT
	%Sprite.flip_v = direction == Vector2.UP
	if direction.y != 0 and %Sprite.animation != "vertical":
		%Sprite.play("vertical")
	elif direction.x != 0 and %Sprite.animation != "horizontal":
		%Sprite.play("horizontal")

func shoot():
	var proj : CatProjectile = preload("res://scenes/cat_projectile.tscn").instantiate()
	proj.direction = direction
	proj.position = position
	add_sibling(proj)
	if Manager.mode == Manager.Difficulty.HARD:
		bubblets_remaining -= 1
		if bubblets_remaining <= 0:
			last_bubblet_started.emit()
			$last_bubblet_timer.start()

func can_shoot() -> bool:
	if Manager.mode == Manager.Difficulty.NORMAL:
		return true
	return bubblets_remaining > 0

func take_damage():
	if is_shielded:
		return
	Manager.lives -= 1
	is_respawning = true
	is_dead = true
	moving = false
	$AnimationPlayer.play("die")
	$SFXdieplayer.play()
	await $AnimationPlayer.animation_finished
	if Manager.lives <= 0:
		diededed.emit()
	else:
		respawn()

func respawn():
	position = init_pos
	is_dead = false
	$AnimationPlayer.play("respawn")
	$sfxrespawn.play()
	await $AnimationPlayer.animation_finished
	is_respawning = false
	if Manager.mode == Manager.Difficulty.HARD:
		bubblets_remaining = Manager.bubblets_amount
	
func pick_up(pickup: Pickup):
	pick_up_collected.emit(pickup)
	match pickup.type:
		Pickup.Type.HEART:
			Manager.lives += 1
		Pickup.Type.GLUE:
			glue_picked_up.emit(pickup.duration_glue)
		Pickup.Type.SHIELD:
			shield_picked_up.emit(pickup.duration_shield)
			start_shield(pickup.duration_shield)
		Pickup.Type.REVERSE:
			Manager.level.swap_tiles.emit()

func start_shield(duration: float):
	is_shielded = true
	$timer_shield.wait_time = duration
	$timer_shield.start()
	$shield.show()

func stop_shield():
	var tw:Tween = create_tween()
	tw.set_ease(Tween.EASE_IN_OUT)
	tw.set_trans(Tween.TRANS_CUBIC)
	tw.set_loops(12)
	tw.tween_property($shield, "modulate:a", 0, 0.3)
	tw.tween_property($shield, "modulate:a", 1, 0.3)
	await tw.finished
	$shield.hide()
	is_shielded = false

func _on_shield_area_body_entered(body: Enemy) -> void:
	if is_shielded:
		body.destroy()


func _on_last_bubblet_timer_timeout() -> void:
	take_damage()
