extends StaticBody2D
class_name TileStone

func _ready() -> void:
	Manager.level.swap_tiles.connect(swap)

func swap():
	var other_tile = load("res://scenes/tilebubble.tscn").instantiate()
	if not is_instance_valid(other_tile):
		return
	other_tile.position = position
	add_sibling.call_deferred(other_tile)
	queue_free()
