extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _setposition():
	print("setting position")
	var posx = GlobalVariables.temporary_x
	var posy = GlobalVariables.temporary_y
	global_position = Vector2(posx, posy)
	
func remove():
	queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
