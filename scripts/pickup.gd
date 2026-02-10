extends Node2D
class_name Pickup

enum Type{
	HEART,
	GLUE,
	REVERSE,
	SHIELD
}

var type: Type
var despawn_duration: float = 10
var duration_glue: float = 15
var duration_shield: float = 15

func _ready() -> void:
	type = [
		Type.HEART,
		Type.GLUE,
		Type.REVERSE,
		Type.SHIELD
	].pick_random()
	match type:
		Type.HEART: %sprite_boost.play("hearts")
		Type.GLUE: %sprite_boost.play("glues")
		Type.REVERSE: %sprite_boost.play("reverses")
		Type.SHIELD: %sprite_boost.play("shields")

func _process(delta: float) -> void:
	despawn_duration -= delta
	if despawn_duration< 0:
		set_process(false)
		despawn()

func despawn():
	var tw: Tween = create_tween()
	tw.set_ease(Tween.EASE_IN)
	tw.set_trans(Tween.TRANS_CIRC)
	tw.tween_property(self, "modulate:a", 0, 1)
	tw.tween_callback(queue_free)

func _on_body_entered(body: Player) -> void:
	body.pick_up(self)
	var point_label: ScoreLabel = preload("res://scenes/scorelabel.tscn").instantiate()
	point_label.position = position
	point_label.points_display = 500
	point_label.target_pos = Manager.uigame.bucket.global_position
	Manager.level.score_labels.add_child(point_label)
	queue_free()
