extends Node2D 
class_name OneWayPlatform

# Optional variables for fine-tuning behavior
@export var disabled: bool = false
@export var entry_margin: float = 10.0  # How far below the platform the player can pass through

# Reference to the collision shape
@onready var collision_shape = $StaticBody2D/CollisionShape2D

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("player"):
		print("handling")
		_handle_character_collision(body)

func _physics_process(_delta):
	if disabled:
		collision_shape.disabled = true
		return
		
	
func _handle_character_collision(character: CharacterBody2D):
	var character_pos = character.global_position
	var platform_pos = global_position
	var extents = collision_shape.shape.extents

	var platform_top = platform_pos.y - extents.y
	var platform_bottom = platform_pos.y + extents.y

	# Allow entry from below
	if character_pos.y > platform_bottom - entry_margin and character.velocity.y < 0:
		call_deferred("_disable_collision")

	# Allow the player to drop through the platform if they press down + jump
	if character.is_on_floor() and character_pos.y <= platform_top + 1:
		if "wants_to_drop_through" in character and character.wants_to_drop_through():
			call_deferred("_disable_collision")

# Used to manually disable collision (for special cases)
func set_disabled(value: bool):
	disabled = value


		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and collision_shape.disabled:
		print("Re-enabling platform collision (deferred)")
		call_deferred("_enable_collision")


func _enable_collision():
	collision_shape.disabled = false

func _disable_collision():
	collision_shape.disabled = true
