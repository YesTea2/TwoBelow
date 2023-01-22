extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var story_one : Label = $TextureRect/Story_01
onready var story_two : Label = $TextureRect/Story_02
onready var story_three : Label = $TextureRect/Story_03

onready var anim : AnimationPlayer = $AnimationPlayer

var story_index = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("load_story")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationPlayer_animation_finished(anim_name):
	story_one.show()


func _on_Left_Button_pressed():
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


func _on_Right_Button_pressed():
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
		get_tree().change_scene("res://SceneSwitcher.tscn")
		
	pass # Replace with function body.
