extends CanvasLayer

@onready var score_label = $ScoreLabel
@onready var hp_label    = $HPLabel
@onready var wave_label  = $WaveLabel
@onready var wave_banner = $WaveBanner

func _ready():
	add_to_group("hud")
	if wave_banner:
		wave_banner.hide()

func update_score(value: int):
	if score_label:
		score_label.text = "Score : %d" % value

func update_hp(value: int):
	if hp_label:
		var hearts = ""
		for i in value:
			hearts += "❤ "
		hp_label.text = hearts

func update_wave(value: int):
	if wave_label:
		wave_label.text = "Vague %d" % value

func show_wave_banner(value: int):
	if wave_banner == null:
		return
	wave_banner.text = "— VAGUE %d —" % value
	wave_banner.show()
	var t = get_tree().create_timer(2.0)
	t.timeout.connect(func(): wave_banner.hide())
