extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer



func _ready() -> void:
	message("idle")

# Debemos crear funciones para llamar a las distintas animaciones del gato
func message(msg: String) -> void:
	animation_player.play(msg)
