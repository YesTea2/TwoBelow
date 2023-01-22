extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var story_one : Label = $TextureRect/Story_01
onready var story_two : Label = $TextureRect/Story_02
onready var story_three : Label = $TextureRect/Story_03
onready var story_four : Label = $TextureRect/Story_04

onready var anim : AnimationPlayer = $AnimationPlayer

var story_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	MusicController.play_open_menu()
	anim.play("load_story")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "load_story":
		story_one.show()
		return
	elif anim_name == "close":
		get_tree().change_scene("res://SceneSwitcher.tscn")


func _on_Left_Button_pressed():
	MusicController.play_button("down")
	if story_index == 0:
		return
	if story_index == 1:
		story_two.hide()
		story_one.show()
		story_index -= 1
		return
	if story_index == 2:
		story_three.hide()
		story_two.show()
		story_index -= 1
		return
	if story_index == 3:
		story_four.hide()
		story_three.show()
		story_index -=1
		return


func _on_Right_Button_pressed():
	MusicController.play_button("down")
	if story_index == 0:
		story_one.hide()
		story_two.show()
		story_index +=1
		return
	if story_index == 1:
		story_two.hide()
		story_three.show()
		story_index+=1
		return
	if story_index == 2:
		story_three.hide()
		story_four.show()
		story_index+=1
		return
	if story_index == 3:
		MusicController.play_close_menu()
		anim.play("close")
		
		
	pass # Replace with function body.


func _on_Left_Button_mouse_entered():
	MusicController.play_button("highlight")
	pass # Replace with function body.


func _on_Right_Button_mouse_entered():
	MusicController.play_button("highlight")
	pass # Replace with function body.

