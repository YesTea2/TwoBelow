extends Resource

class_name weather_information

export var snow_amount_level_one = 2500
export var snow_amount_level_two = 3500
export var snow_amount_level_three = 4500

export var snow_speed_level_one = 0.3
export var snow_speed_level_two = 0.4
export var snow_speed_level_three = 0.5
export var delay_for_level_three_storm = 6



var is_changing_system = false;

var is_level_one_storm = false
var is_level_two_storm = false
var is_level_three_storm = false
var is_ready_for_level_three_storm = false
var is_ready_for_level_one_storm = false
var is_ready_for_level_two_storm = false

var is_not_ready_for_level_three_storm

export var bar_value = 0

signal lower_temp_slow
signal lower_temp_fast
signal raise_temp_slow
signal raise_temp_fast
signal warn_of_weather
signal clear_of_storm
signal current_temp_normal
signal current_temp_freezing
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
