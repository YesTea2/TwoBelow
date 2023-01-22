extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var check_one : CheckBox = $CheckBox
onready var check_two : CheckBox = $CheckBox2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Music_Volume_value_changed(value) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear2db(value))



func _on_Main_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear2db(value))


func _on_SFX_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear2db(value))


func _on_CheckBox_pressed():
	OS.window_fullscreen = true
	check_two.pressed = false
	pass # Replace with function body.


func _on_CheckBox2_pressed():
	OS.window_fullscreen = false
	check_one.pressed = false
	pass # Replace with function body.


func _on_Close_Settings_Button_pressed():
	queue_free()
	pass # Replace with function body.
