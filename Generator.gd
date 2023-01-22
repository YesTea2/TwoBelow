extends Area2D


onready var sprite_holder : Sprite = $Sprite
onready var genP : Particles2D = $GenP
export var sprite_broke : Texture
export var sprite_fixed : Texture

export var generator_number = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if generator_number == 1:
		if GlobalVariables.generator_one_fixed == true:
			sprite_holder.texture = sprite_fixed
	if generator_number == 2:
		if GlobalVariables.generator_two_fixed == true:
			sprite_holder.texture = sprite_fixed
	pass # Replace with function body.

func fix_generator():
	if generator_number == 1:
		genP.emitting = true
		GlobalVariables.generator_one_fixed = true
		return
	if generator_number == 2:
		genP.emitting = true
		GlobalVariables.generator_two_fixed = true
		return
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
