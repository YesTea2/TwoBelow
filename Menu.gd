extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var anim : AnimationPlayer = $Start_Anim


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Start_Button_pressed():
	MusicController.play_specific_sound("sign_fall")
	anim.play("Start")
	
	

func _on_Quit_Button_pressed():
	MusicController.play_button("down")
	get_tree().quit()


func _on_Options_Button_pressed():
	MusicController.play_button("down")
	var options = load("res://Settings_Menu.tscn").instance()
	get_tree().current_scene.add_child(options)
	pass # Replace with function body.

#$Music.stream = main_music
	#$Music.play()

func _on_Start_Anim_animation_finished(anim_name):
	MusicController.stop_sfx()
	get_tree().change_scene("res://Intro.tscn")


func _on_Start_Button_mouse_entered():
	MusicController.play_button("highlight")
	pass # Replace with function body.


func _on_Options_Button_mouse_entered():
	MusicController.play_button("highlight")
	pass # Replace with function body.


func _on_Quit_Button_mouse_entered():
	MusicController.play_button("highlight")
	pass # Replace with function body.



	
