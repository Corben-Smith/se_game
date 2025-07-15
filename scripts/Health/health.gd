extends Node
class_name HealthComponent

signal health_changed(new_health)
signal health_depleted

@export var max_health: int = 100
var current_health: int = 100

func _ready() -> void:
	owner.add_to_group("attackable")

func take_damage(amount: int):
	print(current_health)
	current_health -= amount
	health_changed.emit(current_health)

	if current_health <= 0:
		current_health = 0
		health_depleted.emit()
	print(current_health)

func add_health(amount: int):
	current_health += amount
	pass

func get_health() -> int:
	return current_health
