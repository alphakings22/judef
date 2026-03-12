extends Node2D

# --- Références aux scènes ---
@export var player_scene  : PackedScene
@export var enemy_basic   : PackedScene
@export var enemy_zigzag  : PackedScene
@export var enemy_shooter : PackedScene
@export var bullet_scene  : PackedScene

# --- Variables ---
var score         : int   = 0
var wave          : int   = 1
var enemies_alive : int   = 0
var game_over     : bool  = false

var spawn_timer   : float = 0.0
var spawn_interval: float = 2.0
var enemies_spawned: int  = 0
var enemies_per_wave: int = 8

@onready var screen_size = get_viewport_rect().size
@onready var hud         = $HUD
@onready var game_over_screen = $GameOverScreen
@onready var player_container = $PlayerContainer

var player_node : Node = null

func _ready():
	game_over_screen.hide()
	_spawn_player()
	hud.update_wave(wave)

func _spawn_player():
	if player_scene == null:
		push_warning("Player scene not set!")
		return
	player_node = player_scene.instantiate()
	player_node.position = Vector2(screen_size.x / 2, screen_size.y - 100)
	# Injecter la scène de bullet dans le joueur
	player_node.bullet_scene = bullet_scene
	player_container.add_child(player_node)
	player_node.died.connect(_on_player_died)
	player_node.score_changed.connect(_on_score_changed)
	player_node.hp_changed.connect(_on_hp_changed)
	hud.update_hp(player_node.MAX_HP)

func _process(delta):
	if game_over:
		return
	
	spawn_timer -= delta
	if spawn_timer <= 0 and enemies_spawned < enemies_per_wave:
		_spawn_enemy()
		spawn_timer = spawn_interval
	
	# Passer à la vague suivante si tous les ennemis sont morts
	if enemies_spawned >= enemies_per_wave and get_tree().get_nodes_in_group("enemy").size() == 0:
		_next_wave()

func _spawn_enemy():
	enemies_spawned += 1
	var x = randf_range(40, screen_size.x - 40)
	
	var scene_to_use = enemy_basic
	var roll = randf()
	
	if wave >= 2 and roll < 0.3:
		scene_to_use = enemy_zigzag if enemy_zigzag else enemy_basic
	if wave >= 3 and roll < 0.2:
		scene_to_use = enemy_shooter if enemy_shooter else enemy_basic
	
	if scene_to_use == null:
		return
	
	var e = scene_to_use.instantiate()
	e.position = Vector2(x, -40)
	e.bullet_scene = bullet_scene
	e.died.connect(_on_enemy_died)
	add_child(e)

func _next_wave():
	wave += 1
	enemies_spawned = 0
	enemies_per_wave = 8 + wave * 2
	spawn_interval = max(0.5, 2.0 - wave * 0.15)
	hud.update_wave(wave)
	hud.show_wave_banner(wave)

func _on_player_died():
	game_over = true
	game_over_screen.show()
	game_over_screen.get_node("ScoreLabel").text = "Score final : %d" % score
	game_over_screen.get_node("WaveLabel").text  = "Vague atteinte : %d" % wave

func _on_score_changed(new_score):
	score = new_score
	hud.update_score(score)

func _on_hp_changed(new_hp):
	hud.update_hp(new_hp)

func _on_enemy_died(points):
	if player_node and is_instance_valid(player_node):
		player_node.add_score(points)

func _on_restart_pressed():
	get_tree().reload_current_scene()
