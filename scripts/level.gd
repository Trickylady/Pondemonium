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

func spawn_frog() -> void:
	var tile_bubbles: Array[TileBubble] = get_tile_bubbles()
	var picked: TileBubble = tile_bubbles.pick_random()
	var new_frog: Enemy = preload("res://scenes/enemy.tscn").instantiate()
	new_frog.position = picked.position
	picked.destroy()
	enemies.add_child(new_frog)
	new_frog.destroyed.connect(enemy_killed)
	tot_spawn_count += 1

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

#func _input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.is_pressed() and event.keycode == KEY_ENTER:
			#swap_tiles.emit()
