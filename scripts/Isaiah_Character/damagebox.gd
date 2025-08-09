extends StaticBody2D
@onready var health_component = $Health

func _ready():
	health_component.health_depleted.connect(on_death)

func take_damage(amount: int):
	health_component.take_damage(amount)

func on_death():
	print("Box destroyed!")
	queue_free()
