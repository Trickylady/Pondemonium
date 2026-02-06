extends StaticBody2D
class_name TileBubble

func destroy():
	$Tilebubble.play("pop")
	$popsound.play()
	await $Tilebubble.animation_finished
	queue_free()
