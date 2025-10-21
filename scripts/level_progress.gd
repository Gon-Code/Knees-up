extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var music: AudioStreamPlayer = $"../../../Music"


func _ready() -> void:
	set_progress_bar()
	
func _process(_delta: float) -> void:
	update_progress_bar()
	return

# Iniciliza los valores de la barra de progreso
func set_progress_bar() -> void:
	progress_bar.min_value = 0.0
	progress_bar.value = 0.0
	progress_bar.max_value = music.stream.get_length()
	return

func update_progress_bar() -> void:
	if music.playing:
		progress_bar.value = music.get_playback_position()
	return
