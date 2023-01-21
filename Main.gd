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
onready var player_ref = $Player
signal level_changed(level_name)

export (String) var level_name = "level"

onready var hud : CanvasLayer = $HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	print(str(GlobalVariables.current_offset) + "dddd")
	player_var.connect("using_door", self, "_on_Player_using_door")
	global_weather_time.connect("timeout", self, "_on_finished_changing_weather")
	storm_time.connect("timeout", self, "finish_changing_level_three_storm")
	start_weather_time.connect("timeout", self, "finish_starting_weather")
	WeatherControl.connect("raise_temp_fast", self, "_on_change_bar_amount")
	WeatherControl.connect("lower_temp_fast", self, "_on_change_bar_amount")
	WeatherControl.connect("lower_temp_slow", self, "_on_change_bar_amount")
	WeatherControl.connect("raise_temp_slow", self, "_on_change_bar_amount")
	Signals.connect("show_entire_hud", self, "show_the_hud")
	Signals.connect("hide_entire_hud", self, "hide_the_hud")
	WeatherControl.is_changing_system = true
	if GlobalVariables.has_weather_started == false:
		GlobalVariables.has_weather_started = true
		start_weather()
	elif GlobalVariables.has_weather_started == true:
		continue_storm()
	if GlobalVariables.coming_from_inside == true:
		print(str(GlobalVariables.current_offset))
		player_ref.position = GlobalVariables.current_offset
		GlobalVariables.coming_from_inside = false
	if GlobalVariables.has_generated_buildings == false:
		GlobalVariables.has_generated_buildings = true
func show_the_hud():
	hud.visible = true
	pass
func hide_the_hud():
	hud.visible = false
	pass
	
func continue_storm():
	var time = get_random_time(5,GlobalVariables.max_time_between_storm)
	start_weather_time.wait_time = time
	start_weather_time.start()
	
func _process(delta):
	
	if WeatherControl.is_changing_system == false:
		change_weather()
	if WeatherControl.is_level_one_storm == true:
		WeatherControl.emit_signal("raise_temp_slow")
	if WeatherControl.is_level_two_storm == true:
		WeatherControl.emit_signal("lower_temp_slow")
	if WeatherControl.is_level_three_storm == true && WeatherControl.is_ready_for_level_three_storm == true:
		WeatherControl.emit_signal("lower_temp_fast")

func load_level_paramters(new_level_paramters: Dictionary):
	level_parameters = new_level_paramters
	WeatherControl.bar_value = level_parameters.bar_value
	

func _on_change_bar_amount() -> void:
	level_parameters.bar_value = WeatherControl.bar_value
	
func start_weather():
	WeatherControl.is_level_one_storm = true
	change_storm_level_one()
	var time = get_random_time(5,15)
	start_weather_time.wait_time = time
	start_weather_time.start()
	

func finish_starting_weather():
	WeatherControl.is_changing_system = false
	
func change_weather():
	WeatherControl.is_changing_system = true
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
	WeatherControl.is_changing_system = false
	
func change_storm_level_one():
	print("level one storm approaching")
	WeatherControl.is_freeze = false
	WeatherControl.is_cold = true
	if WeatherControl.is_level_three_storm == true:
		WeatherControl.emit_signal("clear_of_storm")
		WeatherControl.is_ready_for_level_three_storm = false
	if WeatherControl.is_level_one_storm == false:
		WeatherControl.emit_signal("current_temp_normal")
	WeatherControl.is_level_one_storm = true
	WeatherControl.is_level_two_storm = false
	WeatherControl.is_level_three_storm = false
	snow_system.amount = WeatherControl.snow_amount_level_one
	snow_system.speed_scale = WeatherControl.snow_speed_level_one

func change_storm_level_two():
	print("level two storm approaching")
	WeatherControl.is_freeze = true
	WeatherControl.is_cold = false
	if WeatherControl.is_level_three_storm == true:
		WeatherControl.emit_signal("clear_of_storm")
		WeatherControl.is_ready_for_level_three_storm = false
	if WeatherControl.is_level_two_storm == false:
		WeatherControl.emit_signal("current_temp_freezing")
	WeatherControl.is_level_two_storm = true
	WeatherControl.is_level_one_storm = false
	WeatherControl.is_level_three_storm = false
	snow_system.amount = WeatherControl.snow_amount_level_two
	snow_system.speed_scale = WeatherControl.snow_speed_level_two

func change_storm_level_three():
	print("level three storm approaching")
	if WeatherControl.is_level_three_storm == false:
		WeatherControl.is_freeze = false
		WeatherControl.is_cold = false
		WeatherControl.emit_signal("warn_of_weather")
		WeatherControl.emit_signal("current_temp_below_freezing")
		storm_time.wait_time = WeatherControl.delay_for_level_three_storm
		storm_time.start()
		WeatherControl.is_not_ready_for_level_three_storm = true
		
	if WeatherControl.is_not_ready_for_level_three_storm == false:
		finish_changing_level_three_storm()

func finish_changing_level_three_storm():
	WeatherControl.is_ready_for_level_three_storm = true
	WeatherControl.is_level_three_storm = true
	WeatherControl.is_level_two_storm = false
	WeatherControl.is_level_one_storm = false
	snow_system.amount = WeatherControl.snow_amount_level_three
	snow_system.speed_scale = WeatherControl.snow_speed_level_three

func get_random_time(min_range, max_range):
	WeatherControl.rand_generate_time.randomize()
	var rand_int = WeatherControl.rand_generate_time.randi_range(min_range,max_range)
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
