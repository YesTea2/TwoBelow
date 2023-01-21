extends Area2D

func _ready():
	Signals.connect("looking_for_ice_wall", self, "check_for_player")


var is_player_around = false

func check_for_player():
	if is_player_around == true:
		remove()
func _input(event):
	if event.is_action_pressed("use_ice_pick"):
		if is_player_around == true:
			remove()
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




func _on_Ice_Wall_Front_area_entered(area):
	if area.name.begins_with("P"):
		GlobalVariables.is_currently_next_to_icewall = true
		is_player_around = true
		GlobalVariables.is_able_to_build_another = false

func _on_Ice_Wall_Front_area_exited(area):
	if area.name.begins_with("P"):
		GlobalVariables.is_currently_next_to_icewall = false
		GlobalVariables.is_able_to_build_another = true
		is_player_around = false
	pass # Replace with function body.
