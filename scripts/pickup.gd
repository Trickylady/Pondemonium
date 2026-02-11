extends Node2D
class_name Pickup

enum Type{
	HEART,
	GLUE,
	REVERSE,
	SHIELD
}

var type: Type: set = set_type
var despawn_duration: float = 10
var duration_glue: float = 15
var duration_shield: float = 30

func pick_random() -> void:
	type = [
		Type.HEART,
		Type.GLUE,
		Type.REVERSE,
		Type.SHIELD
	].pick_random()

func set_type(value: Type):
	type = value
	if not is_node_ready():
		await ready
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
	Manager.add_point_label(500, position)
	queue_free()
