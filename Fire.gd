extends Area2D


onready var animation : AnimatedSprite = $AnimatedSprite
onready var anim_control : AnimationPlayer = $Fire_Controller

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	anim_control.play("Start_Fire")
	
func _setposition():
	print("setting position")
	var posx = GlobalVariables.temporary_x
	var posy = GlobalVariables.temporary_y
	global_position = Vector2(posx, posy)




	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_Fire_area_entered(area):
	if area.name.begins_with("P"):
		print("Player next to fire")
		GlobalVariables.is_player_next_to_fire = true


func _on_Fire_area_exited(area):
	var namet
	if area.name.begins_with("P"):
		namet = area
		WeatherControl.emit_signal("player_left_fire")
		GlobalVariables.is_player_next_to_fire = false
		return
	else:
		anim_control.play("Stop_Fire")
