extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cue: Sprite2D = $Cue

#funcion para cambiar el color del cue izquierdo
func change_left_color() -> void:
	cue.self_modulate = PlayerData.left_color

#funcion para cambiar el color del cue dercho
func change_right_color() -> void:
	cue.self_modulate = PlayerData.right_color

func change_jump_color() -> void:
	var c1: Color = PlayerData.left_color
	var c2: Color = PlayerData.right_color
	var mixed_color: Color = Color()
	mixed_color.r = (c1.r + c2.r) / 2.0
	mixed_color.b = (c1.b + c2.b) / 2.0
	mixed_color.g = c1.g * c2.g
	cue.self_modulate = mixed_color
