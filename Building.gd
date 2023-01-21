extends StaticBody2D

export var building_one : Texture
export var  building_two : Texture
export(PackedScene) var doorway
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var door : Position2D = $Door
var rand_generate = RandomNumberGenerator.new()

export var building_number = 0

# warning-ignore:unused_signal
signal doorway_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	if GlobalVariables.has_generated_buildings == false:
		rand_generate.randomize()
		var rand_int = rand_generate.randi_range(1,2)
		choose_building_sprite(rand_int)
		if rand_int == 2:
			GlobalVariables.set_building_sprite(building_number, true)
	elif GlobalVariables.has_generated_buildings == true:
		if GlobalVariables.return_type_container(building_number) == true:
			$Sprite.texture = building_two
		elif GlobalVariables.return_type_container(building_number) == false:
			$Sprite.texture = building_one
			
	var door = doorway.instance()
	door.position = Vector2($DoorPos.position.x, $DoorPos.position.y)
	door.door_number = building_number
	print(str(door.position) + "door current")
	add_child_below_node(get_node("DoorPos"),door)
	door.door_pos.position = Vector2(door.global_position.x, door.global_position.y + 10)
	print(str(door.door_pos.position))
	#get_parent().add_child(door)
	
	pass#$Door.set_physics_process(false)
	#door.connect("body_entered", self, "_on_Door_body_entered")




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
#	pass


func choose_building_sprite(number):
	
	if number == 1:
		$Sprite.texture = building_one
	elif number == 2:
		$Sprite.texture = building_two
		
	print(str(number))

#f#unc _on_Door_body_entered(body):
	#if body.name == "Player":
	#	$door.set_physics_process(true)
	#	emit_signal("doorway_entered")
	#	door.disconnect("body_entered", self, "_on_Door_body_entered")
	


func _on_No_Placement_area_entered(area):
	if area.name.begins_with("P"):
		GlobalVariables.is_to_close_to_building = true


func _on_No_Placement_area_exited(area):
	if area.name.begins_with("P"):
		GlobalVariables.is_to_close_to_building = false
	
