extends Control

@onready var full_screen_button: CheckButton = $OptionsList/FullScreen/FullScreenMode


# Control de Audio
func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear_to_db(value))


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
