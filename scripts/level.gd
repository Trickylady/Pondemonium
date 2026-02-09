extends Node2D
class_name Level

@onready var tile_map: TileMapLayer = $TileMap
@onready var bullets: Node2D = $bullets
@onready var enemies: Node2D = $enemies

func _init() -> void:
	Manager.level = self

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func swap_tiles ():
	var cells1 = tile_map.get_used_cells_by_id(1, Vector2i.ZERO, 1)
	var cells2 = tile_map.get_used_cells_by_id(1, Vector2i.ZERO, 2)
	for cell in cells1:
		tile_map.set_cell(cell,1, Vector2i.ZERO, 2)
	for cell in cells2:
		tile_map.set_cell(cell,1, Vector2i.ZERO,1)

func spawn_frog() -> void:
	var tile_bubbles: Array[TileBubble] = get_tile_bubbles()
	var picked: TileBubble = tile_bubbles.pick_random()
	var new_frog: Enemy = preload("res://scenes/enemy.tscn").instantiate()
	new_frog.position = picked.position
	picked.destroy()
	enemies.add_child(new_frog)

func get_tile_bubbles() -> Array[TileBubble]:
	var result: Array[TileBubble] = []
	for child: Node2D in tile_map.get_children():
		if child is TileBubble:
			result.append(child)
	return result

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#spawn_frog()
