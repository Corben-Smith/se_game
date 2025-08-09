extends Player

var bar: PackedScene = preload("res://scenes/Glide_Bar.tscn")
var actual_bar: ProgressBar = null
var gliding_state = null

func _ready() -> void:
	super()
	
	# Get reference to the gliding state
	gliding_state = $StateMachine/Gliding_State
	
	# Create and setup the progress bar
	var new_bar = bar.instantiate() as Control
	actual_bar = new_bar.get_node("ProgressBar") as ProgressBar
	
	# Configure the progress bar
	actual_bar.min_value = 0.0
	actual_bar.max_value = gliding_state.max_fly_timer
	actual_bar.value = gliding_state.fly_timer
	
	# Add to UI
	UI_Manager.add_element(new_bar)

func _process(delta: float) -> void:
	if state_machine.current_state.name != "Gliding_State":
		actual_bar.visible = false
	else:
		actual_bar.visible = true

	if actual_bar and gliding_state:
		actual_bar.value = gliding_state.fly_timer	
