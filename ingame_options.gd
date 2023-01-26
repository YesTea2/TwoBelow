extends CanvasLayer


onready var main_v_slider : Slider = $main_v_slider
onready var music_v_slider : Slider = $music_v_slider
onready var sfx_v_slider : Slider = $sfx_v_slider
onready var window_check : CheckBox = $window_check
onready var full_screen_check : CheckBox = $full_screen_check

func _ready():
	GlobalVariables.is_sub_options_open = true
	Signals.connect("closing_options_sub_menu", self, "_on_close_button_pressed")
	set_slider_values()
	
	
func set_slider_values():
	_on_main_v_slider_value_changed(GlobalVariables.current_main_audio_slider_value)
	_on_music_v_slider_value_changed(GlobalVariables.current_music_slider_value)
	_on_sfx_v_slider_value_changed(GlobalVariables.current_sfx_slider_value)
	music_v_slider.value = GlobalVariables.current_music_slider_value
	main_v_slider.value = GlobalVariables.current_main_audio_slider_value
	sfx_v_slider.value = GlobalVariables.current_sfx_slider_value
	pass

func _on_main_v_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear2db(value))
	GlobalVariables.current_main_audio_slider_value = value
	pass # Replace with function body.


func _on_music_v_slider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear2db(value))
	GlobalVariables.current_music_slider_value = value
	pass # Replace with function body.


func _on_sfx_v_slider_value_changed(value):
	MusicController.play_sfx_test()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear2db(value))
	GlobalVariables.current_sfx_slider_value = value
	pass # Replace with function body.




func _on_full_screen_check_toggled(button_pressed):
	MusicController.play_button("down")
	OS.window_fullscreen = true
	window_check.pressed = false
	pass # Replace with function body.


func _on_window_check_toggled(button_pressed):
	MusicController.play_button("down")
	OS.window_fullscreen = false
	full_screen_check.pressed = false
	pass # Replace with function body.


func _on_close_button_pressed():
	GlobalVariables.is_sub_options_open = false
	MusicController.play_button("down")
	queue_free()
	pass # Replace with function body.


func _on_close_button_mouse_entered():
	MusicController.play_button("highlight")
	pass # Replace with function body.
