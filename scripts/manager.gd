extends Node

const TILE_SIZE = Vector2(80,80)

enum Difficulty{NORMAL, HARD}

const levels = [
	"res://scenes/level_1.tscn", 
	"res://scenes/level_2.tscn", 
	"res://scenes/level_3.tscn", 
	"res://scenes/level_4.tscn", 
	"res://scenes/level_5.tscn"
]

var current_level: int = 0
var mode: Difficulty
var level: Level

func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://images/menu/cursor.png"))

func start_game(difficulty: Difficulty):
	current_level = 0
	mode = difficulty
	go_to_next_level()

func go_to_main_menu():
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

func go_to_next_level() -> void:
	current_level +=1
	if current_level >= levels.size():
		print("wtf")
		return
	var level_path: String = levels[current_level -1]
	get_tree().change_scene_to_file(level_path)
