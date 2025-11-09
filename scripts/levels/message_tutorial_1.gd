extends Control

# Nodes
@onready var message_animation: AnimationPlayer = $AnimationPlayer
@onready var music: AudioStreamPlayer = $"../../../Music"
@onready var animation_player: AnimationPlayer = $"../../../AnimationPlayer"
@onready var panel: Panel = $Panel

# Packed Scene
@onready var LEVEL_1: String = "res://scenes/levels/level_1.tscn"

func _ready() -> void:
	message_animation.play("tutorial_message")

func start_tutorial() -> void:
	# Starts the Music !
	music.play()
	animation_player.play("pulse")
	return

func show_completed_tutorial_menu() -> void:
	panel.show()

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(LEVEL_1)
