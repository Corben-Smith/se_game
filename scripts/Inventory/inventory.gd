extends CanvasLayer

func _on_close_pressed() -> void:
	$Anim.play("TransOut")

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "TransOut":
		get_tree().paused = false
		self.visible = false

func _input(event):
	if event.is_action_pressed("Inv"):
		if self.offset.y == 600:
			self.visible = true
			get_node("InvContainer").fillInventorySlots()
			get_node("Anim").play("TransIn")
		elif self.offset.y == -600:
			self.visible = true
			get_node("InvContainer").fillInventorySlots()
			get_node("Anim").play("TransIn")
		elif self.offset.y == 0:
			get_node("Anim").play("TransOut")
