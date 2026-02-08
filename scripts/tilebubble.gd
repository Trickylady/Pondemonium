extends StaticBody2D
class_name TileBubble

func destroy():
	$Tilebubble.play("pop")
	$popsound.play()
	$CollisionShape2D.set_deferred("disabled", true)

func _on_tilebubble_animation_finished() -> void:
	queue_free()
