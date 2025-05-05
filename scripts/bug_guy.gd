extends CharacterBody2D
extends Node2D

@export var SPEED = 1200 
const SPEED = 100

@export var direction = -1
var direction = -1
var player_in_range = null

@onready var ray_cast_dl = $RayCastDownLeft
@onready var ray_cast_dr = $RayCastDownRight
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var animated_sprite = $AnimatedSprite2D

@onready var DamageTimer = $DamageTimer
@onready var health_component = $HealthComponent

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
	
	if ray_cast_left.is_colliding() and !ray_cast_left.get_collider().is_in_group("player"):

    velocity.x = direction * SPEED * delta
    if !is_on_floor():
        velocity.y = 100
    move_and_slide()
	position.x += direction * SPEED * delta
	


func _on_damagebox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("⚔️ Player touched bug!")
		player_in_range = body

		if player_in_range.has_method("take_damage"):
			print("💢 Instant damage on contact")
			player_in_range.take_damage(1)

		# ⏱️ Start damage over time
		DamageTimer.start()


func _on_damagebox_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		print("🏃 Player escaped bug.")
		player_in_range = null
		DamageTimer.stop()


func _on_damage_timer_timeout() -> void:
	if player_in_range and player_in_range.has_method("take_damage"):
		print("💢 Damaging player!")
		player_in_range.take_damage(1)
	else:
		print("❌ Player not in range or missing take_damage()")

func take_damage(amount: int = 1):
	print("💥 Bug took damage:", amount)
	if health_component:
		health_component.take_damage(amount)
		flash_red()
		if health_component.current_health <= 0:
			print("☠️ Bug died")
			queue_free()  # removes the bug from the scene

func flash_red():
	animated_sprite.modulate = Color(1, 0, 0)  # flash red
	await get_tree().create_timer(0.1).timeout
	animated_sprite.modulate = Color(1, 1, 1)  # back to normal

func _ready():
	add_to_group("enemy")
	health_component = $HealthComponent
	


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.is_attacking:
		print("💥 Bug hit by player attack!")
		take_damage(body.attack_damage)
