extends Node

@export var accel_threshold: float = 1.2 # Umbral en m/s²
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

func _process(delta: float) -> void:
	Gyro.joycon_polling()
	# Diccionario con left / right
	accel = Gyro.joycon_get_acceleration()

# Devuelve true si se detecta una patada en la pierna indicada ('left' o 'right')
func is_kick_detected(accel: Dictionary, leg: String) -> bool:
	leg = switch_controls(leg)
	var values = accel.get(leg, null)
	if values == null:
		return false
	for i in values:
		if abs(i) > accel_threshold:
			print("Accel %s detectada: x=%.2f, y=%.2f, z=%.2f" % [leg.capitalize(), values[0], values[1], values[2]])
			return true
	return false

# Cuando se patea con la pierna izquierda utilizamos el joyCon R
# Cuando se patea con la pierna derecha utilizamos el joyCon L
func switch_controls(side: String) -> String:
	if side == "left":
		return "right"
	else:
		return "left"
