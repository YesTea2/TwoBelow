extends Node

var is_giving_item = false
var is_searching_drawer = false
var is_inside = false
var is_outside = true
var is_at_door = false
var coming_from_inside = false
var number_of_current_building = 0
var max_time_between_storm = 20
var current_offset : Vector2
var has_weather_started = false
var has_generated_buildings = false
var finished_displaying_door_message = false
var b_1 = false
var b_2 = false
var b_3 = false
var b_4 = false
var b_5 = false
var b_6 = false
var b_7 = false
var b_8 = false
var b_9 = false
var b_10 = false
var b_11 = false
var b_12 = false
var b_13 = false
var b_14 = false
var b_15 = false
var b_16 = false
var b_17 = false
var b_18 = false
var b_19 = false
var b_20 = false
var first_load = true


var current_total_logs = 0
var current_total_wire = 0
var current_total_ice = 0
var current_total_pipe = 0

func set_building_sprite(num_for_sprite, true_or_false):
	set("b_" + str(num_for_sprite), true_or_false)

func return_type_container(var pass_num):
	return get("b_" + str(pass_num))
