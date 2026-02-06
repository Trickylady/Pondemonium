extends Control

func _on_menubut_pressed() -> void:
	Manager.go_to_main_menu()

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
