extends KinematicBody2D

export var time_foot_outdoor = 0.5
export var time_foot_indoor = 1.0
export var speed = 200.0
export var is_inside = false
export(PackedScene) var foot_step
export(PackedScene) var foot_step_side
export(PackedScene) var foot_step_idle
export(PackedScene) var snow_footstep_side
export(PackedScene) var snow_footstep

export(String, FILE, "*tscn,*scn") var outdoor_scene
export(String, FILE, "*tscn,*scn") var indoor_scene

signal doorway_entered
signal doorway_exited
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_at_door = false
var is_waiting = false


# Called when the node enters the scene tree for the first time.
func _ready():
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

	position += direction * speed * delta
	#position.x = clamp(position.x, 0, screen_size.x)
	#position.y = clamp(position.y, 0, screen_size.y)
	
	if direction.x > 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = false
		if is_inside == false:
			handle_player_part(foot_step_side, time_foot_outdoor)
		if is_inside == true:
			handle_player_part(snow_footstep_side, time_foot_indoor)
		
	elif direction.x < 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = true
		if is_inside == false:
			handle_player_part(foot_step_side, time_foot_outdoor)
		if is_inside == true:
			handle_player_part(snow_footstep_side, time_foot_indoor)
		
	elif direction.y < 0:
		$AnimatedSprite.animation = "up"
		if is_inside == false:
			handle_player_part(foot_step, time_foot_outdoor)
		if is_inside == true:
			handle_player_part(snow_footstep, time_foot_indoor)
		
		
	elif direction.y > 0 :
		$AnimatedSprite.animation = "down"
		if is_inside == false:
			handle_player_part(foot_step, time_foot_outdoor)
		if is_inside == true:
			handle_player_part(snow_footstep, time_foot_indoor)
	
	
	move_and_slide(direction, Vector2(0,0), false, 4, 0.785, true)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("doors"):
			emit_signal("doorway_entered")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func handle_player_part(part, time_for):
	
	if is_waiting == false:
		is_waiting = true
		var footstep = part.instance()
		footstep.emitting = true
		footstep.global_position = Vector2(global_position.x + -.5 , global_position.y + 9)
		get_parent().add_child(footstep)
		yield(get_tree().create_timer(time_for), "timeout")
		is_waiting = false;

func _on_Area2D_area_entered(area):
	if area.name == "Doorway":
		is_at_door = true;
		print("colliding")
		emit_signal("doorway_entered")



func _on_Area2D_area_exited(area):
	if area.name == "Doorway":
		is_at_door = false
		emit_signal("doorway_exited")


func _input(event):
	if is_at_door == true:
		if event.is_action_pressed("use"):
			change_scene()
		
func change_scene():
	if is_inside == false:
		var ERR = get_tree().change_scene(indoor_scene)
		
	elif is_inside == true:
		var ERR = get_tree().change_scene(outdoor_scene)
		
		
