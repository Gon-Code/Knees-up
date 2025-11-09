extends Control


const MAIN_MENU: String = "res://scenes/UI/main_menu.tscn"
const BUTTON_CLICK: AudioStream = preload("res://assets/sfx/button-1.wav")

func _on_back_pressed() -> void:
	AudioManager.play_sfx(BUTTON_CLICK)
	get_tree().change_scene_to_file(MAIN_MENU)
