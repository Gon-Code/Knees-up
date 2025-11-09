extends Node2D


# Nodos
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var music: AudioStreamPlayer = $Music
@onready var pause_menu: Control = $UI/CanvasLayer/PauseMenu
@onready var left_target: Sprite2D = $UI/TargetLeft/Layer1
@onready var right_target: Sprite2D = $UI/TargetRight/Layer1
@onready var message_tutorial_1: Control = $UI/CanvasLayer/MessageTutorial1
@onready var combo_counter: Node2D = $UI/CanvasLayer/ComboCounter

# Balones
@onready var BASEBALL = preload("res://assets/sports-balls/baseball.png")
@onready var BASKETBALL = preload("res://assets/sports-balls/basketball.png")
@onready var FOOTBALL = preload("res://assets/sports-balls/football.png")
@onready var VOLLEYBALL = preload("res://assets/sports-balls/volleyball.png")

@onready var Sport_balls = [BASEBALL, BASKETBALL, FOOTBALL, VOLLEYBALL]

@onready var moving_ball_scene = preload("res://scenes/levels/moving_ball.tscn")
@onready var beatmap_file = FileAccess.open("res://assets/level-1/easy/beatmap-tutorial.json", FileAccess.READ)

var beatmap = []
var travel_time = 2.85 # Velocidad desde el spawnhasta la hit zone

# Guardaremos una 2 tupla para indicar tiempo y lado
var hit_events = []

func _ready() -> void:
	change_target_colors()
	randomize()
	# Este archivo lo creamos previamente presionando
	# las acciones left y right
	# Guardamos el tiempo en los cuales queremos que se patee en el centro
	if beatmap_file:
		load_beatmap()
		print(beatmap)
	return
	
func _process(_delta: float) -> void:
	# Obtenemos tiempo de reproduccion
	var time = get_current_time_playing()
	var EPS = 0.5
	while not beatmap.is_empty() and time >= beatmap.front()["time"] - travel_time + EPS:
		var note = beatmap.pop_front()
		# Randomizamos la creacion de balones
		create_moving_ball(note["side"], random_sport_ball())
	
	# Pause Menu
	if Input.is_action_just_pressed("pause_game") :
		get_tree().paused = true
		pause_menu.show_pause_menu()
	
	# Skip Tutorial
	if Input.is_action_just_pressed("Enter"):
		get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

	return

# Funcion que instancia los balones
func create_moving_ball(origin: String, ball_type: Resource) -> void:
	var ball = moving_ball_scene.instantiate()
	ball.setup(origin, ball_type)
	add_child(ball)

# Selecciona una pelota al azar
func random_sport_ball() -> Resource:
		return Sport_balls[randi() % 4]

# Funcion que retorna el tiempo de reproduccion de la cancion
func get_current_time_playing() -> float:
	var time: float = music.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	return time
	
func _ball_on_hit_zone(area: Area2D) -> void:
	area.get_parent().on_hit_area = true

func _ball_on_left_target(area: Area2D) -> void:
	area.get_parent().on_target_area = true

func _ball_on_right_target(area: Area2D) -> void:
	area.get_parent().on_target_area = true

# Cuando la musica se detiene
# Paramos la escena y mostramos la pantalla final
func _on_music_finished() -> void:
	if combo_counter.correct_hits !=3 :
		get_tree().reload_current_scene()
	else:
		music.stop()
		message_tutorial_1.show_completed_tutorial_menu()
	return

# Cambia los colores de los targets
func change_target_colors() -> void:
	left_target.self_modulate = PlayerData.left_color
	right_target.self_modulate = PlayerData.right_color
	return

# Carga nuevamente la data del beatmap
func load_beatmap() -> void:
	var content = beatmap_file.get_as_text()
	beatmap = JSON.parse_string(content)
	return
