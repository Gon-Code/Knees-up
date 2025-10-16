extends Node2D

@onready var beatmap_file = FileAccess.open("res://assets/level-2/beatmap.json", FileAccess.READ)
@onready var music: AudioStreamPlayer = $Music
@onready var red_pandas: Node2D = $RedPandas
@onready var speakers_animation: AnimationPlayer = $UI/Speakers/SpeakersAnimation
@onready var disco_ball_animation: AnimationPlayer = $UI/MirrorBalls/DiscoBallAnimation


var beatmap = []
const EPS := 0.5  # pequeña tolerancia para jitter

func _ready() -> void:
	# Loads beatmap
	if beatmap_file:
		var content = beatmap_file.get_as_text()
		beatmap = JSON.parse_string(content)
		print("beatmap cargado ! \n", beatmap)
		
	# Starts the Music !
	music.play()
	speakers_animation.play("idle")
	disco_ball_animation.play("show_ball")

func _process(_delta: float) -> void:
	var time: float = get_current_time_playing()

	while not beatmap.is_empty() and time + EPS + 0.5 >= beatmap.front()["time"]:
		var note = beatmap.pop_front()
		animation_ready(note)
		print(note)
		print(time)	
	return

# Returns the current time of playing of the Music node
func get_current_time_playing():
	var time: float = music.get_playback_position() + AudioServer.get_time_since_last_mix() - AudioServer.get_output_latency()
	return time

# Plays the matching animations according to the side
func animation_ready( note: Dictionary ) -> void:
	var animation: String = note["type"]
	red_pandas.play(animation)
