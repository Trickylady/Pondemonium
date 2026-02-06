extends Control

func _on_visibility_changed() -> void:
	if is_node_ready():
		get_tree().paused = is_visible_in_tree()
	if is_visible_in_tree():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_continuebutton_pressed() -> void:
	hide()

func _on_menubutton_pressed() -> void:
	Manager.go_to_main_menu()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		visible = not visible
