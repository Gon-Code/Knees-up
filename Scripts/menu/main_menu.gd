extends Control
## Script que maneja los botones del menu principal, incluyendo los sfx

## Variables Globales on ready
@onready var music: AudioStreamPlayer = $BackgroudMusic
@onready var button_effect: AudioStreamPlayer = $ButtonMusicEffect

# Variables Globales
var options_music = load("res://assets/sfx/options.mp3")
var main_menu_music = load("res://assets/sfx/menu_principal.wav")

## Funcion para salir del juego con el boton Salir
func _on_exit_pressed() -> void:
	button_effect.play()
	get_tree().quit()

## Boton Options
##
## Al presionarlo cambia la musica 
## TODO: Al presionarlo muestra el menu de opciones
func _on_options_pressed() -> void:
	button_effect.play()
	music.stream = options_music
	music.play()

func _on_load_pressed() -> void:
	button_effect.play()

func _on_new_pressed() -> void:
	button_effect.play()
