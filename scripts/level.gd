extends Node2D
class_name Level

@onready var tile_map: TileMapLayer = $TileMap

func swap_tiles ():
	var cells1 = tile_map.get_used_cells_by_id(1, Vector2i.ZERO, 1)
	var cells2 = tile_map.get_used_cells_by_id(1, Vector2i.ZERO, 2)
	for cell in cells1:
		tile_map.set_cell(cell,1, Vector2i.ZERO, 2)
	for cell in cells2:
		tile_map.set_cell(cell,1, Vector2i.ZERO,1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		swap_tiles()
