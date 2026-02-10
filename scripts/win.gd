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
	update()

func update():
	var tw: Tween = create_tween()
	tw.set_ease(Tween.EASE_OUT)
	tw.set_trans(Tween.TRANS_CUBIC)
	tw.tween_method(set_label, 0, Manager.total_score, 1)

func set_label(value: int):
	%endscore.text = str(value)
