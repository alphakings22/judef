extends Area2D

var is_player_bullet : bool = true
var speed            : float = 600.0
var damage           : int   = 1

func _ready():
	# Auto-détruit si sort de l'écran
	var screen_h = get_viewport_rect().size.y
	var screen_w = get_viewport_rect().size.x
	if is_player_bullet:
		speed = 600.0
	else:
		speed = 300.0
	
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _process(delta):
	if is_player_bullet:
		position.y -= speed * delta
	else:
		position.y += speed * delta
	
	# Détruire si hors écran
	var vp = get_viewport_rect()
	if position.y < -50 or position.y > vp.size.y + 50:
		queue_free()

func _on_body_entered(body):
	if is_player_bullet and body.is_in_group("enemy"):
		body.take_damage(damage)
		queue_free()
	elif not is_player_bullet and body.is_in_group("player"):
		body.take_damage(damage)
		queue_free()

func _on_area_entered(area):
	if is_player_bullet and area.is_in_group("enemy"):
		area.take_damage(damage)
		queue_free()
	elif not is_player_bullet and area.is_in_group("player"):
		area.take_damage(damage)
		queue_free()
