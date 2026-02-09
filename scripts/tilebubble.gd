extends StaticBody2D
class_name TileBubble

func destroy():
	$Tilebubble.play("pop")
	$popsound.play()
	$CollisionShape2D.set_deferred("disabled", true)
	
	var point_label: ScoreLabel = preload("res://scenes/scorelabel.tscn").instantiate()
	point_label.position = position
	point_label.points_display = -20
	point_label.target_pos = Manager.uigame.bucket.global_position
	Manager.level.score_labels.add_child(point_label)

func _on_tilebubble_animation_finished() -> void:
	queue_free()
