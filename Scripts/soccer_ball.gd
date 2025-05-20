extends Node2D

@export var speed: float = 300.0
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var timer: Timer = $Timer
@onready var playback = animation_tree.get("parameters/playback")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#Inicializar el Giroscopio
var Gyro = SDLGyro.new()
var orientation = Quaternion()

# Si se supera este umbral generamos el movimiento
const THRESHOLD = 50.0
const DEAD_ZONE = 5.0

func _ready() -> void:

	for device_id in Input.get_connected_joypads():
		print("Joypad conectado: ", Input.get_joy_name(device_id))
	Gyro.sdl_init()
	Gyro.controller_init()
	#animation_player.play("Idle")
	
func _process(delta: float) -> void:
	Gyro.gamepad_polling()
	var angular_velocity = Gyro.get_calibrated_gyro()
	if Input.is_action_pressed("left"):
		playback.travel("Move_left")
	if Input.is_action_pressed("right"):
		playback.travel("Move_right")
	
	
