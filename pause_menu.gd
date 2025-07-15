extends Control

func _ready():
	# CRITICAL: This allows the pause menu to process input even when game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Start hidden
	self.visible = false
	
	# Make sure we can receive input
	set_process_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		toggle_pause()

func toggle_pause():
	if get_tree().paused:
		resume()
	else:
		pause()

func pause():
	get_tree().paused = true
	self.visible = true
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("blur")
	
func resume():
	get_tree().paused = false
	self.visible = false
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play_backwards("blur")

# Button callbacks
func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()
