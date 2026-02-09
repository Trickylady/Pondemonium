extends CharacterBody2D
class_name Player

@export var walk_speed := Manager.TILE_SIZE.x * 4.0

var direction: Vector2 = Vector2.ZERO
var target_position: Vector2
var moving: bool = false
var lives: int = 5

func _ready() -> void:
	position = (position - Manager.TILE_SIZE/2.0).snapped(Manager.TILE_SIZE) + Manager.TILE_SIZE/2.0
	direction = Vector2.RIGHT

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(&"shoot") and can_shoot():
		shoot()
	if not moving:
		var input = Vector2(
			Input.get_action_strength(&"right") - Input.get_action_strength(&"left"),
			Input.get_action_strength(&"down") - Input.get_action_strength(&"up")
		)
		if input != Vector2.ZERO:
			if input.y > 0: direction = Vector2.DOWN
			elif input.y < 0: direction = Vector2.UP
			elif input.x > 0: direction = Vector2.RIGHT
			elif input.x < 0: direction = Vector2.LEFT
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
	#if moving:
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

func can_shoot() -> bool:
	if Manager.mode == Manager.Difficulty.NORMAL:
		return true
	return true

func take_damage():
	lives -= 1
	print(lives)
