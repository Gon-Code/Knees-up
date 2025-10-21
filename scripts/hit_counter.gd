extends Control

@onready var vinil_animation: AnimationPlayer = $VinilAnimation
@onready var effects_animation: AnimationPlayer = $Effects/EffectsAnimation
@onready var score_label: Label = $Score
@onready var score: int = 0

func _ready() -> void:
	vinil_animation.play('move_vinilo')


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("right"):
		update_score()
	

# Actualiza el valor en pantalla del puntaje
# Cada hit vale x 100
func update_score() -> void:
	score =  int(score_label.text) + 100
	score_label.text = str(score)
	effects_animation.play("hit")
	
