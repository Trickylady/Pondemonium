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

func update_all():
	update_score()
	update_bubblets()
	update_lives()
	update_boosts()

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

func show_deathscreen():
	%Died.show()
