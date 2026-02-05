extends Node

const TILE_SIZE = Vector2(80,80)

enum Difficulty{NORMAL, HARD}

var mode: Difficulty

func start_game(difficulty: Difficulty):
	mode = difficulty
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")
