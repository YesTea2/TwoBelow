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


func handle_level_changed(current_level_name: String):
	
	var next_level_name: String
	
	match current_level_name:
		"Outside":
			next_level_name = "Inside_Building"
		"Inside_Building":
			next_level_name = "Outside"
		_:
			return
	
	
	next_level = load("res://" + next_level_name + ".tscn").instance()
	
	next_level.layer = -1
	add_child(next_level)
	anim.play("fade_in")
	
	next_level.connect("level_changed", self, "handle_level_changed")
	transfer_data_between_scenes(current_level, next_level)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func transfer_data_between_scenes(old_scene, new_scene):
	new_scene.load_level_paramters(old_scene.level_parameters)
	pass

#func _on_Outside_level_changed(level_name):
	#handle_level_changed(level_name)


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		"fade_in":
			current_level.cleanup()
			current_level = next_level
			current_level.layer = 1
			next_level = null
			anim.play("fade_out")
		"fade_out":
			current_level.play_loaded_sound()
