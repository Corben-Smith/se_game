extends Area2D

@onready var popup = $Popup
@onready var sprite = $AnimatedSprite2D
@export var next_level_path: String = "res://scenes/Level1.tscn"


var player_inside_trigger := false
var player_ready_to_enter := false

func _ready():
	sprite.play("idle_closed")

func _on_enter_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		popup.visible = true
		player_ready_to_enter = true

func _on_enter_zone_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		popup.visible = false
		player_ready_to_enter = false

func _on_trigger_zone_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and sprite.animation != "open":
		player_inside_trigger = true
		sprite.play("open")

func _on_trigger_zone_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D and sprite.animation != "close":
		player_inside_trigger = false
		sprite.play("close")

func _on_animated_sprite_2d_animation_finished() -> void:
	match sprite.animation:
		"open":
			sprite.play("idle_opened")
		"close":
			sprite.play("idle_closed")

func _process(_delta: float) -> void:
	if player_ready_to_enter and Input.is_action_just_pressed("Interact"):
		print("Player ready to advance")
		if next_level_path != "":
			get_tree().change_scene_to_file(next_level_path)
			print("Level Changed")
