extends Node2D

@export var DEBUG : bool = false

@onready var beatmap_file = FileAccess.open("res://assets/level-2/beatmap.json", FileAccess.READ)
@onready var music: AudioStreamPlayer = $Music
@onready var red_pandas: Node2D = $RedPandas
@onready var speakers_animation: AnimationPlayer = $UI/Speakers/SpeakersAnimation
@onready var disco_ball_animation: AnimationPlayer = $UI/MirrorBalls/DiscoBallAnimation
@onready var combo_counter: Node2D = $UI/CanvasLayer/ComboCounter
@onready var hit_counter: Control = $UI/CanvasLayer/HitCounter
@onready var score_menu: Control = $UI/CanvasLayer/ScoreMenu
@onready var pause_menu: Control = $UI/CanvasLayer/PauseMenu


var side: String
var action : String
var beatmap = []
const EPS := 0.5  # Epsilon de error en el calculo del tiempo

# VENTANAS DE TIEMPO PARA CADA MOVIMIENTO 
var inicio_ventana: float
var fin_ventana: float

# Con respecto al time inicial de la animacion
const tap_animation_delay: float = 1.1 # En este momento se reproduce la animacion del tap
const jump_animation_delay: float = 1.2 # En este momento se reproduce la animacion del salto

# El momento temporal en el cual la animación comenzó su reproducción
var animation_started_at : float

# Nota actual fue hiteada?
var note_hited : bool = false

func _ready() -> void:
	PlayerData.reset_score()
	# Loads beatmap
	if beatmap_file:
		var content = beatmap_file.get_as_text()
		beatmap = JSON.parse_string(content)
		if DEBUG: print("beatmap cargado ! \n", beatmap)

	# Starts the Music !
	music.play()
	speakers_animation.play("idle")
	disco_ball_animation.play("show_ball")

func _process(_delta: float) -> void:
	var time: float = get_current_time_playing()
	# Dispara las animaciones leyendo los timers del beatmap
	if not beatmap.is_empty() and time + EPS + 0.5 >= beatmap.front()["time"]:
		# Reproduce la animacion
		var note = beatmap.pop_front()
		animation_ready(note)
		# Obtener el side
		action = note['action']
		print(action)
		if action == 'tap': side = note['side']
		if DEBUG : print(side)
		# Seteamos la ventana
		set_ventana(time)
		# Si note_hited es falso significa que no se hiteo ninguna nota y se reinicia el combo
		if note_hited == false :
			combo_counter.hide_combo()
		# Cada nueva nota se actualiza esto
		note_hited = false

	if action_on_time(time) and note_hited != true:
			combo_counter.update_combo()
			hit_counter.update_score()
			note_hited = true
	
	if Input.is_action_just_pressed('pause_game') :
		get_tree().paused = true
		pause_menu.show_pause_menu()

	return

# Returns the current time of playing of the Music node
func get_current_time_playing():
	var time: float = music.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	return time

# Plays the matching animations according to the side
func animation_ready( note: Dictionary ) -> void:
	var animation: String = note["type"]
	red_pandas.play(animation)


# Retorna true si la acción fue realizada dentro del tiempo permitido
func action_on_time(current_time: float) -> bool :
	if on_time(current_time) == false: return false
	# Ventana de tiempo de accion
	var action_executed: bool
	if action == 'tap':
		action_executed = PlayerMovement.is_stomp_detected(side)
		if DEBUG == true:
			action_executed = Input.is_action_just_pressed("right")
	if action == 'jump':
		action_executed = PlayerMovement.is_jump_detected()
		if DEBUG == true:
			action_executed = Input.is_action_just_pressed("left")
	return action_executed

# Actualiza la ventana actual
func set_ventana(current_time: float) -> void:
	const delays = {'tap' : tap_animation_delay , 'jump': jump_animation_delay}
	
	inicio_ventana = current_time + delays.get(action) - EPS
	fin_ventana = current_time + delays.get(action) + EPS + 0.01

	return

# Checks if still on time to hit the current notew
func on_time(current_time: float) -> bool:
	if current_time > inicio_ventana and current_time < fin_ventana:
		return true
	return false


# Cunado se detiene la musica aparece el puntaje de final de nivel
func _on_music_finished() -> void:
	score_menu.show_score()
	return
