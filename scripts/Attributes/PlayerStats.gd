extends StatSet 
class_name PlayerStats

@export var _acceleration: Stat = Stat.new(50.0)
@export var _deacceleration: Stat = Stat.new(100.0)
@export var _max_speed: Stat = Stat.new(300.0)
@export var _in_air_acceleration: Stat = Stat.new(20.0)
@export var _in_air_deacceleration: Stat = Stat.new(20.0)
@export var _jump_force: Stat = Stat.new(-450.0)
@export var _gravity: Stat = Stat.new(1000.0)
@export var _falling_gravity: Stat = Stat.new(2000.0)
@export var _coyote_time: Stat = Stat.new(0.1)
@export var _jump_buffer_time: Stat = Stat.new(0.1)
@export var _variable_jump_multiplier: Stat = Stat.new(0.8)

func _init() -> void:
    # Initialize the stats dictionary
    stats = {
        "acceleration": _acceleration,
        "deacceleration": _deacceleration,
        "max_speed": _max_speed,
        "in_air_acceleration": _in_air_acceleration,
        "in_air_deacceleration": _in_air_deacceleration,
        "jump_force": _jump_force,
        "gravity": _gravity,
        "falling_gravity": _falling_gravity,
        "coyote_time": _coyote_time,
        "jump_buffer_time": _jump_buffer_time,
        "variable_jump_multiplier": _variable_jump_multiplier
    }
