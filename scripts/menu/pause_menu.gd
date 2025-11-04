extends Control

# Scenes
const MAIN_MENU = "res://scenes/UI/main_menu.tscn"

# Nodes
@onready var menu_animation: AnimationPlayer = $MenuAnimation

# Containers
@onready var pause_container: VBoxContainer = $Panel/PauseContainer
@onready var retry_container: VBoxContainer = $Panel/RetryContainer
@onready var back_to_menu_container: VBoxContainer = $Panel/BackToMenuContainer

func _ready() -> void:
	pause_container.visible = true
	retry_container.visible = false
	back_to_menu_container.visible = false
	
	return	

# Funcion que muestra el menu de pausa
func show_pause_menu() -> void:
	visible = true
	retry_container.visible = false
	back_to_menu_container.visible = false
	
	pause_container.visible = true

	return

# Funcion que muestra el menu de reiniciar el nivel
func show_retry_menu() -> void:
	pause_container.visible = false
	back_to_menu_container.visible = false
	
	retry_container.visible = true

	return

# Funcion que muestra el menu para volver al menu principal
func show_return_menu() -> void:
	pause_container.visible = false
	retry_container.visible = false
	
	back_to_menu_container.visible = true

	return


# Funcionalidades de los botones 

# Boton Continuar
# Inicia una cuenta regresiva
func _on_continue_pressed() -> void:
	menu_animation.play("continue_countdown")
	return

# Boton Reiniciar nivel del menu de pausa
# Muestra el menu de reinicio de nivel
func _on_retry_pressed() -> void:
	show_retry_menu()
	return

# Boton Volver al menu
# Muestra el menu para confirmar el viaje al menu principal
func _on_back_to_menu_pressed() -> void:
	show_return_menu()
	return

# Boton Reiniciar nivel del menu de reiniciar nivel
# Al presionar el botón se reinicia el nivel actual
func _on_retry_level() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	return

# Botón de cancelar
# Vuelve a mostrar el primer menu de pausa
func _on_cancel_pressed() -> void:
	show_pause_menu()
	return
	

# Boton volver al menu desde el menu de confirmacion
# Al presionar este botón retornamos al menu principal del juego
func _on_back_to_menu_button() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU)
	return

# Funcion que se llama al final de la animacion del countdown
# Despausa la escena principal
func unpaused_game() -> void:
	get_tree().paused = false
	visible = false
	return
