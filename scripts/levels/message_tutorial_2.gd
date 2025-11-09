extends Control

# Nodes
@onready var message_animation: AnimationPlayer = $AnimationPlayer
@onready var music: AudioStreamPlayer = $"../../../Music"
@onready var panel: Panel = $Panel

# Packed Scene
@onready var LEVEL_2: String = "res://scenes/levels/level-2.tscn"

func _ready() -> void:
	message_animation.play("intro_message")

func start_tutorial() -> void:
	# Starts the Music !
	music.play()
	message_animation.play("tutorial_level_2")
	return

func show_completed_tutorial_menu() -> void:
	panel.show()

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_2)
