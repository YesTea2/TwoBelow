extends KinematicBody2D


export(Resource) var player_info
export(Resource) var ice_wall_front
export(Resource) var fire

onready var foot_timer : Timer = $Player_Foot_Timer
onready var foot_sound : AudioStreamPlayer2D = $Foot_Sound
onready var left_area : Position2D = $Left_Area
onready var right_area : Position2D = $Right_Area
onready var up_area : Position2D = $Up_Area
onready var down_area : Position2D = $Down_Area
onready var spawn_area : Position2D = $Spawn_area

var is_facing_left = false
var is_facing_right = true
var is_facing_up = false
var is_facing_down = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	foot_timer.connect("timeout", self, "_on_finish_waiting_for_part")
# warning-ignore:return_value_discarded
	Signals.connect("build_ice_wall", self, "build_ice_wall")
	Signals.connect("build_fire", self, "build_fire")
	pass # Replace with function body.

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		
		
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		
		
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		
		
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		
		
	if direction.length() > 0:
		direction = direction.normalized()
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	position += direction * player_info.speed * delta
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	if direction.x > 0:
		is_facing_right = false
		is_facing_left = true
		is_facing_down = false
		is_facing_up = false
		update_global_look()
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = false
		if player_info.is_inside == false:
			handle_player_part(player_info.foot_step_side, player_info.time_foot_outdoor, "snow")
		if player_info.is_inside == true:
			handle_player_part(player_info.snow_footstep_side, player_info.time_foot_indoor, "wood")
		
	elif direction.x < 0:
		is_facing_right = true
		is_facing_left = false
		is_facing_down = false
		is_facing_up = false
		update_global_look()
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = true
		if player_info.is_inside == false:
			handle_player_part(player_info.foot_step_side, player_info.time_foot_outdoor, "snow")
		if player_info.is_inside == true:
			handle_player_part(player_info.snow_footstep_side, player_info.time_foot_indoor, "wood")
		
	elif direction.y < 0:
		is_facing_right = false
		is_facing_left = false
		is_facing_down = false
		is_facing_up = true
		update_global_look()
		$AnimatedSprite.animation = "up"
		if player_info.is_inside == false:
			handle_player_part(player_info.foot_step, player_info.time_foot_outdoor, "snow")
		if player_info.is_inside == true:
			handle_player_part(player_info.snow_footstep, player_info.time_foot_indoor, "wood")
		
		
	elif direction.y > 0 :
		is_facing_right = false
		is_facing_left = false
		is_facing_down = true
		is_facing_up = false
		update_global_look()
		$AnimatedSprite.animation = "down"
		if player_info.is_inside == false:
			handle_player_part(player_info.foot_step, player_info.time_foot_outdoor, "snow")
		if player_info.is_inside == true:
			handle_player_part(player_info.snow_footstep, player_info.time_foot_indoor, "wood")
	
	
# warning-ignore:return_value_discarded
	move_and_slide(direction, Vector2(0,0), false, 4, 0.785, true)
	
func update_global_look():
	GlobalVariables.is_player_facing_down = is_facing_down
	GlobalVariables.is_player_facing_left = is_facing_left
	GlobalVariables.is_player_facing_right = is_facing_right
	GlobalVariables.is_player_facing_up = is_facing_up
#var door = doorway.instance()
	#door.position = Vector2($DoorPos.position.x, $DoorPos.position.y)
	#door.door_number = building_number
	#get_parent().add_child(waterbolt)
	
func build_fire():
	var fire_pit = fire.instance()
	var posx = spawn_area.global_position.x
	var posy = spawn_area.global_position.y
	GlobalVariables.temporary_x = posx
	GlobalVariables.temporary_y = posy
	get_parent().add_child(fire_pit)
	fire_pit._setposition()
	return
func build_ice_wall():
	print("this is trying to work")
	var icewall = ice_wall_front.instance()
	var posx = spawn_area.global_position.x
	var posy = spawn_area.global_position.y
	GlobalVariables.temporary_x = posx
	GlobalVariables.temporary_y = posy
	get_parent().add_child(icewall)
	icewall._setposition()
	return
		
	
func handle_player_part(part, time_for, type_of_ground):
	
	if player_info.is_waiting == false:
		player_info.is_waiting = true
		var footstep = part.instance()
		if type_of_ground == "snow":
			foot_sound.play()
		footstep.emitting = true
		footstep.global_position = Vector2(global_position.x + -.5 , global_position.y + 9)
		get_parent().add_child(footstep)
		foot_timer.wait_time = time_for
		foot_timer.start()
		
		

func _on_finish_waiting_for_part():
	player_info.is_waiting = false;
	
func _on_Area2D_area_entered(area):
	
	if area.name == "Doorway" && GlobalVariables.finished_displaying_door_message == false:
# warning-ignore:standalone_expression
		GlobalVariables.finished_displaying_door_message == true
		GlobalVariables.is_at_door = true
		Signals.emit_signal("doorway_entered")
		GlobalVariables.number_of_current_building = area.door_number
		if area.ignore_location == false:
			GlobalVariables.current_offset = area.door_pos.position
			print(str(GlobalVariables.current_offset))
		Signals.emit_signal("close_inventory")
		return
		
	if area.name.begins_with("Search") && GlobalVariables.is_at_door == false:
		var search_var = area.search_var
		search_var.prepar()
		print("colliding")
		Signals.emit_signal("close_inventory")
		Signals.emit_signal("on_next_to_searchable", search_var)
		return



func _on_Area2D_area_exited(area):

	if area.name == "Doorway":
		GlobalVariables.is_at_door = false
		Signals.emit_signal("doorway_exited")
		GlobalVariables.number_of_current_building = 0
		GlobalVariables.finished_displaying_door_message = false
		return
	if area.name.begins_with("Search"):
		var search_var = area.search_var
		if TempContainer.has_been_searched == true:
			search_var.searched_this()
			search_var.has_been_searched = true
		GlobalVariables.is_giving_item = false
		GlobalVariables.is_searching_drawer = false
		Signals.emit_signal("on_closed_container")
		return
	return

func _input(event):
	
	if event.is_action_pressed("menu"):
		get_tree().change_scene("res://Menu.tscn")
		return
	if event.is_action_pressed("use"):
		if GlobalVariables.is_at_door == true:
			if GlobalVariables.is_inside == true:
				GlobalVariables.coming_from_inside = true
			player_info.emit_signal("using_door")
			print("Using Door")
			return
		elif GlobalVariables.is_searching_drawer == true && GlobalVariables.is_giving_item == false:
			Signals.emit_signal("on_searched_container")
			GlobalVariables.is_searching_drawer = false
			return
	elif event.is_action_pressed("open_inventory"):
		print("opening inventory")
		Signals.emit_signal("is_opening_inventory")
	elif event.is_action_pressed("use_fire"):
		Signals.emit_signal("pressing_place_fire")
		pass
	elif event.is_action_pressed("use_repair"):
		Signals.emit_signal("pressing_use_repair")
		pass
	elif event.is_action_pressed("use_wall"):
		Signals.emit_signal("pressing_place_ice_wall")
		pass
	elif event.is_action_pressed("use_ice_pick"):
		if GlobalVariables.is_currently_next_to_icewall == false:
			Signals.emit_signal("ice_pick_not_near_wall")
			return
	
