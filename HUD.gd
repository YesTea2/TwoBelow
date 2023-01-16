extends CanvasLayer

export var player_profile : Texture
export var villager_profile : Texture
#export var villager_profile : T
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bar : TextureProgress = $TextureProgress
var rand_generate = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	$Text_Container.hide()
	$Text_Container/Container_Text.hide()
	$Text_Container/Character_Photo.hide()
	set_percent_value_int(100)
	

func _display_center_message(message_to_display, profile):
	$Text_Container.show()
	$Text_Container/Container_Text.text = message_to_display
	$Text_Container/Container_Text.show()
	if profile == "Player":
		$Text_Container/Character_Photo.texture = player_profile
	if profile == "Villager":
		$Text_Container/Character_Photo.texture = villager_profile
	$Text_Container/Character_Photo.show()
	#$CenterText.show()
	yield(get_tree().create_timer(10), "timeout")
	$Text_Container/Character_Photo.hide()
	$Text_Container/Container_Text.hide()
	$Text_Container.hide()
	#$CenterText.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Declare member variables here. Examples:
# var a = 2
# var b = "text"




func set_percent_value_int(values):
	bar.value = values


func _on_Outside_lower_temp_fast():
	bar.value -= .05
	print("lowering")
	pass

func _on_Outside_lower_temp_slow():
	bar.value -= .005
	print("lowering")
	pass

func _on_Outside_raise_temp_fast():
	bar.value += .5
	pass

func _on_Outside_raise_temp_slow():
	bar.value += .05
	pass

func _on_Player_doorway_entered():
	rand_generate.randomize()
	var rand_int = rand_generate.randi_range(1,4)
	if rand_int == 1:
		_display_center_message("Should I go inside? \n \n Press E to enter", "Player")
	if rand_int == 2:
		_display_center_message("There may be things of use inside. \n \n Press E to enter", "Player")
	if rand_int ==3:
		_display_center_message("I can go inside to escape the cold. \n \n Press E to enter", "Player")
	if rand_int ==4:
		_display_center_message("I could find generator parts inside. \n \n Press E to enter", "Player")
	pass
	
func _on_Player_doorway_exited():
	$Text_Container.hide()
	$Text_Container/Character_Photo.hide()
	$Text_Container/Container_Text.hide()
	pass
	

