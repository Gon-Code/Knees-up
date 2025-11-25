extends Control

# Nodes
@onready var description: Label = $Description
@onready var level_1_button: Button = $Level1
@onready var level_2_button: Button = $Level2
@onready var username_animation: AnimationPlayer = $UsernameAnimation
@onready var username_alert: Label = $UsernameInput/UsernameAlert
@onready var line_edit: LineEdit = $UsernameInput/LineEdit
# Scenes
const MAIN_MENU = "res://scenes/UI/main_menu.tscn"
const LEVEL_1 = preload("res://scenes/levels/level_1_tutorial.tscn")
const LEVEL_2 = preload("res://scenes/levels/level-2-tutorial.tscn")
const BUTTON_CLICK: AudioStream = preload("res://assets/sfx/button-1.wav")

# Variables
var description_text: String
var default_placeholder: String = "Ingrese su Nombre"

func _ready() -> void:
	# Placeholder debe tener el nombre del usuario actual
	var username = PlayerData.username	
	if username.is_empty():
		line_edit.placeholder_text = default_placeholder
	else:
		line_edit.text = username


func _process(_delta: float) -> void:
	change_description()
	show_username_alert()
	
func _on_level_1_pressed() -> void:
	if username_is_empty(): 
		username_animation.play("shaking") 
		return
	AudioManager.stop_music()
	get_tree().change_scene_to_packed(LEVEL_1)
	AudioManager.play_sfx(BUTTON_CLICK)

func _on_level_2_pressed() -> void:
	if username_is_empty(): 
		username_animation.play("shaking") 
		return
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

# Seteamos el Nombre del usuario dependiendo del Input
func _on_line_edit_text_changed(new_username: String) -> void:
	PlayerData.username = new_username

# Funcion que retorna true si el username es vacio
func username_is_empty() -> bool:
	if PlayerData.username.is_empty(): return true
	return false

# Funcion que oculta la alerta del username 
# Si el username esta vacio muestra la alerta
func show_username_alert() -> void:
	if username_is_empty(): 
		username_alert.visible = true
	else:
		username_alert.visible = false
