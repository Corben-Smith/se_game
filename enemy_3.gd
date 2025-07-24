extends CharacterBody2D
class_name Enemy3

@export var speed = 100
@export var patrol_distance = 100
@export var damage = 10

var health = 80
var health_max = 80
var health_min = 0 

var dead: bool = false
var taking_damage: bool = false 
var damage_to_deal = 20
var is_dealing_damage: bool = false 

var knockback_force = -20
var dir: float = -1
var start_x: float

func _ready() -> void:
	add_to_group("enemy")
	start_x = global_position.x
	if has_node("DirectionTimer"):
		$DirectionTimer.stop()  # Optional: we don't need it here

func _physics_process(delta):
	if dead:
		velocity = Vector2.ZERO
	elif taking_damage:
		velocity = Vector2(knockback_force * -dir, 0)
	else:
		velocity = Vector2(dir * speed, 0)

		# Flip direction only when clearly beyond patrol bounds
		if dir == -1 and global_position.x <= start_x - patrol_distance:
			dir = 1
		elif dir == 1 and global_position.x >= start_x + patrol_distance:
			dir = -1

	handle_animation()
	move_and_slide()

func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("default")
		anim_sprite.flip_h = dir > 0
