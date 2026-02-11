extends Area2D
class_name Pike


var direction: Vector2
var speed: float = Manager.TILE_SIZE.x * 4

func _ready() -> void:
	rotate(direction.angle())


func _physics_process(delta: float) -> void:
	var offset: Vector2 = direction * speed
	translate(offset * delta)


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.take_damage()
