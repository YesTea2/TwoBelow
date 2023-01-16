extends Area2D

export var is_inside  = false
export var is_outside = true

export(PackedScene) var indoor_scene
export(PackedScene) var outdoor_scene
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func go_inside():
	if is_outside == true:
		var go = get_tree().change_scene_to(indoor_scene)
	elif is_inside == true:
		var go = get_tree().change_scene_to(outdoor_scene)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
