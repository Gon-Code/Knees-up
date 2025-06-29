extends Node2D

@export var speed: float = 300.0
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var timer: Timer = $Timer
@onready var playback = animation_tree.get("parameters/playback")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

## Variables

# Giroscopio
var Gyro = SDLGyro.new()
var orientation = Quaternion()

# Umbrales
const STOMP_THRESHOLD = -30.0

# Timer para el stomp, posiblemente lo reutilicemos para cualquier animacion
var stomp_coldown = 1.0
var stomp_timer = 0.0

# Calibración hardware
var is_calibrating := false
var calibration_duration := 10.0
var elapsed_time := 0.0

func _ready() -> void:
	# Printea los dispositivos conectados
	for device_id in Input.get_connected_joypads():
		print("Joypad conectado: ", Input.get_joy_name(device_id))
	
	# Inicializa la libreria SDLGyro
	Gyro.sdl_init()
	Gyro.controller_init()
	
	print("Presiona 'C' para calibrar el giroscopio.")

func _process(delta: float) -> void:
	# Returns the orientation.
	Gyro.gamepad_polling()
	
	if Input.is_action_just_pressed("calibrar"):
		calibrar_gyro()
	
	if Input.is_action_just_pressed("left"):
		playback.travel('Move_left')
		
	if Input.is_action_just_pressed("right"):
		playback.travel("Move_right")
		
	if is_calibrating:
		procesar_calibracion(delta)
	else:
		procesar_movimiento()
	
			
## Calibración del Giroscopio
##
## Al presionar la tecla C se calibra durante 10 segundos el giroscopio
## Para obtener mejores resultados es necesario dejar en reposo el control
## Mejores resultados significa obtener aceleraciones cercanas a 0 en los 3 ejes
func calibrar_gyro() -> void:
	is_calibrating = true
	elapsed_time = 0.0
	Gyro.calibrate()
	print("🛠️ Iniciando calibración de hardware por ", calibration_duration, " segundos...")

## Procesar Calibracion
##
## Calibra el gyroscopio por 10 segundos 
func procesar_calibracion(delta: float) -> void:
	
	elapsed_time += delta

	if elapsed_time >= calibration_duration:
		Gyro.stop_calibrate()
		is_calibrating = false
		print("✅ Calibración de hardware completada.")
	else:
		print("⏳ Calibrando hardware... ", (calibration_duration - elapsed_time), "s restantes.")

		
## Procesar Movmiento
##
## Printea la aceleracion del giroscopio
func procesar_movimiento() -> void:
	var acceleration = Gyro.get_processed_acceleration()
	#print("📈 Aceleracion Procesada: ", acceleration)
	
	# Disminuir el temporizador si esta activo
	if stomp_timer > 0.0 :
		stomp_timer -= get_process_delta_time()
		return

	if stomp(acceleration):
		stomp_timer = stomp_coldown
		playback.travel("Move_right")

## Funcion stomp
##
## Corrobora en tiempo real si el jugador realizo un stomp
## Primero se debe corroborar si se genero una aceleracion positiva 
## en el eje Y
## Luego se debe corroborar una aceleracion negativa en el eje Y
## 
## Por simplicidad comenzaremos solo matcheando con una aceleracion rapida hacia 
## abajo i.e aceleracion negativa en el eje Y
func stomp(acceleration: Vector3) -> bool:
	
	if acceleration.y < STOMP_THRESHOLD:
		print("STOMP DETECTED 💥💥💥")
		return true

	return false
