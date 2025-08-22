extends Node

var accel_threshold: float = 1.2 # En G's

# Devuelve true si se detecta una patada en la pierna indicada ('left' o 'right')
func is_kick_detected(accel: Dictionary, leg: String) -> bool:
	var values = accel.get(leg, null)
	if values == null:
		return false
	for i in values:
		if abs(i) > accel_threshold:
			print("Accel %s detectada: x=%.2f, y=%.2f, z=%.2f" % [leg.capitalize(), values[0], values[1], values[2]])
			return true
	return false
