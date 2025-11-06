extends Control
## Script que maneja los botones del menú principal, usando el sistema de AudioManager global

# Recursos precargados (más eficiente que load())
const OPTIONS_MUSIC: AudioStream = preload("res://assets/sfx/options.ogg")
const MAIN_MENU_MUSIC: AudioStream = preload("res://assets/sfx/menu_principal.ogg")
const LEVEL_SELECTION: PackedScene = preload("res://scenes/UI/level_selection.tscn")
const OPTIONS_MENU: PackedScene = preload("res://scenes/options_menu.tscn")
const BUTTON_CLICK: AudioStream = preload("res://assets/sfx/button-1.wav")

## Funcion Ready, reproducimos la música de inicio
func _ready() -> void:
	AudioManager.play_music(MAIN_MENU_MUSIC)

## Funcion para salir del juego con el boton Salir
func _on_exit_pressed() -> void:
	AudioManager.play_sfx(BUTTON_CLICK)
	get_tree().quit()

## Botón Options
## Cambia la música de fondo
func _on_options_pressed() -> void:
	AudioManager.play_sfx(BUTTON_CLICK)
	await get_tree().process_frame # esperar un frame
	get_tree().change_scene_to_packed(OPTIONS_MENU)
	AudioManager.play_music(OPTIONS_MUSIC)

## Botón Load (aún no implementado)
func _on_load_pressed() -> void:
	AudioManager.play_sfx(BUTTON_CLICK)

## Botón Nueva Partida
## Abre el menú de selección de Nivel
func _on_new_pressed() -> void:
	AudioManager.play_sfx(BUTTON_CLICK)
	await AudioManager.sfx.finished # esperamos que termine el clic
	get_tree().change_scene_to_packed(LEVEL_SELECTION)
