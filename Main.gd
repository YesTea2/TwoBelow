extends Node



var level_parameters := {
	"bar_value": 0
}

export (Resource) var player_var
export (Resource) var weather_var

onready var snow_system : Particles2D = $Snow
onready var global_weather_time : Timer = $global_weather_timer
onready var storm_time : Timer = $Storm_Timer
onready var start_weather_time : Timer = $Start_Weather_Timer
signal level_changed(level_name)

export (String) var level_name = "level"



# Called when the node enters the scene tree for the first time.
func _ready():
	player_var.connect("using_door", self, "_on_Player_using_door")
	global_weather_time.connect("timeout", self, "_on_finished_changing_weather")
	storm_time.connect("timeout", self, "finish_changing_level_three_storm")
	start_weather_time.connect("timeout", self, "finish_starting_weather")
	weather_var.connect("raise_temp_fast", self, "_on_change_bar_amount")
	weather_var.connect("lower_temp_fast", self, "_on_change_bar_amount")
	weather_var.connect("lower_temp_slow", self, "_on_change_bar_amount")
	weather_var.connect("raise_temp_slow", self, "_on_change_bar_amount")
	weather_var.is_changing_system = true
	start_weather()

func _process(delta):
	if weather_var.is_changing_system == false:
		change_weather()
		
	if weather_var.is_level_one_storm == true:
		weather_var.emit_signal("raise_temp_slow")
	if weather_var.is_level_two_storm == true:
		weather_var.emit_signal("lower_temp_slow")
	if weather_var.is_level_three_storm == true && weather_var.is_ready_for_level_three_storm == true:
		weather_var.emit_signal("lower_temp_fast")

func load_level_paramters(new_level_paramters: Dictionary):
	level_parameters = new_level_paramters
	weather_var.bar_value = level_parameters.bar_value
	

func _on_change_bar_amount() -> void:
	level_parameters.bar_value = weather_var.bar_value
	
func start_weather():
	weather_var.is_level_one_storm = true
	change_storm_level_one()
	var time = get_random_time(5,15)
	start_weather_time.wait_time = time
	start_weather_time.start()
	

func finish_starting_weather():
	weather_var.is_changing_system = false
	
func change_weather():
	weather_var.is_changing_system = true
	var number = get_random_time(1,3)

	if number == 1:
		change_storm_level_one()
	if number == 2:
		change_storm_level_two()
	if number == 3:
		change_storm_level_three()
	
	var time = get_random_time(10,20)
	global_weather_time.wait_time = time
	global_weather_time.start()
	
	
func _on_finished_changing_weather():
	weather_var.is_changing_system = false
	
func change_storm_level_one():
	print("level one storm approaching")
	if weather_var.is_level_three_storm == true:
		weather_var.emit_signal("clear_of_storm")
		weather_var.is_ready_for_level_three_storm = false
	if weather_var.is_level_one_storm == false:
		weather_var.emit_signal("current_temp_normal")
	weather_var.is_level_one_storm = true
	weather_var.is_level_two_storm = false
	weather_var.is_level_three_storm = false
	snow_system.amount = weather_var.snow_amount_level_one
	snow_system.speed_scale = weather_var.snow_speed_level_one

func change_storm_level_two():
	print("level two storm approaching")
	if weather_var.is_level_three_storm == true:
		weather_var.emit_signal("clear_of_storm")
		weather_var.is_ready_for_level_three_storm = false
	if weather_var.is_level_two_storm == false:
		weather_var.emit_signal("current_temp_freezing")
	weather_var.is_level_two_storm = true
	weather_var.is_level_one_storm = false
	weather_var.is_level_three_storm = false
	snow_system.amount = weather_var.snow_amount_level_two
	snow_system.speed_scale = weather_var.snow_speed_level_two

func change_storm_level_three():
	print("level three storm approaching")
	if weather_var.is_level_three_storm == false:
		weather_var.emit_signal("warn_of_weather")
		weather_var.emit_signal("current_temp_below_freezing")
		storm_time.wait_time = weather_var.delay_for_level_three_storm
		storm_time.start()
		weather_var.is_not_ready_for_level_three_storm = true
		
	if weather_var.is_not_ready_for_level_three_storm == false:
		finish_changing_level_three_storm()

func finish_changing_level_three_storm():
	weather_var.is_ready_for_level_three_storm = true
	weather_var.is_level_three_storm = true
	weather_var.is_level_two_storm = false
	weather_var.is_level_one_storm = false
	snow_system.amount = weather_var.snow_amount_level_three
	snow_system.speed_scale = weather_var.snow_speed_level_three

func get_random_time(min_range, max_range):
	weather_var.rand_generate_time.randomize()
	var rand_int = weather_var.rand_generate_time.randi_range(min_range,max_range)
	return rand_int

func _on_changeScene_requested() -> void:
	emit_signal("level_changed", level_name)

func play_loaded_sound() -> void:
	$Door_Close_Sound.play()

func cleanup():
	if $Door_Open_Sound.playing:
		yield($Door_Open_Sound, "finished")
	queue_free()

func _on_Player_using_door():
	print("door open")
	$Door_Open_Sound.play()
	_on_changeScene_requested()
