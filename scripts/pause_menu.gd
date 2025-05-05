extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	self.hide()

func resume():
	get_tree().paused = false 
	$AnimationPlayer.play_backwards("blur")
	self.hide()
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	self.show()
		
func testEsc():
	if Input.is_action_just_pressed("esc") and  get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused == true:
		resume()


func _on_resume_pressed():
	resume()

func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()

func _process(delta):
	testEsc()
