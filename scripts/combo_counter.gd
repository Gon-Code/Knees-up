extends Node2D

@export var Debug: bool

@onready var contador: Label = $Counter
@onready var combo_counter: Node2D = $"."
@onready var combo_animation: AnimationPlayer = $ComboAnimation
@onready var musical_rain_effect: CPUParticles2D = $MusicalRainEffect

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
	if correct_hits >= 1 :
		contador.text = str(correct_hits)
		combo_counter.visible = true
		combo_animation.play("update_combo",)
	if correct_hits > 6 :
		start_rain_effect()
	if correct_hits >= 10:
		contador.position.x = -27.0

# Esconde el Combo Counter
func hide_combo() -> void:
	correct_hits = 0
	combo_counter.visible = false
	contador.position = Vector2(3.0,0.0)
	hide_musical_rain_effect()


# Aumenta la cantidad de notas generadas dependiendo del combo counter
func start_rain_effect() -> void:
	if musical_rain_effect.emitting == true : return
	musical_rain_effect.emitting = true
	musical_rain_effect.amount = 10


# Detiene la generacion de notas musicales
func hide_musical_rain_effect() -> void :
	musical_rain_effect.emitting = false
	musical_rain_effect.scale = Vector2(1.0,1.0)
