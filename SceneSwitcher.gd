extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var next_level = null

onready var current_level = $Outside
onready var anim = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_level.connect("level_changed", self, "handle_level_changed")
	current_level.play_loaded_sound()



func handle_level_changed(current_level_name: String):
	
	var next_level_name: String
	var name_for_level : String
	var number_for_building = GlobalVariables.number_of_current_building
	name_for_level = "Inside_Building_" + str(number_for_building)
	print(name_for_level)
	match current_level_name:
		"Outside":
			next_level_name = name_for_level
			GlobalVariables.is_inside = true
			GlobalVariables.is_outside = false
		name_for_level:
			next_level_name = "Outside"
			GlobalVariables.is_outside = true
			GlobalVariables.is_inside = false
		_:
			return
	
	
	next_level = load("res://" + next_level_name + ".tscn").instance()

	current_level.visible = false
	Signals.emit_signal("hide_entire_hud")
	next_level.visible = false
	add_child(next_level)
	anim.play("fade_in")
	next_level.connect("level_changed", self, "handle_level_changed")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func transfer_data_between_scenes(old_scene, new_scene):
	new_scene.load_level_paramters(old_scene.level_parameters)


#func _on_Outside_level_changed(level_name):
	#handle_level_changed(level_name)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"fade_in":
			current_level.cleanup()
			current_level = next_level
			Signals.emit_signal("show_entire_hud")
			current_level.visible = true
			next_level = null
			anim.play("fade_out")
		"fade_out":
			current_level.play_loaded_sound()
