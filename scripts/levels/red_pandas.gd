extends Node2D

@onready var pandas_animation: AnimationPlayer = $PandasAnimation
@onready var player_animation: AnimationPlayer = $Player/AnimationPlayer
@onready var pandas_tree: AnimationTree = $PandasTree
@onready var player_animation_tree: AnimationTree = $Player/PlayerAnimationTree
@onready var pandas_state_machine: AnimationNodeStateMachinePlayback = pandas_tree.get("parameters/playback")
@onready var player_state_machine: AnimationNodeStateMachinePlayback = player_animation_tree.get("parameters/playback")


func _ready() -> void:
	activate_trees()

# Despacha la animacion indicada en los 3 pandas
# Recibe un string, el cual indica la animacion
func play(animation: String) -> void:
	match animation:
		"left_tap":
			play_left_tap()
		"right_tap":
			play_right_tap()
		"jump":
			play_jump()

# Reproduce la animacion left_tap en los 3 pandas
func play_left_tap() -> void:
	pandas_state_machine.travel("left_tap")
	if player_state_machine.get_current_node() != "left_tap":
		player_state_machine.travel("left_tap")

# Reproduce la animacion right_tap en los 3 pandas
func play_right_tap() -> void:
	pandas_state_machine.travel("right_tap")
	if player_state_machine.get_current_node() != "right_tap":
		player_state_machine.travel("right_tap")

# Reproduce la animacion jump en los 3 pandas
func play_jump() -> void:
	pandas_state_machine.travel("jump")
	player_state_machine.travel("jump")

# Activa los animation tree
# No lo dejamos por default porque arruina el debugging
func activate_trees() -> void:
	pandas_tree.active = true
	player_animation_tree.active = true
