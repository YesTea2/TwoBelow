extends Node


var main_music = load("res://Music/audio_hero_Astral-Journey_SIPML_J-0201.mp3")
var button_press = load("res://SFX/button_press.wav")
var button_highlight = load("res://SFX/button_highlight.wav")
var slider_sfx = load("res://SFX/volume_test.wav")
var sign_fall = load("res://SFX/sign_fall.wav")
var open_menu = load("res://SFX/menu_open.wav")
var close_menu = load("res://SFX/menu_close.wav")

var close_menu_two = load("res://SFX/close_menu_01.wav")


func stop_sfx():
	$SFX.stop()
	
func play_open_menu():
	$SFX.stream = open_menu
	$SFX.play()
	
func play_close_menu():
	$SFX.stream = close_menu
	$SFX.play()
	

func play_specific_sound(sound_name):
	if sound_name == "sign_fall":
		$SFX.stream = sign_fall
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
