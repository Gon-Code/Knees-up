extends Node

@export var accel_threshold_kick: float = 0.4 # Umbral en m/s²
@export var accel_treshold_stomp: float = -1.0
@export var accel_threshold_jump: float = 1.0 
@export var accel: Dictionary

# Giroscopio
var Gyro = SDLGyro.new()

func _ready() -> void:
	# Printea los dispositivos conectados
	for device_id in Input.get_connected_joypads():
		print("Joypad conectado: ", Input.get_joy_name(device_id))
	# Inicializa la libreria SDLGyro
	Gyro.sdl_init()
	Gyro.init_joycons()
	Gyro.joycon_auto_calibration()

func _process(_delta: float) -> void:
	Gyro.joycon_polling()
	# Diccionario con left / right
	accel = Gyro.joycon_get_acceleration()

# Devuelve true si se detecta una patada en la pierna indicada ('left' o 'right')
func is_kick_detected(acceleration: Dictionary, leg: String) -> bool:
	leg = switch_controls(leg)
	var current_accel = acceleration.get(leg, null)
	if current_accel == null:
		return false
	if leg == 'right' and -current_accel.x > accel_threshold_kick and current_accel.z > accel_threshold_kick:
			print("Accel %s detectada: x=%.2f, y=%.2f, z=%.2f" % [leg.capitalize(),
																  current_accel[0],
																  current_accel[1],
																  current_accel[2]])
			return true
	if leg == 'left' and current_accel.x > accel_threshold_kick and current_accel.z > accel_threshold_kick:
			print("Accel %s detectada: x=%.2f, y=%.2f, z=%.2f" % [leg.capitalize(),
																  current_accel[0],
																  current_accel[1],
																  current_accel[2]])
			return true
	
	return false

# Devuelve true si se detecta un stomp en la pierna indicada ('left', 'right')
# Solo nos importa la aceleracion hacia abajo en el eje Z
func is_stomp_detected(leg: String) -> bool:
	var control = switch_controls(leg)
	var current_accel: Vector3 = accel.get(control,null)
	if current_accel == null:
		return false
	if current_accel.z < accel_treshold_stomp:
		print("Stomp detectado Pierna ", leg)
	return false

# Devuelve true si se detecta un salto (ambas piernas con Z por sobre el umbral)
func is_jump_detected() -> bool:
	var left_values: Vector3 = accel.get("left", null)
	var right_values: Vector3 = accel.get("right", null)
	
	if left_values == null or right_values == null:
		return false
	
	var left_z = left_values.z   # eje Z pierna izquierda
	var right_z = right_values.z # eje Z pierna derecha
	
	# Chequea si ambas superan el umbral
	if left_z > accel_threshold_jump and right_z > accel_threshold_jump:
		print("Salto detectado 🚀")
		return true
	
	return false

# Cuando se patea con la pierna izquierda utilizamos el joyCon R
# Cuando se patea con la pierna derecha utilizamos el joyCon L
func switch_controls(side: String) -> String:
	if side == "left":
		return "right"
	else:
		return "left"
