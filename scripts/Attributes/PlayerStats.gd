extends StatSet 
class_name PlayerStats

@export var _acceleration: float = 50.0
@export var _deacceleration: float = 100.0
@export var max_speed: float = 300.0
@export var in_air_acceleration: float = 20.0
@export var in_air_deacceleration: float = 20.0
@export var jump_force: float = -450.0
@export var _gravity: float = 1000.0
@export var falling_gravity: float = 2000.0
@export var coyote_time: float = 0.1
@export var jump_buffer_time: float = 0.1
@export var variable_jump_multiplier: float = 0.5

func _init() -> void:
    # Initialize the stats dictionary with Stat objects created from the exported float values
    stats = {
        "acceleration": Stat.new(_acceleration),
        "deacceleration": Stat.new(_deacceleration),
        "max_speed": Stat.new(max_speed),
        "in_air_acceleration": Stat.new(in_air_acceleration),
        "in_air_deacceleration": Stat.new(in_air_deacceleration),
        "jump_force": Stat.new(jump_force),
        "gravity": Stat.new(_gravity),
        "falling_gravity": Stat.new(falling_gravity),
        "coyote_time": Stat.new(coyote_time),
        "jump_buffer_time": Stat.new(jump_buffer_time),
        "variable_jump_multiplier": Stat.new(variable_jump_multiplier)
    }
