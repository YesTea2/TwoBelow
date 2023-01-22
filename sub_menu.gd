extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var options = load("res://Settings_Menu.tscn").instance()
	get_tree().current_scene.add_child(options)

	GlobalVariables.is_in_sub_menu = true
	Signals.connect("destroy_sub_menu", self, "destroy_me")
	
func destroy_me():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
