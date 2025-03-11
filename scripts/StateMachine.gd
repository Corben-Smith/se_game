extends Node
class_name StateMachine

@export var inital_state: State = null

@onready var current_state: State = (
func get_inital_state() -> State:
    return inital_state if inital_state != null else get_child(0)
).call()

var previous_state = null

var states = {}

@onready var parent = get_parent()

func _ready():
    for child in get_children():
        if child is State:
            states[child.name.to_lower()] = child
            child.transition.connect(on_child_transitioned)

    if current_state:
        current_state.enter("", {})



func _physics_process(delta: float) -> void:
    if current_state:
        current_state.physics_update(delta)
        
func handle_input(event: InputEvent) -> void:
    if current_state:
        current_state.handle_input(event)

func _process(delta: float) -> void: 
    if current_state:
        current_state.update(delta)

func on_child_transitioned(state, new_state_path, data = null):
    if current_state != state:
        print("trying to transition from a state you are not in")
        return

    var new_state = states.get(new_state_path.to_lower())
    if !new_state:
        print("unable to get new state %s", new_state)
        return

    if current_state:
        current_state.exit()
    
    new_state.enter(state.name, data)
    current_state = new_state
