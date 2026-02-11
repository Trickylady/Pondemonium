extends StaticBody2D
class_name TileBubble

var is_destroyed: bool = false
func _ready() -> void:
	Manager.level.swap_tiles.connect(swap)

func swap():
	if is_destroyed:
		return
	var other_tile = preload("res://scenes/tilestone.tscn").instantiate()
	other_tile.position = position
	add_sibling.call_deferred(other_tile)
	queue_free()

func destroy(with_points: bool = false):
	is_destroyed = true
	$Tilebubble.play("pop")
	$popsound.play()
	$CollisionShape2D.set_deferred("disabled", true)
	
	if with_points:
		Manager.add_point_label(-20, position)
	if Manager.level.boss_level:
		var spawn_pickup: bool = randf() < 0.3
		if spawn_pickup:
			var pickup: Pickup = preload("res://scenes/pickup.tscn").instantiate()
			pickup.position = position
			pickup.type = [Pickup.Type.HEART, Pickup.Type.REVERSE, Pickup.Type.SHIELD].pick_random()
			Manager.level.pickups.add_child.call_deferred(pickup)
	
	await $Tilebubble.animation_finished
	queue_free()
