extends Node2D

@export var accel_threshold: float = 1.2 # Umbral en m/s²
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

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
	var accel: Dictionary = Gyro.joycon_get_acceleration()
	if PlayerMovement.is_kick_detected(accel,"left") :
		animation_tree["parameters/playback"].travel("Move_right")
	if PlayerMovement.is_kick_detected(accel,"right"):
		animation_tree["parameters/playback"].travel("Move_left")
