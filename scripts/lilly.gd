@tool
extends Node2D

@export_range(0, 28, 1) var lilypad_id: int:
	set(value):
		lilypad_id = value
		set_lilypad()
@export var sway: Vector2 = Vector2(8,8)
@export var rotation_lily: float = TAU / 32
@export var sway_duration: float = 10

var tw_sway: Tween
var tw_rotation: Tween
var lilypad_regions: Array[Rect2] = [
	Rect2(Vector2(2, 5), Vector2(320, 395)),
	Rect2(Vector2(39, 390), Vector2(172, 287)),
	Rect2(Vector2(39, 677), Vector2(172, 186)),
	Rect2(Vector2(22, 891), Vector2(209, 179)),
	Rect2(Vector2(287, 891), Vector2(175, 179)),
	Rect2(Vector2(287, 671), Vector2(127, 169)),
	Rect2(Vector2(287, 437), Vector2(168, 218)),
	Rect2(Vector2(337, 54), Vector2(240, 296)),
	Rect2(Vector2(641, 45), Vector2(135, 178)),
	Rect2(Vector2(587, 246), Vector2(184, 175)),
	Rect2(Vector2(538, 457), Vector2(233, 213)),
	Rect2(Vector2(500, 673), Vector2(294, 172)),
	Rect2(Vector2(546, 861), Vector2(202, 201)),
	Rect2(Vector2(798, 879), Vector2(175, 156)),
	Rect2(Vector2(820, 676), Vector2(133, 166)),
	Rect2(Vector2(820, 494), Vector2(151, 153)),
	Rect2(Vector2(820, 260), Vector2(178, 187)),
	Rect2(Vector2(852, 61), Vector2(173, 159)),
	Rect2(Vector2(1071, 129), Vector2(145, 340)),
	Rect2(Vector2(1026, 550), Vector2(163, 292)),
	Rect2(Vector2(1024, 865), Vector2(169, 187)),
	Rect2(Vector2(1259, 757), Vector2(240, 279)),
	Rect2(Vector2(1204, 481), Vector2(384, 230)),
	Rect2(Vector2(1221, 43), Vector2(347, 397)),
	Rect2(Vector2(1573, 8), Vector2(346, 247)),
	Rect2(Vector2(1570, 348), Vector2(306, 203)),
	Rect2(Vector2(1612, 646), Vector2(244, 209)),
	Rect2(Vector2(1539, 869), Vector2(167, 157)),
	Rect2(Vector2(1737, 862), Vector2(157, 167)),
]

func _ready() -> void:
	if not Engine.is_editor_hint():
		animate()

func set_lilypad():
	if not is_node_ready():
		await ready
	var rect: Rect2 = lilypad_regions[lilypad_id]
	%Lillypads.region_rect = rect

func animate():
	tw_sway = create_tween()
	tw_sway.set_ease(Tween.EASE_IN_OUT)
	tw_sway.set_trans(Tween.TRANS_SINE)
	
	tw_sway.tween_interval(randf())
	tw_sway.set_loops()
	tw_sway.tween_property(self,"position", Vector2(-sway.x,sway.y), sway_duration / 4).as_relative()
	tw_sway.tween_property(self,"position", Vector2(sway.x,sway.y), sway_duration / 4).as_relative()
	tw_sway.tween_property(self,"position", Vector2(sway.x,-sway.y), sway_duration / 4).as_relative()
	tw_sway.tween_property(self,"position", Vector2(-sway.x,-sway.y), sway_duration / 4).as_relative()
