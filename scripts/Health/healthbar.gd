extends ProgressBar
@export var health_component: Node  # Assign this in Inspector (for Player, Enemy, etc.)

func _ready():
	if health_component:
		health_component.health_changed.connect(update_health)
		health_component.died.connect(hide_health_bar)  # Hide bar on death
		update_health(health_component.current_health)  # Initialize bar

func update_health(new_health):
	#self.value = new_health  # Update progress bar value
	#self.visible = new_health < health_component.max_health  # Hide when full
	self.value = new_health  # Update progress bar value
	self.visible = true  # Always show the health bar

func hide_health_bar():
	self.visible = false  # Hide bar when entity dies
