extends Node
signal health_changed(new_health)
signal died

var max_health: int = 100
var current_health: int = 100

func take_damage(amount: int):
	current_health -= amount
	health_changed.emit(current_health)  # Notify health bar

	if current_health <= 0:
		current_health = 0
		died.emit()  # Notify death system
