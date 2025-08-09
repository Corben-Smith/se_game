extends Area2D

@export var key_id: String = "default_key" # If you want to track specific doors


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("Key collected:", key_id)
		ShopManager.add_key(key_id)
		queue_free()  # Remove key from scene
