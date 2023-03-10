extends Node


var main_music = load("res://Music/audio_hero_Astral-Journey_SIPML_J-0201.mp3")
var button_press = load("res://SFX/button_press.wav")
var button_highlight = load("res://SFX/button_highlight.wav")
var slider_sfx = load("res://SFX/volume_test.wav")
var sign_fall = load("res://SFX/sign_fall.wav")
var open_menu = load("res://SFX/menu_open.wav")
var close_menu = load("res://SFX/menu_close.wav")
var weather_alert = load("res://SFX/weather_alert.wav")
var snow_walk = load("res://SFX/snow_walk.wav")
var wood_walk = load("res://SFX/wood_walk.wav")
var generator_on = load("res://SFX/generator_on.wav")
var door_open = load("res://SFX/door_open.wav")
var door_enter = load("res://SFX/door_enter.wav")
var build_ice = load("res://SFX/build_ice.wav")
var build_fire = load("res://SFX/build_fire.wav")
var item_empty = load("res://SFX/item_empty.wav")
var item_obtain = load("res://SFX/item_obtain.wav")



func stop_sfx():
	$SFX.stop()
	
func play_open_menu():
	$SFX.stream = open_menu
	$SFX.play()
	
func play_close_menu():
	$SFX.stream = close_menu
	$SFX.play()
	

func play_specific_sound(sound_name):
	if sound_name == "item_obtain":
		$SFX.stream =item_obtain
	if sound_name == "build_fire":
		$SFX.stream = build_fire
	if sound_name == "build_ice":
		$SFX.stream = build_ice
	if sound_name == "generator_on":
		$SFX.stream = generator_on
	if sound_name == "door_enter":
		$SFX.stream = door_enter
	if sound_name == "weather_alert":
		$SFX.stream = weather_alert
	if sound_name == "button_press":
		$SFX.stream = button_press
	if sound_name == "item_empty":
		$SFX.stream = item_empty
	if sound_name == "item_obtain":
		$SFX.stream = item_obtain
	if sound_name == "sign_fall":
		$SFX.stream = sign_fall
	if sound_name == "snow_walk":
		$SFX.stream = snow_walk
	$SFX.play()

func play_music():
	$Music.stream = main_music
	$Music.play()
	
func play_button(highlight_or_down):
	if highlight_or_down == "down":
		$SFX.stream = button_press
	elif highlight_or_down == "highlight":
		$SFX.stream = button_highlight
	$SFX.play()
	
func play_sfx_test():
	$SFX.stream = slider_sfx
	$SFX.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
