extends Resource

class_name weather_information

export var snow_amount_level_one = 2500
export var snow_amount_level_two = 3500
export var snow_amount_level_three = 4500

export var snow_speed_level_one = 0.3
export var snow_speed_level_two = 0.4
export var snow_speed_level_three = 0.5
export var delay_for_level_three_storm = 6

var is_cold = false
var is_freeze = false
var is_below = false

var is_changing_system = false;

var is_level_one_storm = false
var is_level_two_storm = false
var is_level_three_storm = false
var is_ready_for_level_three_storm = false
var is_ready_for_level_one_storm = false
var is_ready_for_level_two_storm = false

var is_not_ready_for_level_three_storm

export var bar_value = 0

# warning-ignore:unused_signal
signal lower_temp_slow
# warning-ignore:unused_signal
signal lower_temp_fast
# warning-ignore:unused_signal
signal raise_temp_slow
# warning-ignore:unused_signal
signal raise_temp_fast
# warning-ignore:unused_signal
signal warn_of_weather
# warning-ignore:unused_signal
signal clear_of_storm
# warning-ignore:unused_signal
signal current_temp_normal
# warning-ignore:unused_signal
signal current_temp_freezing
# warning-ignore:unused_signal
signal current_temp_below_freezing

var can_load_again = true
var rand_generate_time = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	bar_value = clamp(bar_value, 0, 100)
	pass # Replace with function body.



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
