extends StaticBody2D
class_name TileStone

func _ready() -> void:
	Manager.level.swap_tiles.connect(swap)

func swap():
	var other_tile = preload("res://scenes/tilebubble.tscn").instantiate()
	other_tile.position = position
	add_sibling(other_tile)
	queue_free()
