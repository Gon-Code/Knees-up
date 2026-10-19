extends Node

# Nombre del jugador actual
var username: String

# Nivel 
var level_name: String

# Dificultad
var difficulty: int = PlayerMovement.difficulty_index

# Full Screen Mode
var full_screen: bool = true

# Colores de los mandos
var left_color: Color = Color('ff3c4a')
var right_color: Color = Color('00b4ff')

# Data Puntuacion
var notas_acertadas: int = 0
var max_combo: int = 0
var puntuacion: int = 0

# Data de la sesion
var session_log: Array = []
var start_time_msec: int = 0
var is_recording: bool = false


# Frecuencia de muestreo: Guardar cada 0.05 segundos (50ms) = 20 muestras/segundo
# Esto es suficiente para análisis clínico y no satura la memoria.
const LOG_INTERVAL: float = 0.05 
var time_accumulator: float = 0.0

# Ruta de exportacion
var full_file_path : String

# Utilizamos ready para inicializar el contador
func _ready():
	start_time_msec = Time.get_ticks_msec()


# En process guardamos la data cada X frames
func _process(delta: float) -> void:
	if not is_recording: return
	
	time_accumulator += delta
	
	if time_accumulator > LOG_INTERVAL:
		time_accumulator = 0.0
		_record_frame_snapshot()

	return

# Funcion que calcula la puntuacion final del jugador
func get_level_score() -> int :
	return notas_acertadas*100 + max_combo*100

# Funcion que retorna el string de la puntuacion final de nivel
func score_text() -> String:
	var final_score_text: String = "Notas Acertadas: %s 
Mejor Combo: %s 

Puntuación: %s " % [notas_acertadas, max_combo, get_level_score()]
	return final_score_text


# Funcion que resetea el score, se debe llamar al comenzar cada nivel 
func reset_score() -> void :
	notas_acertadas = 0
	max_combo = 0
	puntuacion = 0
	session_log.clear() # Limpiamos el log anterior
	start_time_msec = Time.get_ticks_msec() # Reiniciamos el reloj
	return


func _record_frame_snapshot() -> void:
	# 1. Obtener tiempo relativo (desde que empezó el nivel)
	var current_time = Time.get_ticks_msec() - start_time_msec
	
	# Exportamos aceleracion y orientacion
	var a_left = PlayerMovement.accel_l
	var a_right = PlayerMovement.accel_r
	var ang_l = PlayerMovement.angle_l
	var ang_r = PlayerMovement.angle_r
	
	# 3. Guardar en el historial
	session_log.append({
		"time": current_time / 1000.0,
		"al": a_left, # Accel Left
		"ar": a_right, # Accel Right
		"angl": ang_l,
		"angr": ang_r,
	})


# Funcion que guarda la data del usuario en un archivo csv
# El archivo se guarda en la ruta data/anio/mes/dia/<username-hora>.csv
# La data que se guarda es la siguiente
# Nivel jugado, notas acertadas, max combo, username, hora, dificultad, pantalla completa
# colores joy con, volumen, gyro data, accel data
# --- EXPORTACIÓN OPTIMIZADA PARA EXCEL (ESPAÑOL) ---
func export_data() -> void:
	# Preparar Ruta y Nombre
	var dt = Time.get_datetime_dict_from_system()
	var year = str(dt["year"])
	var month = str(dt["month"]).pad_zeros(2)
	var day = str(dt["day"]).pad_zeros(2)
	var hour = str(dt["hour"]).pad_zeros(2)
	var minute = str(dt["minute"]).pad_zeros(2)
	
	var base_dir = ""
	if OS.has_feature("editor"):
		base_dir = ProjectSettings.globalize_path("res://")
	else:
		base_dir = OS.get_executable_path().get_base_dir()
	
	var folder = "data".path_join(year).path_join(month).path_join(day)
	var full_dir = base_dir.path_join(folder)
	var file_name = "%s-%s-%s.csv" % [username, hour, minute]
	full_file_path = full_dir.path_join(file_name)
	
	if not DirAccess.dir_exists_absolute(full_dir):
		DirAccess.make_dir_recursive_absolute(full_dir)

	var file = FileAccess.open(full_file_path, FileAccess.WRITE)
	
	if file:
		file.store_line("sep=;") 

		#  Escribir Header
		# Columnas A-I: Datos | Columna K: Separador | Columna L-M: Resumen
		var header = "Time_s;AccelL_X;AccelL_Y;AccelL_Z;AccelR_X;AccelR_Y;AccelR_Z;Angle_L;Angle_R;;;Campo;Valor"
		file.store_line(header)

		# Creamos una lista con los datos del resumen para ir pegándolos fila por fila
		var resumen_data = [
			["Jugador", username],
			["Fecha", "%s-%s-%s" % [day, month, year]],
			["Hora", "%s:%s" % [hour, minute]],
			["Nivel", level_name],
			["Dificultad", str(difficulty)],
			["Puntuacion", str(get_level_score())],
			["Max Combo", str(max_combo)],
			["Notas Acertadas", str(notas_acertadas)]
		]
		
		# ESCRIBIR FILAS DE DATOS + RESUMEN LATERAL
		for i in range(session_log.size()):
			var entry = session_log[i]

			# Formateamos los números con coma decimal
			# Helper function local para convertir float a string con coma
			var t = ("%.3f" % entry["time"]).replace(".", ",")
			var al_x = ("%.4f" % entry["al"].x).replace(".", ",")
			var al_y = ("%.4f" % entry["al"].y).replace(".", ",")
			var al_z = ("%.4f" % entry["al"].z).replace(".", ",")
			var ar_x = ("%.4f" % entry["ar"].x).replace(".", ",")
			var ar_y = ("%.4f" % entry["ar"].y).replace(".", ",")
			var ar_z = ("%.4f" % entry["ar"].z).replace(".", ",")
			var ang_l = ("%.2f" % entry["angl"]).replace(".", ",")
			var ang_r = ("%.2f" % entry["angr"]).replace(".", ",")
			
			# B. Construimos la parte izquierda (Datos)
			var row_str = "%s;%s;%s;%s;%s;%s;%s;%s;%s;;;" % [t, al_x, al_y, al_z, ar_x, ar_y, ar_z, ang_l, ang_r]
			
			# C. Construimos la parte derecha (Resumen) solo si quedan datos
			if i < resumen_data.size():
				var meta_key = resumen_data[i][0]
				var meta_val = resumen_data[i][1]
				row_str += "%s;%s" % [meta_key, meta_val]
			else:
				row_str += ";" # Celdas vacías a la derecha
			
			file.store_line(row_str)
			
		file.close()
		print("✅ Excel guardado: ", full_file_path)
	else:
		printerr("❌ Error guardando CSV")
