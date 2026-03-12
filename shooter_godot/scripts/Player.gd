extends CharacterBody2D

# --- Stats ---
const SPEED        = 300.0
const FIRE_RATE    = 0.18   # secondes entre chaque tir
const MAX_HP       = 5
const INVUL_TIME   = 1.5    # secondes d'invulnérabilité après dégâts

@export var bullet_scene : PackedScene

var hp           : int   = MAX_HP
var fire_timer   : float = 0.0
var invul_timer  : float = 0.0
var score        : int   = 0

@onready var screen_size = get_viewport_rect().size
@onready var hud = get_tree().get_first_node_in_group("hud")

signal died
signal score_changed(new_score)
signal hp_changed(new_hp)

func _ready():
	add_to_group("player")

func _process(delta):
	# --- Mouvement ---
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):  direction.x -= 1
	if Input.is_action_pressed("move_right"): direction.x += 1
	if Input.is_action_pressed("move_up"):    direction.y -= 1
	if Input.is_action_pressed("move_down"):  direction.y += 1
	
	velocity = direction.normalized() * SPEED
	move_and_slide()
	
	# Limiter le joueur à l'écran
	position.x = clamp(position.x, 20, screen_size.x - 20)
	position.y = clamp(position.y, 20, screen_size.y - 20)
	
	# --- Tir ---
	fire_timer -= delta
	if Input.is_action_pressed("shoot") and fire_timer <= 0:
		_shoot()
		fire_timer = FIRE_RATE
	
	# --- Invulnérabilité ---
	if invul_timer > 0:
		invul_timer -= delta
		modulate.a = 0.5 if fmod(invul_timer, 0.2) < 0.1 else 1.0
	else:
		modulate.a = 1.0

func _shoot():
	if bullet_scene == null:
		return
	var b = bullet_scene.instantiate()
	b.global_position = global_position + Vector2(0, -20)
	b.is_player_bullet = true
	get_tree().current_scene.add_child(b)

func take_damage(amount: int = 1):
	if invul_timer > 0:
		return
	hp -= amount
	invul_timer = INVUL_TIME
	emit_signal("hp_changed", hp)
	if hp <= 0:
		_die()

func add_score(points: int):
	score += points
	emit_signal("score_changed", score)

func _die():
	emit_signal("died")
	# Effet de mort simple
	queue_free()
