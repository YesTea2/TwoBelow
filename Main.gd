extends Node

export var snow_amount_level_one = 2500
export var snow_amount_level_two = 3500
export var snow_amount_level_three = 4500

export var snow_speed_level_one = 0.3
export var snow_speed_level_two = 0.4
export var snow_speed_level_three = 0.5
export var delay_for_level_three_storm = 6

onready var snow_system : Particles2D = $Snow

var is_changing_system = false;

var is_level_one_storm = false
var is_level_two_storm = false
var is_level_three_storm = false
var is_ready_for_level_three_storm = false
var is_ready_for_level_one_storm = false
var is_ready_for_level_two_storm = false
signal lower_temp_slow
signal lower_temp_fast
signal raise_temp_slow
signal raise_temp_fast
signal warn_of_weather
signal clear_of_storm
signal current_temp_normal
signal current_temp_freezing
signal current_temp_below_freezing

var rand_generate_time = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	is_changing_system = true
	start_weather()

func _process(delta):
	if is_changing_system == false:
		change_weather()
		
	if is_level_one_storm == true:
		emit_signal("raise_temp_slow")
	if is_level_two_storm == true:
		emit_signal("lower_temp_slow")
	if is_level_three_storm == true && is_ready_for_level_three_storm == true:
		emit_signal("lower_temp_fast")

func start_weather():
	is_level_one_storm = true
	change_storm_level_one()
	var time = get_random_time(5,15)
	yield(get_tree().create_timer(time), "timeout")
	is_changing_system = false

func change_weather():
	is_changing_system = true
	var number = get_random_time(1,3)

	if number == 1:
		change_storm_level_one()
	if number == 2:
		change_storm_level_two()
	if number == 3:
		change_storm_level_three()
	
	var time = get_random_time(10,20)
	yield(get_tree().create_timer(time), "timeout")
	is_changing_system = false
	

func change_storm_level_one():
	print("level one storm approaching")
	if is_level_three_storm == true:
		emit_signal("clear_of_storm")
		is_ready_for_level_three_storm = false
	if is_level_one_storm == false:
		emit_signal("current_temp_normal")
	is_level_one_storm = true
	is_level_two_storm = false
	is_level_three_storm = false
	snow_system.amount = snow_amount_level_one
	snow_system.speed_scale = snow_speed_level_one

func change_storm_level_two():
	print("level two storm approaching")
	if is_level_three_storm == true:
		emit_signal("clear_of_storm")
		is_ready_for_level_three_storm = false
	if is_level_two_storm == false:
		emit_signal("current_temp_freezing")
	is_level_two_storm = true
	is_level_one_storm = false
	is_level_three_storm = false
	snow_system.amount = snow_amount_level_two
	snow_system.speed_scale = snow_speed_level_two

func change_storm_level_three():
	print("level three storm approaching")
	if is_level_three_storm == false:
		emit_signal("warn_of_weather")
		emit_signal("current_temp_below_freezing")
		yield(get_tree().create_timer(delay_for_level_three_storm), "timeout")
	is_ready_for_level_three_storm = true
	is_level_three_storm = true
	is_level_two_storm = false
	is_level_one_storm = false
	snow_system.amount = snow_amount_level_three
	snow_system.speed_scale = snow_speed_level_three

func get_random_time(min_range, max_range):
	rand_generate_time.randomize()
	var rand_int = rand_generate_time.randi_range(min_range,max_range)
	return rand_int


