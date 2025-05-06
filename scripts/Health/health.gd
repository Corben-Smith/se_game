extends Node
class_name HealthComponent

signal health_changed(new_health)
signal health_depleted

@export var max_health: int = 100
var current_health: int

func _ready():
	current_health = max_health
	
func take_damage(amount: int):
	current_health -= amount
	health_changed.emit(current_health)

	if current_health <= 0:
		print("diedie")
		current_health = 0
		health_depleted.emit()
		print("die")
	print("💔 Took damage! Current health: ", current_health, "/", max_health)


func add_health(amount: int):
	current_health = min(current_health + amount, max_health)
	health_changed.emit(current_health)
	print("❤️ Healed! Current health: ", current_health, "/", max_health)

func get_health() -> int:
	return current_health
