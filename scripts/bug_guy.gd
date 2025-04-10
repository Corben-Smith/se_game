extends Node2D

const SPEED = 100

var direction = -1

@onready var ray_cast_dl = $RayCastDownLeft
@onready var ray_cast_dr = $RayCastDownRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D


func _process(delta):
	
	if ray_cast_left.is_colliding() and !ray_cast_left.get_collider().is_in_group("player"):
		direction = 1
		animated_sprite.flip_h = true
		
	if ray_cast_right.is_colliding() and !ray_cast_right.get_collider().is_in_group("player"):
		direction = -1
		animated_sprite.flip_h = false
		
	if not ray_cast_dl.is_colliding():
		direction = 1
		animated_sprite.flip_h = true
	
	if not ray_cast_dr.is_colliding():
		direction = -1
		animated_sprite.flip_h = false

	position.x += direction * SPEED * delta
	
