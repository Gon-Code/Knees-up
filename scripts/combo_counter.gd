extends Node2D

@export var Debug: bool

@onready var contador: Label = $Counter
@onready var combo_counter: Node2D = $"."
@onready var combo_animation: AnimationPlayer = $ComboAnimation

var correct_hits: int = 0

func _ready() -> void:
	combo_counter.visible = false

func _process(_delta: float) -> void:
	# Only for Debugging
	if Debug:
		if Input.is_action_just_pressed("left"):
			hide_combo()
		if Input.is_action_just_pressed("right"):
			update_combo()

# Aumenta el contador de Combo
func update_combo() -> void:
	correct_hits += 1
	if correct_hits > 1 :
		contador.text = str(correct_hits)
		combo_counter.visible = true
		combo_animation.play("update_combo")
	
# Esconde el Combo Counter
func hide_combo() -> void:
	correct_hits = 0
	combo_counter.visible = false
