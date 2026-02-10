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

func update_all():
	update_score()
	update_bubblets()
	update_lives()
	update_boosts()
	update_frogs()

func update_score():
	%scoreamount.text = str(Manager.total_score)

func update_bubblets():
	if Manager.mode == Manager.Difficulty.HARD:
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
