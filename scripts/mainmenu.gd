extends Control

func _ready() -> void:
	Input.set_custom_mouse_cursor(preload("res://images/menu/cursor.png"))
	Input.mouse_mode =Input.MOUSE_MODE_VISIBLE
	%TabContainer.hide()

func _on_playbutton_pressed() -> void:
	%TabContainer.show()
	%playtab.show()

func _on_preferencesbutton_pressed() -> void:
	%TabContainer.show()
	%preferencetab.show()

func _on_creditbutton_pressed() -> void:
	%TabContainer.show()
	%credittab.show()

func _on_exitbutton_pressed() -> void:
	get_tree().quit()

func _on_normalbutton_pressed() -> void:
	Manager.start_game(Manager.Difficulty.NORMAL)

func _on_hardmodebutton_pressed() -> void:
	Manager.start_game(Manager.Difficulty.HARD)
