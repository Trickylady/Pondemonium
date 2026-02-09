extends Node2D
class_name ScoreLabel

const negative_color = Color("ff0c00")

var points_display: int
var target_pos: Vector2
var duration_floating: float = 0.4
var duration_target: float = 1.1

func _ready() -> void:
	$Label.text = str(points_display)
	if points_display < 0:
		$Label.modulate = negative_color
	await float_anim()
	go_to_bucket()

func float_anim():
	var tw: Tween = create_tween()
	tw.set_ease(Tween.EASE_OUT)
	tw.set_trans(Tween.TRANS_ELASTIC)
	tw.set_parallel()
	tw.tween_property(self, "modulate:a", 1.0, 0.2).from(0.0)
	tw.tween_property(self, "position:y", -57, duration_floating).as_relative()
	await tw.finished

func go_to_bucket():
	var tw: Tween = create_tween()
	tw.set_ease(Tween.EASE_IN_OUT)
	tw.set_trans(Tween.TRANS_CUBIC)
	#tw.set_parallel()
	tw.tween_property(self,"position", target_pos, duration_target)
	tw.tween_property(self, "modulate:a", 0.0, 0.6)
	tw.parallel().tween_property(Manager, "total_score", points_display, 0.4).as_relative()
	tw.tween_callback(queue_free)
