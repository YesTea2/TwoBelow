extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var check_one : CheckBox = $CheckBox
onready var check_two : CheckBox = $CheckBox2
onready var music_slider : Slider = $Music_Volume
onready var main_slider : Slider = $Main_Volume
onready var sfx_slider : Slider = $SFX_Volume

# Called when the node enters the scene tree for the first time.
func _ready():
	set_slider_values()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func set_slider_values():
	_on_Music_Volume_value_changed(GlobalVariables.current_music_slider_value)
	_on_SFX_Volume_value_changed(GlobalVariables.current_sfx_slider_value)
	_on_Main_Volume_value_changed(GlobalVariables.current_main_audio_slider_value)
	music_slider.value = GlobalVariables.current_music_slider_value
	main_slider.value = GlobalVariables.current_main_audio_slider_value
	sfx_slider.value = GlobalVariables.current_sfx_slider_value

func _on_Music_Volume_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear2db(value))
	GlobalVariables.current_music_slider_value = value


func _on_Main_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear2db(value))
	GlobalVariables.current_main_audio_slider_value = value

func _on_SFX_Volume_value_changed(value):
	MusicController.play_sfx_test()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear2db(value))
	GlobalVariables.current_sfx_slider_value = value


func _on_CheckBox_pressed():
	MusicController.play_button("down")
	OS.window_fullscreen = true
	check_two.pressed = false
	pass # Replace with function body.


func _on_CheckBox2_pressed():
	MusicController.play_button("down")
	OS.window_fullscreen = false
	check_one.pressed = false
	pass # Replace with function body.


func _on_Close_Settings_Button_pressed():
	queue_free()
	pass # Replace with function body.


func _on_Close_Settings_Button_button_down():
	MusicController.play_button("down")
	pass # Replace with function body.


func _on_SFX_Volume_changed():
	
	pass # Replace with function body.


func _on_Close_Settings_Button_mouse_entered():
	MusicController.play_button("highlight")
	pass # Replace with function body.






func _on_CheckBox3_pressed():
	if GlobalVariables.is_casual_mode == false:
		GlobalVariables.is_casual_mode = true
		return
		
	elif GlobalVariables.is_casual_mode == true:
		GlobalVariables.is_casual_mode = false
	
