extends CharacterBody2D
class_name Enemy4

@export var speed = 100
@export var patrol_distance = 100
@export var follow_distance: float = 200
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
var is_enemy_chase: bool = false

var player: CharacterBody2D

func _ready() -> void:
	add_to_group("enemy")
	start_x = global_position.x
	player = GlobalReferences.player  # Or use get_tree().get_first_node_in_group("player") if you prefer

func _physics_process(delta):
	if dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	if taking_damage:
		velocity = Vector2(knockback_force * -dir, 0)
		move_and_slide()
		return

	# Check distance to player
	if player and global_position.distance_to(player.global_position) <= follow_distance:
		is_enemy_chase = true
	else:
		is_enemy_chase = false

	if is_enemy_chase:
		# Fly toward player
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		dir = sign(direction.x)
	else:
		# Patrol
		velocity = Vector2(dir * speed, 0)

		var distance_from_start = global_position.x - start_x
		if dir == -1 and distance_from_start <= -patrol_distance:
			dir = 1
		elif dir == 1 and distance_from_start >= patrol_distance:
			dir = -1

	handle_animation()
	move_and_slide()

func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
		anim_sprite.play("default")
		anim_sprite.flip_h = dir > 0
