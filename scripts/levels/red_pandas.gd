extends Node2D

@onready var pandas_animation: AnimationPlayer = $PandasAnimation

func _ready() -> void:
	pandas_animation.play("idle")
