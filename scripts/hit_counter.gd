extends Control

@export var DEBUG : bool = false
@onready var vinil_animation: AnimationPlayer = $VinilAnimation
@onready var effects_animation: AnimationPlayer = $EffectsAnimation
@onready var score_label: Label = $Score
@onready var score: int = 0
@onready var effects: Node2D = $Effects

func _ready() -> void:
	vinil_animation.play('move_vinilo')
	effects.visible = false

func _process(_delta: float) -> void:
	if DEBUG and Input.is_action_just_pressed("right"):
		update_score()
	

# Actualiza el valor en pantalla del puntaje
# Cada hit vale x 100
func update_score() -> void:
	score =  int(score_label.text) + 100
	score_label.text = str(score)
	PlayerData.notas_acertadas += 1
	effects_animation.play("hit")
	
