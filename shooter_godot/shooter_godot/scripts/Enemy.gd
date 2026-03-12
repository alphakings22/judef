extends CharacterBody2D

enum EnemyType { BASIC, ZIGZAG, SHOOTER }

@export var enemy_type  : EnemyType = EnemyType.BASIC
@export var hp          : int       = 2
@export var speed       : float     = 120.0
@export var score_value : int       = 100
@export var bullet_scene : PackedScene

var time         : float = 0.0
var fire_timer   : float = 0.0
var fire_rate    : float = 2.0
var start_x      : float = 0.0

signal died(points)

func _ready():
	add_to_group("enemy")
	start_x = position.x
	if enemy_type == EnemyType.ZIGZAG:
		speed = 150.0
		score_value = 150
	elif enemy_type == EnemyType.SHOOTER:
		hp = 3
		speed = 80.0
		score_value = 200
		fire_rate = 2.5

func _process(delta):
	time += delta
	
	match enemy_type:
		EnemyType.BASIC:
			velocity = Vector2(0, speed)
		EnemyType.ZIGZAG:
			velocity = Vector2(sin(time * 3.0) * speed * 1.5, speed * 0.8)
		EnemyType.SHOOTER:
			velocity = Vector2(0, speed * 0.6)
			fire_timer -= delta
			if fire_timer <= 0:
				_shoot()
				fire_timer = fire_rate
	
	move_and_slide()
	
	# Détruire si hors écran
	var screen_h = get_viewport_rect().size.y
	if position.y > screen_h + 60:
		queue_free()

func _shoot():
	if bullet_scene == null:
		return
	var b = bullet_scene.instantiate()
	b.global_position = global_position + Vector2(0, 20)
	b.is_player_bullet = false
	get_tree().current_scene.add_child(b)

func take_damage(amount: int):
	hp -= amount
	# Flash rouge
	modulate = Color(1, 0.3, 0.3)
	var t = get_tree().create_timer(0.1)
	t.timeout.connect(func(): modulate = Color.WHITE)
	if hp <= 0:
		_die()

func _die():
	emit_signal("died", score_value)
	queue_free()
