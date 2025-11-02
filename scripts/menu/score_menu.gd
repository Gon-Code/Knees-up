extends Control

const MAIN_MENU: PackedScene = preload("res://scenes/UI/main_menu.tscn")

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
	get_tree().change_scene_to_packed(MAIN_MENU)
	
