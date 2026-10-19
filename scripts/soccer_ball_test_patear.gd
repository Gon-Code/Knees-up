extends Node2D

@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	# Printea los dispositivos conectados
	for device_id in Input.get_connected_joypads():
		print("Joypad conectado: ", Input.get_joy_name(device_id))

func _process(_delta: float) -> void:
	# Los datos de gyro/accel ya los procesa el autoload PlayerMovement
	if PlayerMovement.is_kick_detected("left"):
		animation_tree["parameters/playback"].travel("Move_right")
	if PlayerMovement.is_kick_detected("right"):
		animation_tree["parameters/playback"].travel("Move_left")
