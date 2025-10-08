extends Node2D

@onready var pandas_animation: AnimationPlayer = $PandasAnimation
@onready var player_animation: AnimationPlayer = $Player/AnimationPlayer

# Despacha la animacion indicada en los 3 pandas
# Recibe un string, el cual indica la animacion
func play(animation: String) -> void:
	print("debug")
	match animation:
		"idle":
			play_idle()
		"left_tap":
			play_left_tap()
		"right_tap":
			play_right_tap()
		"jump":
			play_jump()

# Reproduce la animacion idle en los 3 pandas
func play_idle() -> void:
	pandas_animation.play("idle")
	player_animation.play("idle")

# Reproduce la animacion left_tap en los 3 pandas
func play_left_tap() -> void:
	pandas_animation.play("left_tap")
	player_animation.play("left_tap")

# Reproduce la animacion right_tap en los 3 pandas
func play_right_tap() -> void:
	pandas_animation.play("right_tap")
	player_animation.play("right_tap")

# Reproduce la animacion jump en los 3 pandas
func play_jump() -> void:
	pandas_animation.play("jump")
	player_animation.play("jump")
	
