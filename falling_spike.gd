extends Node2D

@export var fall_speed = 600.0
@export var reset_delay = 1.5
@export var start_position: Vector2

var paritcles: GPUParticles2D

var falling = false
var velocity = Vector2.ZERO

func _ready():
	start_position = position
	var ar = $Area2D as Area2D
	ar.body_entered.connect(_on_trigger_body_entered)

	var cs = $Area2D2 as Area2D
	cs.body_entered.connect(_on_spike_body_entered)

	paritcles = $GPUParticles2D

func _physics_process(delta):
	if falling:
		velocity.y = fall_speed
		position += velocity * delta
		if position.y >= start_position.y + 1000:
			falling = false
			velocity = Vector2.ZERO
			await get_tree().create_timer(reset_delay).timeout
			position = start_position

func _on_trigger_body_entered(body):
	if not falling and body.is_in_group("player"):
		falling = true

func _on_spike_body_entered(body):
	if falling and body.is_in_group("player"):
		$Sprite2D.hide()
		paritcles.emitting = true
		await get_tree().create_timer(reset_delay).timeout
		queue_free()

	if falling:
		$Sprite2D.hide()
		paritcles.emitting = true
		await get_tree().create_timer(reset_delay).timeout
		queue_free()

