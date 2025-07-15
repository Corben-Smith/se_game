extends CharacterBody2D
class_name Enemy2

const speed = 100
var is_enemy_chase:bool = true

var health = 80
var health_max = 80
var health_min = 0 
@export var damage = 10

var dead: bool = false
var taking_damage: bool = false 
var damage_to_deal = 20
var is_dealing_damage: bool = false 

@export var follow_distance:float = 200

var dir: float = -1
const gravity = 900
var knockback_force = -20
var is_roaming: bool = true

var player: CharacterBody2D
var player_in_area = false

func _ready() -> void:
	$DirectionTimer.start()
	add_to_group("enemy")

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		velocity.x = 0
		
	player = GlobalReferences.player
	
	if player.global_position - self.global_position < Vector2(follow_distance, follow_distance):
		is_enemy_chase = true
	else:
		is_enemy_chase = false
	
	move(delta)
	handle_animation()
	move_and_slide()

func move(delta):
	if !dead:
		if !is_enemy_chase:
			velocity.x = dir * speed
		elif is_enemy_chase and !taking_damage:
			var dir_to_player = position.direction_to(player.position) * speed
			velocity.x = dir_to_player.x
			dir = abs(velocity.x)/velocity.x
		elif taking_damage:
			var knockback_dir = position.direction_to(player.position) * knockback_force
			velocity.x = knockback_dir.x
		is_roaming = true
	elif dead:
		velocity.x = 0 

func handle_animation():
	var anim_sprite = $AnimatedSprite2D
	if !dead and !taking_damage and !is_dealing_damage:
			anim_sprite.play("default")
			if dir == 1:
				anim_sprite.flip_h = true
			elif dir == -1:
				anim_sprite.flip_h = false

func _on_direction_timer_timeout() -> void:
	print("dir_timer")
	$DirectionTimer.wait_time = choose([1.5,2.0,2.5])
	if !is_enemy_chase:
		dir = choose([-1, 1])
		velocity.x = 0
		print("setting zero")
		
func choose(array):
	array.shuffle()
	return array.front()
