extends CharacterBody2D

@export var walk_speed := Manager.TILE_SIZE.x * 4.0

var direction: Vector2 = Vector2.ZERO
var target_position: Vector2
