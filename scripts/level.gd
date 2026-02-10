extends Node2D
class_name Level

@onready var tile_map: TileMapLayer = $TileMap
@onready var bullets: Node2D = $bullets
@onready var enemies: Node2D = $enemies
@onready var score_labels: Node2D = $score_labels
@onready var pickups: Node2D = $pickups

@export var total_enemies: int = 10
@export var spawn_count: int = 2

var tot_spawn_count: int = 0
var tot_frog_dead: int = 0:
	set(value):
		tot_frog_dead = value
		tot_frog_dead_changed.emit()

signal tot_frog_dead_changed
signal level_won
@warning_ignore("unused_signal")
signal swap_tiles

func _init() -> void:
	Manager.level = self

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	await get_tree().create_timer(1).timeout
	spawn_frogs()

func spawn_frogs():
	var frogs_to_spawn: int = spawn_count
	var max_frogs_left: int = total_enemies - tot_frog_dead
	frogs_to_spawn = min(frogs_to_spawn, max_frogs_left)
	for i: int in frogs_to_spawn:
		spawn_frog()
		await get_tree().create_timer(2).timeout

func spawn_frog() -> void:
	var tile_bubbles: Array[TileBubble] = get_tile_bubbles()
	var picked: TileBubble
	
	if tile_bubbles.is_empty():
		var empty_cell: Vector2i = get_empty_cell()
		var new_bubble: TileBubble = preload("res://scenes/tilebubble.tscn").instantiate()
		new_bubble.position = Vector2(empty_cell) * Manager.TILE_SIZE + Manager.TILE_SIZE / 2
		tile_map.add_child.call_deferred(new_bubble)
		picked = new_bubble
	else:
		picked = tile_bubbles.pick_random()
	
	var new_frog: Enemy = preload("res://scenes/enemy.tscn").instantiate()
	new_frog.position = picked.position
	picked.destroy.call_deferred()
	enemies.add_child.call_deferred(new_frog)
	new_frog.destroyed.connect(enemy_killed)
	tot_spawn_count += 1

func get_empty_cell() -> Vector2i:
	var used_rect := tile_map.get_used_rect()
	var used_cells := tile_map.get_used_cells()
	var empty_cell: Vector2i = Vector2i()
	empty_cell.x = randi_range(0,used_rect.size.x-1)
	empty_cell.y = randi_range(0,used_rect.size.y-1)
	while empty_cell in used_cells:
		empty_cell.x = randi_range(0,used_rect.size.x-1)
		empty_cell.y = randi_range(0,used_rect.size.y-1)
	return empty_cell

func get_tile_bubbles() -> Array[TileBubble]:
	var result: Array[TileBubble] = []
	for child: Node2D in tile_map.get_children():
		if child is TileBubble:
			result.append(child)
	return result

func get_frog_count() -> int:
	return enemies.get_child_count()

func enemy_killed():
	tot_frog_dead += 1
	if tot_frog_dead >= total_enemies:
		level_won.emit()
		return
	if tot_frog_dead % spawn_count == 0:
		spawn_frogs()
