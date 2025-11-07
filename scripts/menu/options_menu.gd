extends Control

@onready var full_screen_button: CheckButton = $OptionsList/FullScreen/FullScreenMode

@onready var volume: HSlider = $OptionsList/Volumen/Volume
@onready var option_button: OptionButton = $OptionsList/Dificultad/OptionButton
@onready var left_color: ColorPickerButton = $OptionsList/LeftControlColor/LeftColor
@onready var right_color: ColorPickerButton = $OptionsList/RightControlColor/RightColor
@onready var full_screen_mode: CheckButton = $OptionsList/FullScreen/FullScreenMode

# Aqui siempre actualizamos con los valores globales
func _ready() -> void:
	volume.value = AudioManager.volume
	option_button.selected = PlayerMovement.difficulty_index
	left_color.color = PlayerData.left_color
	right_color.color = PlayerData.right_color
	full_screen_mode.button_pressed =  PlayerData.full_screen
	return

# Control de Audio
func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear_to_db(value))
	AudioManager.volume = value
	return

# Botón cambio de dificultad
func _on_option_button_item_selected(index: int) -> void:
	PlayerMovement.set_difficulty(index)
	return

# Funcion para cambiar el color del control de la pierna izquierda
func _on_left_color_changed(color: Color) -> void:
	PlayerData.left_color = color
	return

# Funcion para cambiar el color del control de la pierna derecha
func _on_right_color_changed(color: Color) -> void:
	PlayerData.right_color = color
	return


# Botón pantalla completa
# Activamos el modo pantalla completa si esta en modo ventana
# Si esta en modo ventana, activa el modo pantalla compelta
func _on_full_screen_mode_activated() -> void:
	if full_screen_button.button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(1280, 720))

	return

# Presionar el botón volver al menú principal
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
	return
