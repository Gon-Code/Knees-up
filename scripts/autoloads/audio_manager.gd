extends Node

# Global Sound
var volume: float = 1.0

# Nodes
@onready var music: AudioStreamPlayer = $MusicPlayer
@onready var sfx: AudioStreamPlayer = $SFXPlayer

# Reproducir música de fondo (OGG)
func play_music(stream: AudioStream) -> void:
	if not stream:
		return
	music.stop()
	music.stream = stream
	if stream is AudioStreamOggVorbis: stream.loop = true
	music.play()

# Detener música
func stop_music() -> void:
	music.stop()

# Reproducir efecto de sonido (WAV)
func play_sfx(stream: AudioStream) -> void:
	if not stream:
		return
	sfx.stop()
	sfx.stream = stream
	sfx.play()
