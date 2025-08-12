extends Area2D
class_name Elevator

@export var target_scene_path: PackedScene = null
@export var character_scene_path: PackedScene

var player_in_area := false
var anim_sprite: AnimatedSprite2D
var is_open := false
var player_ref = null

func _ready():
	anim_sprite = $AnimatedSprite2D
	anim_sprite.animation_finished.connect(_on_animation_finished)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		if anim_sprite.animation in ["Opening", "Closing"]:
			return # Ignore if moving
		_change_scene() # Only change after fully open

func _on_animation_finished():
	match anim_sprite.animation:
		"Opening":
			anim_sprite.play("Open")
			is_open = true
		"Closing":
			anim_sprite.play("Closed")
			is_open = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		player_ref = body
		anim_sprite.play("Opening") # We'll change scene after it opens

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false
		player_ref = null
		anim_sprite.play("Closing")

func _change_scene():
	LevelManager.transition_to_level(LevelManager.get_next_level(), character_scene_path)
