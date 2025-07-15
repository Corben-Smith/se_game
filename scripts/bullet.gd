extends Area2D
class_name Bullet

var speed: float
var direction: Vector2
var damage: float

@export var pop_effect: GPUParticles2D

func _ready():
	connect("body_entered", _on_Bullet_body_entered)

func _physics_process(delta):
	position.x += direction.x * speed * delta

func _on_Bullet_body_entered(body):
	if body.is_in_group("attackable") and body.is_in_group("enemy"):
		var health = body.get_node_or_null("HealthComponent")
		if !health:
			print("does not have health component")
			return

		health.take_damage(damage)
		self.queue_free()
	self.queue_free()
