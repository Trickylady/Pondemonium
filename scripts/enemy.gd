extends CharacterBody2D
class_name Enemy

@export var move_time := 0.60
@export var see_distance: int = 2
@export var shoot_cooldown: float = 5 
@export var bullet_speed: float = Manager.TILE_SIZE.x * 4.0

var direction: Vector2 = Vector2.ZERO
var target_position: Vector2
var is_moving := false
var is_shooting: bool = false
var is_dead: bool = false
var is_glued: bool = false
var pickup_prob: float

signal destroyed

func _init() -> void:
	Manager.catfish.glue_picked_up.connect(start_glue)

func _ready() -> void:
	Manager.snap_to_grid(self)
	target_position = position
	set_physics_process(false)
	await get_tree().create_timer(1.0).timeout
	set_physics_process(true)
	if Manager.mode == Manager.Difficulty.HARD:
		pickup_prob = 0.35
	else:
		pickup_prob = 0.45

func find_new_target() -> void:
	var possible_targets: Array = []
	for ray: RayCast2D in %movementrays.get_children():
		if ray.is_colliding():
			continue
		possible_targets.append(ray.target_position)
	if possible_targets.is_empty():
		return
	var random_dir: Vector2 = possible_targets.pick_random()
	target_position = position + random_dir
	direction = Vector2(random_dir.normalized())
	$RayPlayerDetect.target_position = Vector2(direction) * Manager.TILE_SIZE * see_distance

func _physics_process(delta: float) -> void:
	if is_glued:
		return
	if not is_shooting and $RayPlayerDetect.get_collider() is Player:
		shoot()
		return
	if not is_moving and not is_shooting:
		find_new_target()
		is_moving = true
	if is_moving:
		position = position.move_toward(target_position, Manager.TILE_SIZE.x / move_time * delta)
		if position == target_position:
			is_moving = false

func shoot() -> void:
	if is_shooting: return
	is_shooting = true
	is_moving = false
	
	if direction.x != 0:
		%Sprite.play(&"attackhor")
	await get_tree().create_timer(0.1).timeout
	
	var bullet: frogspit = preload("res://scenes/frog_spit.tscn").instantiate()
	bullet.speed = bullet_speed
	bullet.position = position
	bullet.direction = direction
	Manager.level.bullets.add_child(bullet)
	is_moving = true
	await get_tree().create_timer(shoot_cooldown).timeout
	is_shooting = false

func _process(_delta: float) -> void:
	%Sprite.flip_h = direction == Vector2.LEFT
	%Sprite.flip_v = direction == Vector2.DOWN
	if direction.y != 0 and %Sprite.animation != "vertical":
		%Sprite.play("vertic")
	elif direction.x != 0 and %Sprite.animation != "horizontal":
		%Sprite.play("horizon")

func die() -> void:
	if is_dead: return
	is_dead = true
	destroyed.emit()
	$CollisionShape2D.set_deferred(&"disabled", true)
	set_process(false)
	set_physics_process(false)
	%SFXfrogdead.play()
	%Sprite.play("dead")
	
	Manager.add_point_label(200, position)
	
	var spawn_pickup: bool = randf() < pickup_prob
	if spawn_pickup:
		var pickup: Pickup = load("res://scenes/pickup.tscn").instantiate()
		pickup.position = position
		Manager.level.pickups.add_child.call_deferred(pickup)
		pickup.pick_random()
	
	await %Sprite.animation_finished
	queue_free()

func destroy():
	die()

func start_glue(duration: float):
	is_glued = true
	$timer_glue.wait_time = duration
	$timer_glue.start()
	$glue.show()

func stop_glue():
	is_glued = false
	$glue.hide()


func spawn_enemy_bubble():
	pass
