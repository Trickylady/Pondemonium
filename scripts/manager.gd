extends Node

const TILE_SIZE = Vector2(80,80)

enum Difficulty{NORMAL, HARD}

const levels = [
	"res://scenes/level_1.tscn", 
	"res://scenes/level_2.tscn", 
	#"res://scenes/level_3.tscn", 
	#"res://scenes/level_4.tscn", 
	#"res://scenes/level_5.tscn"
]
signal lives_changed
signal score_changed

var level: Level
var catfish: Player
var uigame: UI

var mode: Difficulty
var current_level: int = 0

var total_score: int = 0:
	set(value):
		total_score = value
		score_changed.emit()
var lives: int:
	set(value):
		lives = value
		lives_changed.emit()
var bubblets_amount: int

func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://images/menu/cursor.png"))

func start_game(difficulty: Difficulty):
	current_level = 0
	mode = difficulty
	reset_stats()
	go_to_next_level()

func go_to_main_menu():
	get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")

func go_to_next_level() -> void:
	current_level +=1
	if current_level > levels.size():
		return
	var level_path: String = levels[current_level -1]
	get_tree().change_scene_to_file(level_path)
	get_tree().paused = false

func reset_stats():
	if mode == Difficulty.NORMAL:
		lives = 5 
	if mode == Difficulty.HARD:
		lives = 1
		bubblets_amount = 25
	total_score = 0
	get_tree().paused = false
