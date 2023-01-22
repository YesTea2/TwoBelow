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
var current_crafted_wall_amount = 0
var current_crafted_fire_amount = 0
var current_crafted_repair_amount = 0
var temp_wall = Area2D
var current_total_logs = 6
var current_total_wire = 0
var current_total_ice = 12
var current_total_pipe = 0
var is_player_around = false
var temporary_x = 0.0
var temporary_y = 0.0
var is_to_close_to_building = false
var is_currently_next_to_icewall = false
var is_able_to_build_another = true
var is_player_facing_left
var is_player_facing_right
var is_player_facing_down
var is_player_facing_up
var is_in_sub_menu = false
var is_player_next_to_generator = false
var is_player_surrounded_by_ice = false
var is_player_next_to_fire = false
var is_player_next_to_fireplace = false
var is_foot_steps_outside = true
var generator_one_fixed = false
var generator_two_fixed = false
var is_waiting_for_foot = false
var gen_total_fixed = 0

func set_building_sprite(num_for_sprite, true_or_false):
	set("b_" + str(num_for_sprite), true_or_false)

func return_type_container(var pass_num):
	return get("b_" + str(pass_num))
