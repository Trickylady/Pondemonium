@tool
extends Marker2D
class_name PikeSpawn

enum Dir {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}
@export var spawn_direction: Dir:
	set(value):
		spawn_direction = value
		if not is_node_ready():
			await ready
		match spawn_direction:
			Dir.UP: $ray.target_position = Vector2.UP * 100
			Dir.DOWN: $ray.target_position = Vector2.DOWN * 100
			Dir.LEFT: $ray.target_position = Vector2.LEFT * 100
			Dir.RIGHT: $ray.target_position = Vector2.RIGHT * 100

func spawn_pike():
	var pike: Pike = preload("res://scenes/pike.tscn").instantiate()
	pike.position = global_position
	pike.direction = $ray.target_position.normalized()
	pike.speed = Manager.TILE_SIZE.x * randf_range(2.5, 4.0)
	Manager.level.enemies.add_child.call_deferred(pike)
