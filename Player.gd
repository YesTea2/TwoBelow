extends KinematicBody2D


export(Resource) var player_info


onready var foot_timer : Timer = $Player_Foot_Timer
onready var foot_sound : AudioStreamPlayer2D = $Foot_Sound
# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	foot_timer.connect("timeout", self, "_on_finish_waiting_for_part")
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
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = false
		if player_info.is_inside == false:
			handle_player_part(player_info.foot_step_side, player_info.time_foot_outdoor, "snow")
		if player_info.is_inside == true:
			handle_player_part(player_info.snow_footstep_side, player_info.time_foot_indoor, "wood")
		
	elif direction.x < 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = true
		if player_info.is_inside == false:
			handle_player_part(player_info.foot_step_side, player_info.time_foot_outdoor, "snow")
		if player_info.is_inside == true:
			handle_player_part(player_info.snow_footstep_side, player_info.time_foot_indoor, "wood")
		
	elif direction.y < 0:
		$AnimatedSprite.animation = "up"
		if player_info.is_inside == false:
			handle_player_part(player_info.foot_step, player_info.time_foot_outdoor, "snow")
		if player_info.is_inside == true:
			handle_player_part(player_info.snow_footstep, player_info.time_foot_indoor, "wood")
		
		
	elif direction.y > 0 :
		$AnimatedSprite.animation = "down"
		if player_info.is_inside == false:
			handle_player_part(player_info.foot_step, player_info.time_foot_outdoor, "snow")
		if player_info.is_inside == true:
			handle_player_part(player_info.snow_footstep, player_info.time_foot_indoor, "wood")
	
	
	move_and_slide(direction, Vector2(0,0), false, 4, 0.785, true)
	
	#if player_info.is_at_door == false:
		
	#for index in get_slide_count():
		#var collision = get_slide_collision(index)
			#if collision.collider.is_in_group("doors"):
				#player_info.emit_signal("doorway_entered")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
	if player_info.is_at_door == false:
		if area.name == "Doorway":
			player_info.is_at_door = true;
			print("colliding")
			player_info.emit_signal("doorway_entered")



func _on_Area2D_area_exited(area):
	if player_info.is_at_door == true:
		if area.name == "Doorway":
			player_info.is_at_door = false
			player_info.emit_signal("doorway_exited")


func _input(event):
	if player_info.is_at_door == true:
		if event.is_action_pressed("use"):
			player_info.emit_signal("using_door")
			if player_info.is_inside == false:
				player_info.is_inside = true
			elif player_info.is_inside == true:
				player_info.is_inside = false
			print("Using Door")
		

