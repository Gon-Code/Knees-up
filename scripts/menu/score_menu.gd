extends Control

@onready var score: Label = $PopupPanel/VBoxContainer/Score

func _ready() -> void:
	pass

# Mostramos el score final
func show_score() -> void:
	visible = true
	score.text = PlayerData.score_text()
	return

# Esta función recarga la escena activa (el nivel completo).
func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()
	return

# Boton volver al menu
func _on_back_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/main_menu.tscn")
	return
