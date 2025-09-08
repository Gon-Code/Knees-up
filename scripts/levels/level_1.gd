extends Node2D

# Animation Player
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Balones
@onready var BASEBALL = preload("res://assets/sports-balls/baseball.png")
@onready var BASKETBALL = preload("res://assets/sports-balls/basketball.png")
@onready var FOOTBALL = preload("res://assets/sports-balls/football.png")
@onready var VOLLEYBALL = preload("res://assets/sports-balls/volleyball.png")

@onready var Sport_balls = [BASEBALL, BASKETBALL, FOOTBALL, VOLLEYBALL]

@onready var moving_ball_scene = preload("res://scenes/levels/moving_ball.tscn")
@onready var music: AudioStreamPlayer = $Music
@onready var beatmap_file = FileAccess.open("res://assets/level-1/easy/beatmap.json", FileAccess.READ)

@export var accel_threshold: float = 1.2 # Umbral en m/s²

var beatmap = []
var time_begin
var time_delay
var travel_time = 1.5 # Velocidad desde el spanw hasta la hit zone

# Guardaremos una 2 tupla para indicar tiempo y lado
var hit_events = []
var edit_mode = false


func _ready() -> void:
	randomize()
	# Este archivo lo creamos previamente presionando
	# las acciones left y right
	# Guardamos el tiempo en los cuales queremos que se patee en el centro
	if beatmap_file and not edit_mode:
		var content = beatmap_file.get_as_text()
		beatmap = JSON.parse_string(content)
		#print("beatmap cargado !", beatmap)
		
	# Starts the Music !
	time_begin = Time.get_ticks_usec()
	time_delay = AudioServer.get_time_to_next_mix() + AudioServer.get_output_latency()
	music.play()
	animation_player.play("pulse")

func _process(_delta: float) -> void:
	var time = (Time.get_ticks_usec() - time_begin) / 1000000.0
	time -= time_delay - travel_time
	time = max(0, time)
	#print("Time is: ", time)
	if Input.is_action_just_pressed("left"):
		var event = {
			"time": time,
			"side": "left"
		}
		hit_events.append(event)
		print(event, ",")
	if Input.is_action_just_pressed("right"):
		var event = {
			"time": time,
			"side": "right"
		}
		hit_events.append(event)
		print(event, ",")
	
	while not beatmap.is_empty() and time >= beatmap.front()["time"]:
		var note = beatmap.pop_front()
		# Randomizamos la creacion de balones
		create_moving_ball(note["side"], random_sport_ball())
	
# Funcion que instancia los balones
func create_moving_ball(origin: String, ball_type: Resource) -> void:
	var ball = moving_ball_scene.instantiate()
	ball.setup(origin, ball_type)
	add_child(ball)

# Selecciona una pelota al azar
func random_sport_ball() -> Resource:
		return Sport_balls[randi() % 7]
		
func _ball_on_hit_zone(area: Area2D) -> void:
	area.get_parent().on_hit_area = true


func _ball_on_left_target(area: Area2D) -> void:
	area.get_parent().on_target_area = true

func _ball_on_right_target(area: Area2D) -> void:
	area.get_parent().on_target_area = true
