extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var anim : AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	MusicController.play_music()
	anim.play("FI")
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear2db(GlobalVariables.current_music_slider_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),linear2db(GlobalVariables.current_main_audio_slider_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear2db(GlobalVariables.current_sfx_slider_value))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().change_scene("res://Menu.tscn")
