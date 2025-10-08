extends Node2D


@onready var music: AudioStreamPlayer = $Music


func _ready() -> void:
	# Starts the music !
	music.play()
