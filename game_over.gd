extends Control 

func _ready() -> void:
	hide_self()

func show_self():
	self.visible = true

func hide_self():
	self.visible = false

func _on_respawn_pressed() -> void:
	GlobalReferences.player.position.y = 9999
	hide_self()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	get_tree().quit()
