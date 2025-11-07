extends Node

# Full Screen Mode
var full_screen: bool = true

# Colores de los mandos
var left_color: Color = Color('ff3c4a')
var right_color: Color = Color('00b4ff')

# Data Puntuacion

var notas_acertadas: int = 0
var max_combo: int = 0
var puntuacion: int = 0

# Funcion que calcula la puntuacion final del jugador
func get_level_score() -> int :
	return notas_acertadas*100 + max_combo*100

# Funcion que retorna el string de la puntuacion final de nivel
func score_text() -> String:
	var final_score_text: String = "Notas Acertadas: %s 
Mejor Combo: %s 

Puntuación: %s " % [notas_acertadas, max_combo, get_level_score()]
	return final_score_text
