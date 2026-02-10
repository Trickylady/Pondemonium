extends CanvasLayer
class_name UI

@onready var bucket: Marker2D = %bucket

func _init() -> void:
	Manager.uigame = self

func _ready() -> void:
	update_all()
	Manager.catfish.bubblets_changed.connect(update_bubblets)
	Manager.score_changed.connect(update_score)
	Manager.lives_changed.connect(update_lives)
	Manager.catfish.diededed.connect(show_deathscreen)
	Manager.level.tot_frog_dead_changed.connect(update_frogs)
	Manager.level.level_won.connect(on_level_won)
	Manager.catfish.diededed.connect(stop_last_bubble)
	Manager.catfish.last_bubblet_started.connect(start_last_bubble)
	Manager.catfish.pick_up_collected.connect(pick_up_collected)
	stop_last_bubble()

func update_all():
	update_score()
	update_bubblets()
	update_lives()
	update_boosts()
	update_frogs()
	update_level()

func update_score():
	%scoreamount.text = str(Manager.total_score)

func update_bubblets():
	if Manager.mode == Manager.Difficulty.HARD:
		var col: Color = Color.WHITE
		if Manager.catfish.bubblets_remaining <= 3:
			col = Color.RED
		elif Manager.catfish.bubblets_remaining<= 8:
			col = Color.ORANGE
		%bubblesamount.modulate = col
		%bubblesamount.text = "x %s" % str(Manager.catfish.bubblets_remaining)
	else:
		%bubblesamount.text = "x"
	%infinite.visible = Manager.mode == Manager.Difficulty.NORMAL

func update_lives():
	%lives.text = "x %s" % str(Manager.lives)

func update_boosts():
	pass

func update_frogs():
	var killed: int = Manager.level.tot_frog_dead
	var tot: int = Manager.level.total_enemies
	%frogs.text = "%d/%d" % [killed, tot]

func update_level():
	var tot: int = Manager.levels.size()
	var cur: int = Manager.current_level
	%levelnum.text = "Level %d/%d" % [cur, tot]

func show_deathscreen():
	%Died.show()

func show_next_level():
	%Nextlevel.show()

func show_win_screen():
	%Win.show()

func on_level_won():
	await get_tree().create_timer(3).timeout
	if Manager.current_level == Manager.levels.size():
		show_win_screen()
	else:
		show_next_level()

func start_last_bubble():
	%ProgressBar.show()
	%lastbub.show()
	set_process(true)

func stop_last_bubble():
	%ProgressBar.hide()
	%lastbub.hide()
	set_process(false)

func _process(_delta: float) -> void:
	var time_left: float = Manager.catfish.last_bubblet_timer.time_left
	var tot_time: float = Manager.catfish.last_bubblet_timer.wait_time
	var ratio: float = time_left / tot_time
	%ProgressBar.value = ratio

func pick_up_collected(pickup: Pickup):
	match pickup.type:
		Pickup.Type.GLUE:
			blink_sprite(%BoostGlue1, pickup.duration_glue)
		Pickup.Type.SHIELD:
			blink_sprite(%BoostElectric1, pickup.duration_shield)
		Pickup.Type.REVERSE:
			blink_sprite(%BoostReverse1)

func blink_sprite(sprite: Sprite2D, duration: float = 0):
	sprite.modulate.a = 1
	var tw:Tween = create_tween()
	tw.set_ease(Tween.EASE_IN_OUT)
	tw.set_trans(Tween.TRANS_CUBIC)
	tw.tween_interval(duration)
	tw.set_loops(12)
	tw.tween_property(sprite, "modulate:a", 1, 0.3)
	tw.tween_property(sprite, "modulate:a", 0.3, 0.3)
	await tw.finished
