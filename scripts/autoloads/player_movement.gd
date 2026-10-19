extends Node

# Nivel de Dificultad 
@export var difficulty_index: int = 0

const difficulty_thresholds = [ [0.2, 0.75, 0.4], [0.5, 1.3, 0.4], [0.75, 1.5, 0.4] ]

# Thresholds-Umbral en m/s²
@export var accel_threshold_kick: float = 0.2
@export var accel_threshold_stomp: float = 0.75
@export var accel_threshold_jump: float = 0.4

@export var accel_l: Vector3 = Vector3.ZERO
@export var accel_r: Vector3 = Vector3.ZERO
@export var gyro_l: Vector3 = Vector3.ZERO
@export var gyro_r: Vector3 = Vector3.ZERO
@export var quat_l: Quaternion = Quaternion.IDENTITY
@export var quat_r: Quaternion = Quaternion.IDENTITY

# --- NUEVO: Calibración Fija y Ángulos ---
# Valores hardcoded (pre-calculados) para la posición inicial
var q_init_l: Quaternion = Quaternion(-0.71357, -0.012367, 0.000615, 0.700475)
var q_init_r: Quaternion = Quaternion(-0.711852, 0.079752, -0.072384, 0.694022)

# Variables donde guardaremos el ángulo de flexión calculado (Grados)
var angle_l: float = 0.0
var angle_r: float = 0.0

# Inicializar gdextension
var Gyro = SDLGyro.new()
var data

func _ready() -> void:
	# Printea los dispositivos conectados
	for device_id in Input.get_connected_joypads():
		print("Joypad conectado: ", Input.get_joy_name(device_id))

	# Inicializa la libreria SDLGyro
	Gyro.sdl_init()
	Gyro.joycon_init()
	Gyro.joycon_auto_calibration()

func _process(_delta: float) -> void:
	data = Gyro.joycon_polling()
	update_data(data)
	calculate_angles()

# Devuelve true si se detecta una patada en la pierna indicada ('left' o 'right')
func is_kick_detected(leg: String) -> bool:
	var control = switch_controls(leg)
	var current_accel = accel_l if control == 'left' else accel_r
	# JoyCon Izquierdo Azul - Pierna Derecha
	if leg == 'right' and current_accel.x < -accel_threshold_kick and current_accel.z  < accel_threshold_kick:
			print("Aceleracion Control %s detectada: x=%.2f, y=%.2f, z=%.2f" % [control.capitalize(),
																  current_accel[0],
																  current_accel[1],
																  current_accel[2]])
			return true
	# JoyCon Derecho Rojo - Pierna Izquierda
	if leg == 'left' and current_accel.x > accel_threshold_kick and current_accel.z < accel_threshold_kick:
			print("Aceleracion Control %s detectada: x=%.2f, y=%.2f, z=%.2f" % [control.capitalize(),
																  current_accel[0],
																  current_accel[1],
																  current_accel[2]])
			return true

	return false

# Devuelve true si se detecta un stomp en la pierna indicada ('left', 'right')
# Solo nos importa la aceleracion hacia abajo en el eje Z
func is_stomp_detected(leg: String) -> bool:
	var control = switch_controls(leg)
	var current_accel: Vector3 = accel_l if control == 'left' else accel_r
	# JoyCon Izquierdo - Pierna derecha
	if leg == 'right' and current_accel.z  > accel_threshold_stomp:
		print("Stomp detectado Pierna 💥 ", leg, " con el control ", control)
		return true
	# JoyCon Derecho - Pierna Izquierda - Z positivo hacia abajo
	if leg == 'left' and current_accel.z - 0.5 > accel_threshold_stomp:
		print("Stomp detectado Pierna 💥 ", leg, " con el control ", control)
		print("Aceleracion Control %s detectada: x=%.2f, y=%.2f, z=%.2f" % [control.capitalize(),
																  current_accel[0],
																  current_accel[1],
																  current_accel[2]])
		return true
	
	if Input.is_action_just_pressed("right"):
		return true

	return false

# Devuelve true si se detecta un salto (ambas piernas con Z por sobre el umbral)
func is_jump_detected() -> bool:
	var left_values: Vector3 = accel_l
	var right_values: Vector3 = accel_r
	
	var left_z = left_values.z   # eje Z pierna izquierda
	var right_z = right_values.z # eje Z pierna derecha
	
	# Chequea si ambas superan el umbral
	# Chequeamos que suban rapido, es decir, que Z sea negativo
	if left_z >= accel_threshold_jump and right_z >= accel_threshold_jump:
		print("Salto detectado 🚀")
		return true
	if Input.is_action_just_pressed("right"):
		return true
		
	return false


# Cuando se patea con la pierna izquierda utilizamos el joyCon R
# Cuando se patea con la pierna derecha utilizamos el joyCon L
func switch_controls(side: String) -> String:
	if side == "left":
		return "right"
	else:
		return "left"


# Funcion que setea los threshold de cada movimiento
# Aumenta el threshold dependiendo de la dificultad
func set_difficulty(index: int) -> void:
	difficulty_index = index
	accel_threshold_kick = difficulty_thresholds[difficulty_index][0]
	accel_threshold_stomp = difficulty_thresholds[difficulty_index][1]
	accel_threshold_jump = difficulty_thresholds[difficulty_index][2]
	return


# Actualiza datos de gyro, accel y orientacion
func update_data(joycon_data: Dictionary) -> void:

	if joycon_data.is_empty():
		return

	accel_l = joycon_data.get("accel_l", Vector3.ZERO)
	accel_r = joycon_data.get("accel_r", Vector3.ZERO)
	
	gyro_l = joycon_data.get("gyro_l", Vector3.ZERO)
	gyro_r = joycon_data.get("gyro_r", Vector3.ZERO)

	quat_l = joycon_data.get("quat_l", Quaternion.IDENTITY)
	quat_r = joycon_data.get("quat_r", Quaternion.IDENTITY)
	
	return


# Calcula el angulo de movimiento
func calculate_angles() -> void:
	# 1. Diferencia relativa: Q_inicial_inv * Q_actual
	var q_diff_l = q_init_l.inverse() * quat_l
	var q_diff_r = q_init_r.inverse() * quat_r
	
	# 2. Convertir a Euler
	var euler_l = q_diff_l.get_euler()
	var euler_r = q_diff_r.get_euler()
	
	# 3. Extraer eje Y (Bisagra de la rodilla) y convertir a grados
	angle_l = rad_to_deg(euler_l.y)
	angle_r = rad_to_deg(euler_r.y)
