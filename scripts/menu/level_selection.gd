extends Control

@onready var description: Label = $Description
@onready var level_1_button: Button = $Level1
@onready var level_2_button: Button = $Level2

const MAIN_MENU = "res://scenes/UI/main_menu.tscn"
const LEVEL_1 = preload("res://scenes/levels/level_1_tutorial.tscn")
const LEVEL_2 = preload("res://scenes/levels/level-2-tutorial.tscn")
const BUTTON_CLICK: AudioStream = preload("res://assets/sfx/button-1.wav")

var description_text: String

func _process(_delta: float) -> void:
	change_description()

func _on_level_1_pressed() -> void:
	AudioManager.stop_music()
	get_tree().change_scene_to_packed(LEVEL_1)
	AudioManager.play_sfx(BUTTON_CLICK)

func _on_level_2_pressed() -> void:
	AudioManager.stop_music()
	get_tree().change_scene_to_packed(LEVEL_2)
	AudioManager.play_sfx(BUTTON_CLICK)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU)
	AudioManager.play_sfx(BUTTON_CLICK)

# Cambia el texto del Nodo Description
func change_description() -> void:
	if level_1_button.is_hovered():
		description_text = "Pata-Pum! : Patea los balones al ritmo de la música 🎵"
	if level_2_button.is_hovered():
		description_text = "Panda Tap! : Pisa y Salta al ritmo de la música 🎵"
	description.text = description_text
