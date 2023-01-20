extends Area2D

export var is_inside  = false
export var is_outside = true

export var ignore_location = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var door_number = 0
onready var door_pos : Position2D = $DoorPos
var pos : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
