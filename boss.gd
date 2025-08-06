extends Area2D

@export var speed: float = 300.0
@export var lifetime: float = 5.0
@export var damage: int = 10

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	var timer = Timer.new()
	timer.wait_time = lifetime
	timer.one_shot = true
	timer.timeout.connect(queue_free)
	add_child(timer)
	timer.start()

func _physics_process(delta):
	global_position += velocity * delta

func set_velocity(new_velocity: Vector2):
	velocity = new_velocity
	direction = velocity.normalized()

func set_direction_and_speed(dir: Vector2, spd: float):
	direction = dir.normalized()
	speed = spd
	velocity = direction * speed

func _on_body_entered(body):
	if body.name == "Player" or body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)
		
		queue_free()
	
	elif body.is_in_group("walls") or body.is_in_group("obstacles"):
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("player_area"):
		if area.has_method("take_damage"):
			area.take_damage(damage)
		queue_free()
