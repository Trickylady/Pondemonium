extends CharacterBody2D
class_name FrogBoss

signal health_changed

@export_range(0.0, 50.0, 0.1) var pupil_distance_from_center: float = 5.0
@export var health: int = 25:
	set(value):
		health = value
		health_changed.emit()
@export var blink_color: Color = Color("ff9d8c")
@export var bullet_speed: float = Manager.TILE_SIZE.x * 4.0

var is_dead: bool = false
var is_shooting: bool = false
var is_shielded: bool = false


func _init() -> void:
	Manager.frog_boss = self

func _ready() -> void:
	%timer_shoot.start()
	Manager.snap_to_grid(self)
	snap_pikes_spawns()

func snap_pikes_spawns():
	for group: Node2D in %pikes_spawn.get_children():
		for spawn: PikeSpawn in group.get_children():
			Manager.snap_to_grid(spawn)

func _process(_delta: float) -> void:
	_process_eyes()

func _process_eyes() -> void:
	look_at_point(Manager.catfish.global_position)

func shoot() -> void:
	is_shooting = true
	%sfx_shoot.play()
	%animations.play(&"shoot")
	var angle_offset: float = randf()
	for i: int in 8 * 4:
		var dir := Vector2.from_angle((PI/8 + angle_offset) * i)
		var boss_spit: BossSpit = preload("res://scenes/boss_spit.tscn").instantiate()
		boss_spit.direction = dir
		boss_spit.speed = bullet_speed
		boss_spit.position = position
		Manager.level.bullets.add_child(boss_spit)
		await get_tree().create_timer(0.05).timeout
	is_shooting = false
	%animations.play(&"idle")
	if not is_shielded:
		%timer_shoot.start()

func spawn_pikes():
	for i: int in 5:
		for group: Node2D in %pikes_spawn.get_children():
			var spawn: PikeSpawn = group.get_children().pick_random()
			spawn.spawn_pike()
			await get_tree().create_timer(randf_range(0.2, 0.9)).timeout
			

func look_at_point(target_global_pos: Vector2) -> void:
	for pupil: Sprite2D in [%EyePupilLeft, %EyePupilRight]:
		var eye_outer: Sprite2D = pupil.get_parent()
		var angle: float = eye_outer.global_position.angle_to_point(target_global_pos)
		var offset: Vector2 = Vector2.from_angle(angle) * pupil_distance_from_center
		pupil.position = offset

func start_shield(duration: float) -> void:
	%timer_shoot.stop()
	%sfx_shield.play()
	is_shielded = true
	%shield_collision.set_deferred("disabled", false)
	%sprite_shield.show()
	
	%timer_stop_shield.wait_time = duration
	%timer_stop_shield.start()

func stop_shield() -> void:
	is_shielded = false
	%sfx_talk.play()
	%shield_collision.set_deferred("disabled", true)
	%sprite_shield.hide()
	shoot()

func take_damage() -> void:
	if is_dead:
		return
	
	health -= 1
	
	if health % 5 == 0:
		spawn_pikes()
		start_shield(15.0)
	elif health % 2 == 0:
		start_shield(1.5)
	
	if health <= 0:
		Manager.add_point_label(5000, position)
		die()
	else:
		Manager.add_point_label(50, position)
		blink(blink_color)
		if not %animations.current_animation == &"hit":
			%animations.play(&"hit")

var tw_blink: Tween
func blink(color: Color) -> void:
	if tw_blink:
		tw_blink.kill()
	tw_blink = create_tween()
	tw_blink.set_ease(Tween.EASE_IN_OUT)
	tw_blink.set_trans(Tween.TRANS_EXPO)
	tw_blink.set_loops(4)
	tw_blink.tween_property(self, "modulate", color, 0.1)
	tw_blink.tween_property(self, "modulate", Color.WHITE, 0.1)
	await tw_blink.finished


func die():
	is_dead = true
	%sfx_die.play()
	stop_shield()
	await blink(Color.TRANSPARENT)
	%Body.modulate.a = 0
	Manager.level.level_won.emit()
	queue_free()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_released(): return
		if event.button_index == MOUSE_BUTTON_LEFT:
			%animations.play(&"frown")
		if event.button_index == MOUSE_BUTTON_RIGHT:
			%animations.play(&"hit")


func _on_shield_area_area_entered(area: Area2D) -> void:
	if area is CatProjectile:
		Manager.add_point_label(-50, position)
		area.explode()


func _on_timer_random_anim_timeout() -> void:
	if not is_shooting:
		%animations.play(&"frown")
	await %animations.animation_finished
	%animations.play(&"idle")
	$timer_random_anim.wait_time = randf_range(15, 25)
	$timer_random_anim.start()
