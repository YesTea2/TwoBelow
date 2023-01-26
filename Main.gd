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
var current_wall
export (String) var level_name = "level"

onready var hud : CanvasLayer = $HUD

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Signals.connect("using_door", self, "_on_Player_using_door")
# warning-ignore:return_value_discarded
	global_weather_time.connect("timeout", self, "_on_finished_changing_weather")
# warning-ignore:return_value_discarded
	storm_time.connect("timeout", self, "finish_changing_level_three_storm")
# warning-ignore:return_value_discarded
	start_weather_time.connect("timeout", self, "finish_starting_weather")
# warning-ignore:return_value_discarded
	WeatherControl.connect("raise_temp_fast", self, "_on_change_bar_amount")
# warning-ignore:return_value_discarded
	WeatherControl.connect("lower_temp_fast", self, "_on_change_bar_amount")
# warning-ignore:return_value_discarded
	WeatherControl.connect("lower_temp_slow", self, "_on_change_bar_amount")
# warning-ignore:return_value_discarded
	WeatherControl.connect("raise_temp_slow", self, "_on_change_bar_amount")
# warning-ignore:return_value_discarded
	Signals.connect("show_entire_hud", self, "show_the_hud")
# warning-ignore:return_value_discarded
	Signals.connect("hide_entire_hud", self, "hide_the_hud")
# warning-ignore:return_value_discarded
	Signals.connect("pressing_place_fire", self, "trying_to_build_fire")
# warning-ignore:return_value_discarded
	Signals.connect("pressing_place_ice_wall", self, "trying_to_build_ice_wall")
# warning-ignore:return_value_discarded
	Signals.connect("pressing_use_repair", self, "trying_to_repair_generator")
# warning-ignore:return_value_discarded
	Signals.connect("pressing_use_ice_pick", self, "trying_to_use_ice_pick")
# warning-ignore:return_value_discarded
	Signals.connect("next_to_this_wall", self, "next_to_this_wall")
	
	Signals.connect("game_won", self, "game_won")

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


func trying_to_build_fire():
	if GlobalVariables.current_crafted_fire_amount >= 1 && GlobalVariables.is_player_surrounded_by_ice == true:
		Signals.emit_signal("build_fire")
		return
	elif GlobalVariables.current_crafted_fire_amount <= 0:
		Signals.emit_signal("no_fire_kit")
		return
	elif GlobalVariables.is_player_surrounded_by_ice == false:
		Signals.emit_signal("not_surrounded_by_ice")
		return
	pass

func game_won():
	yield(get_tree().create_timer(4), "timeout")
	get_tree().change_scene("res://End.tscn")
func next_to_this_wall(area):
	current_wall = area
func trying_to_use_ice_pick():
	current_wall.remove()
	GlobalVariables.is_currently_next_to_icewall = false
	
func trying_to_build_ice_wall():
	if GlobalVariables.current_crafted_wall_amount >= 1 && GlobalVariables.is_inside == false && GlobalVariables.is_to_close_to_building == false && GlobalVariables.is_able_to_build_another == true:
		Signals.emit_signal("build_ice_wall")
		return
	if GlobalVariables.is_inside == true:
		Signals.emit_signal("trying_to_build_indoor")
		return
	if GlobalVariables.is_to_close_to_building == true:
		Signals.emit_signal("to_close_to_building")
		return
	if GlobalVariables.is_able_to_build_another == false:
		Signals.emit_signal("need_to_move")
		return
	if GlobalVariables.current_crafted_wall_amount <= 0:
		Signals.emit_signal("no_ice_wall")
		return
	pass
func trying_to_repair_generator():
	if GlobalVariables.current_crafted_repair_amount >= 1 && GlobalVariables.is_player_next_to_generator == true:
		Signals.emit_signal("use_repair_kit")
		return
	if GlobalVariables.is_player_next_to_generator == false:
		Signals.emit_signal("not_next_to_generator")
		return
	if GlobalVariables.current_crafted_repair_amount <= 0:
		Signals.emit_signal("no_repair_kit")
		return
	pass
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
	
# warning-ignore:unused_argument
func _process(delta):
	if GlobalVariables.is_player_next_to_fire == true:
		WeatherControl.is_warm = true
		WeatherControl.emit_signal("warm_player")
	elif GlobalVariables.is_player_next_to_fire == false:
		WeatherControl.is_warm = false
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
	var time = get_random_time(10,20)
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
	GlobalVariables.is_scene_fully_loaded = false
	if GlobalVariables.is_outside == true:
		GlobalVariables.is_outside = false
		GlobalVariables.is_inside = true
		GlobalVariables.is_waiting_for_foot = false
		GlobalVariables.is_foot_steps_outside = false
		emit_signal("level_changed", level_name)
		return
	elif GlobalVariables.is_inside == true:
		GlobalVariables.is_inside = false
		GlobalVariables.is_outside = true
		GlobalVariables.is_waiting_for_foot = false
		GlobalVariables.is_foot_steps_outside = true
		emit_signal("level_changed", level_name)
		return
	
func play_loaded_sound() -> void:
	MusicController.play_specific_sound("door_enter")
	GlobalVariables.is_scene_fully_loaded = true

func cleanup():
	
	queue_free()

func _on_Player_using_door():
	print("door open")
	
	_on_changeScene_requested()
