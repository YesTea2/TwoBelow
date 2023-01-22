extends Area2D


onready var sprite_holder : Sprite = $Sprite
onready var genP : Particles2D = $GenP
export var sprite_broke : Texture
export var sprite_fixed : Texture

export var generator_number = 0
var is_next_to_generator
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	if generator_number == 1:
		if GlobalVariables.generator_one_fixed == true:
			genP.emitting = true
			sprite_holder.texture = sprite_fixed
			return
	if generator_number == 2:
		if GlobalVariables.generator_two_fixed == true:
			genP.emitting = true
			sprite_holder.texture = sprite_fixed
			return
	else:
		sprite_holder.texture = sprite_broke
		
func _input(event):
	if event.is_action_pressed("use"):
		if is_next_to_generator == true:
			if GlobalVariables.current_crafted_repair_amount >= 1:
				GlobalVariables.current_crafted_repair_amount -= 1
				GlobalVariables.gen_total_fixed +=1
				Signals.emit_signal("update_repair_amount")
				Signals.emit_signal("fixed_gen")
				MusicController.play_specific_sound("generator_on")
				fix_generator()
				return
			else:
				Signals.emit_signal("no_repair_kit_at_gen")
				return
			
		pass

func fix_generator():
	if generator_number == 1:
		genP.emitting = true
		GlobalVariables.generator_one_fixed = true
		return
	if generator_number == 2:
		genP.emitting = true
		GlobalVariables.generator_two_fixed = true
		return

func _on_Generator_area_entered(area):
	if area.name.begins_with("P"):
		Signals.emit_signal("at_a_gen")
		is_next_to_generator = true
		
	


func _on_Generator_area_exited(area):
	if area.name.begins_with("P"):
		is_next_to_generator = false
