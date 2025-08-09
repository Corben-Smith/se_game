extends Node2D

@export var required_key: String = "default_key"
var is_open: bool = false



func open_door():
	is_open = true
	print("Door opened")
	queue_free() # disable collision to simulate open
	get_node("StaticBody2D").queue_free()
	
func show_locked_feedback():
	print("Door is locked!")
	# Display UI message
	var panel = get_node("Area2D/Panel")
	if panel.visible == false:
		panel.visible = true
		await get_tree().create_timer(2.0).timeout
		panel.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_open:
		return
		
	if body is CharacterBody2D:
		if ShopManager.has_key(required_key):
			open_door()
		else:
			show_locked_feedback()
