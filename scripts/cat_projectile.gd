extends Area2D
class_name  CatProjectile

const bubbles: Array = [
	"res://images/game/cat_projectile_1.png",
	"res://images/game/cat_projectile_2.png",
	"res://images/game/cat_projectile_3.png",
	"res://images/game/cat_projectile_4.png",
	"res://images/game/cat_projectile_5.png"
]

var direction: Vector2
var speed: float = Manager.TILE_SIZE.x * 8

func _ready() -> void:
	%sprite.texture = load(bubbles.pick_random())

func _physics_process(delta: float) -> void:
	position += direction * delta * speed

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.destroy()
	elif body is TileBubble:
		body.destroy(true)
	explode()

func explode():
	queue_free()
	
