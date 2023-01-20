extends Node


var snow_amount_level_one = 3000
var snow_amount_level_two = 6000
var snow_amount_level_three = 10000
var snow_speed_level_one = 0.3
var snow_speed_level_two = 0.8
var snow_speed_level_three = 1.2
var delay_for_level_three_storm = 6
var current_temp = "Cold"
var is_cold = false
var is_freeze = false
var is_below = false

var is_changing_system = false;

var is_level_one_storm = false
var is_level_two_storm = false
var is_level_three_storm = false
var is_ready_for_level_three_storm = true
var is_ready_for_level_one_storm = false
var is_ready_for_level_two_storm = false

var is_not_ready_for_level_three_storm

var bar_value = 100.0

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

