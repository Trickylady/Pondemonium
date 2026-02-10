extends Label

func _on_visibility_changed() -> void:
	if is_visible_in_tree():
		update()

func update():
	var tw: Tween = create_tween()
	tw.set_ease(Tween.EASE_OUT)
	tw.set_trans(Tween.TRANS_CUBIC)
	tw.tween_method(set_label, 0, Manager.total_score, 1)

func set_label(value: int):
	text = str(value)
