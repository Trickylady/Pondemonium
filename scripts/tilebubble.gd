extends StaticBody2D
class_name TileBubble

func _ready() -> void:
	Manager.level.swap_tiles.connect(swap)

func swap():
	var other_tile = preload("res://scenes/tilestone.tscn").instantiate()
	other_tile.position = position
	add_sibling(other_tile)
	queue_free()

func destroy(with_points: bool = false):
	$Tilebubble.play("pop")
	$popsound.play()
	$CollisionShape2D.set_deferred("disabled", true)
	
	if with_points:
		var point_label: ScoreLabel = preload("res://scenes/scorelabel.tscn").instantiate()
		point_label.position = position
		point_label.points_display = -20
		point_label.target_pos = Manager.uigame.bucket.global_position
		Manager.level.score_labels.add_child(point_label)
	await $Tilebubble.animation_finished
	queue_free()
