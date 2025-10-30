extends Sprite2D


@onready var combo_counter: Node2D = $"../UI/CanvasLayer/ComboCounter"
@onready var hit_counter: Control = $"../UI/CanvasLayer/HitCounter"
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var speed_to_hit_zone: float = 400.0
@export var speed_to_target: float = 600.0
@export var origin: String
@export var accel: Dictionary
@export var on_hit_area = false
@export var on_target_area = false
@export var hit_the_beat = false

# Posiciones inicial y final
const initial_pos_left = Vector2(-66.0,855.0)
const initial_pos_right = Vector2(2066.0,855.0)
const final_pos_left = Vector2(144.0,358.0)
const final_pos_right = Vector2(1726.0, 358.0)

# Tiempre entre punto inicial y la hit zone
const travel_time: float = 1.5 # segundos, desde la izq se demora .3 seg mas que de la derecha
const hit_zone_pos = Vector2(893.0, 805.0)

const hit_zone_pos_left = Vector2(893.0 - 100, 855.0)
const hit_zone_pos_right = Vector2(893.0 + 100, 855.0)

# Si se esta moviendo hacia el target, no la hit zone
var is_ball_moving_to_target: bool = false
var is_ball_moving_to_hit_zone: bool = true

# Incluimos animacion de rotacion a la bola
func _ready() -> void:
	add_to_group("balls")
	animation_player.play('rotate_ball')

# Movemos la bolita
func _process(delta: float) -> void:
	
	if is_ball_moving_to_hit_zone:
		move_ball_to_hit_zone(delta)
	
	if not on_hit_area and PlayerMovement.is_kick_detected(PlayerMovement.accel, origin):
		# Vibrar o emitir sonido de equivocacion
		joycon_rumble(origin)

	if on_hit_area and not hit_the_beat and (PlayerMovement.is_kick_detected(PlayerMovement.accel, origin) or Input.is_action_just_pressed("up")):
		display_message()
		combo_counter.update_combo()
		hit_counter.update_score()
		audio_stream_player.play()
		move_ball_to_target(delta)
		is_ball_moving_to_hit_zone = false
		is_ball_moving_to_target = true
		hit_the_beat = true
	
	if is_ball_moving_to_target:
		move_ball_to_target(delta)
	
	if kick_missed():
		print("Kick Missed")
		combo_counter.hide_combo()
		queue_free()

	if on_target_area:
		print("On target area !")
		queue_free()

# Seteamos initial position e imagen de la bola
func setup(side: String, ball_type: Resource) -> void:
	origin = side
	setup_position()
	setup_ball_texture(ball_type)

func setup_position() -> void:
	if origin == 'left':
		position = initial_pos_left
	if origin == 'right':
		position = initial_pos_right

func setup_ball_texture(ball_type: Resource) -> void:
	texture = ball_type

func move_ball_to_hit_zone(delta: float) -> void:
	if origin == 'left':
		position = position.move_toward(hit_zone_pos_right, speed_to_hit_zone*delta)
	if origin == 'right':
		position = position.move_toward(hit_zone_pos_left, speed_to_hit_zone*delta)
	
	#position = position.move_toward(hit_zone_pos, speed_to_hit_zone*delta)

func move_ball_to_target(delta: float) -> void:
	if origin == 'left':
		position = position.move_toward(final_pos_left, speed_to_target * delta)
	if origin == "right":
		position = position.move_toward(final_pos_right, speed_to_target * delta)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("calibrar"):
		is_ball_moving_to_target = true

func joycon_rumble(side: String) -> void:
	if side == "left":
		PlayerMovement.Gyro.joycon_rumble(0, 0xFFFF, 500)
	else:
		PlayerMovement.Gyro.joycon_rumble(0xFFFF, 0, 500)


# Devuelve un mensaje en pantalla para indicar que tan bien se pateo el balon
# Calcula la distancia entre el balon y la hit zone
func display_message() -> void:
	var cat = get_node("../CatMessage")
	var final_distance = hit_zone_pos.distance_to(global_position)
	if final_distance <= 20:
		cat.message("great")
		print("¡Genial! 🎯")
	elif final_distance <= 40:
		cat.message("good")
		print("¡Bien! 👍")
	else:
		cat.message("ok")
		print("Casi ! 😄")


# Nos dice si no pateamos el balon a tiempo
func kick_missed() -> bool:
	var EPS: float = 0.5
	var distancia: float
	if origin == 'left':
		distancia = position.distance_to(hit_zone_pos_right)	
	if origin == "right":
		distancia = position.distance_to(hit_zone_pos_left)
	
	if distancia < EPS:
		return true
	
	return false
