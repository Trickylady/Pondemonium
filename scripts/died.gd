extends Control

func _on_menubut_pressed() -> void:
	Manager.go_to_main_menu()

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	if is_node_ready():
		get_tree().paused = is_visible_in_tree()

func _on_retry_pressed() -> void:
	Manager.start_game(Manager.mode)
