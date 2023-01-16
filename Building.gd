extends StaticBody2D

export var building_one : Texture
export var  building_two : Texture

export(PackedScene) var doorway
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#onready var door : Position2D = $Door
var rand_generate = RandomNumberGenerator.new()

signal doorway_entered

# Called when the node enters the scene tree for the first time.
func _ready():
	rand_generate.randomize()
	var rand_int = rand_generate.randi_range(1,2)
	choose_building_sprite(rand_int)
	var door = doorway.instance()
	door.position = Vector2($DoorPos.position.x, $DoorPos.position.y)
	add_child_below_node(get_node("DoorPos"),door)
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
	
