extends CharacterBody2D

@export var speed: float = 300.0

var Gyro = SDLGyro.new()
var orientation = Quaternion() # Para guardar orientación raw del giroscopio

func _ready() -> void:
	for device_id in Input.get_connected_joypads():
		print("Joypad conectado: ", Input.get_joy_name(device_id))
	Gyro.sdl_init()
	Gyro.controller_init()

func _physics_process(delta):
	# Activar calibracion continua
	#Gyro.calibrate()
	#Gyro.get_calibrated_gyro()
	#print(Gyro.get_processed_acceleration())
	
	# Obtener orientación del giroscopio
	orientation = Gyro.gamepad_polling()
	
	# Nos interesa el componente X del giro (en este caso, orientación horizontal)
	var gyro_x = orientation[1]  # ⚠️ Puedes experimentar también con [0] o [2]

	# Mover al personaje en el eje X en base al valor del giroscopio
	velocity.x = -gyro_x * speed

	# Bloquear el movimiento vertical
	velocity.y = 0

	move_and_slide()
