extends CanvasLayer

export var player_profile : Texture
export var villager_profile : Texture
export var walki_profile : Texture
#export var villager_profile : T
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bar : TextureProgress = $TextureProgress
onready var alert : AnimatedSprite = $Alert
onready var temprature_text : Label = $temp_text
var rand_generate = RandomNumberGenerator.new()
var giving_weather_alert = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$Text_Container.hide()
	$Text_Container/Container_Text.hide()
	$Text_Container/Character_Photo.hide()
	$Alert.hide()
	set_percent_value_int(100)
	

func _display_center_message(message_to_display, profile, length_of_alert):
	$Text_Container.show()
	$Text_Container/Container_Text.text = message_to_display
	$Text_Container/Container_Text.show()
	if profile == "Player":
		$Text_Container/Character_Photo.texture = player_profile
	if profile == "Villager":
		$Text_Container/Character_Photo.texture = villager_profile
	if profile == "walki":
		$Text_Container/Character_Photo.texture = walki_profile
	$Text_Container/Character_Photo.show()
	#$CenterText.show()
	yield(get_tree().create_timer(length_of_alert), "timeout")
	$Text_Container/Character_Photo.hide()
	$Text_Container/Container_Text.hide()
	$Text_Container.hide()
	if $Alert.playing:
		$Alert.stop()
		$Alert.hide()
	if giving_weather_alert == true:
		giving_weather_alert = false
	#$CenterText.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func weather_warning():
	giving_weather_alert = true
	$Alert.show()
	$Alert.speed_scale = .5
	$Alert.play()
	rand_generate.randomize()
	var rand_int = rand_generate.randi_range(1,3)
	if rand_int == 1:
		_display_center_message("WEATHER ALERT! A huge blizzard is passing by with below freezing winds, find or make shelter immediately!", "walki", 7)
	if rand_int == 2:
		_display_center_message("WEATHER ALERT! Below freezing winds and extreme snow incoming, find or make shelter immediately!", "walki", 7)
	if rand_int == 3:
		_display_center_message("WEATHER ALERT! Below freezing temperature with extreme wind & snow incoming, find or make shelter immediately!", "walki", 7)

func weather_clear():
	giving_weather_alert = true
	$Alert.show()
	$Alert.speed_scale = .5
	$Alert.play()
	rand_generate.randomize()
	var rand_int = rand_generate.randi_range(1,3)
	if rand_int == 1:
		_display_center_message("The storm has cleared up, stay warm out there!", "walki", 5)
	if rand_int == 2:
		_display_center_message("Looks like the storm is over, you should be ok to keep moving.", "walki", 5)
	if rand_int == 3:
		_display_center_message("Whew! looks like the storm has cleared, that was a doozy!", "walki", 5)

func set_percent_value_int(values):
	bar.value = values


func _on_Outside_lower_temp_fast():
	bar.value -= .02
	print("lowering")
	pass

func _on_Outside_lower_temp_slow():
	bar.value -= .007
	print("lowering")
	pass

func _on_Outside_raise_temp_fast():
	bar.value += .15
	pass

func _on_Outside_raise_temp_slow():
	bar.value += .02
	pass



func _on_Player_doorway_entered():
	if giving_weather_alert == true:
		return
	rand_generate.randomize()
	var rand_int = rand_generate.randi_range(1,4)
	if rand_int == 1:
		_display_center_message("Should I go inside? \n \n Press E to enter", "Player", 10)
	if rand_int == 2:
		_display_center_message("There may be things of use inside. \n \n Press E to enter", "Player", 10)
	if rand_int ==3:
		_display_center_message("I can go inside to escape the cold. \n \n Press E to enter", "Player", 10)
	if rand_int ==4:
		_display_center_message("I could find generator parts inside. \n \n Press E to enter", "Player", 10)
	pass
	
func _on_Player_doorway_exited():
	if giving_weather_alert == true:
		return
	$Text_Container.hide()
	$Text_Container/Character_Photo.hide()
	$Text_Container/Container_Text.hide()
	pass
	



func _on_Outside_warn_of_weather():
	weather_warning()


func _on_Outside_clear_of_storm():
	weather_clear()


func _on_Outside_current_temp_below_freezing():
	yield(get_tree().create_timer(6), "timeout")
	temprature_text.text = "Below Zero"



func _on_Outside_current_temp_freezing():
	$Alert.show()
	$Alert.speed_scale = .5
	$Alert.play()
	yield(get_tree().create_timer(2), "timeout")
	temprature_text.text = "Freezing"
	$Alert.stop()
	$Alert.hide()



func _on_Outside_current_temp_normal():
	
	$Alert.show()
	$Alert.speed_scale = .5
	$Alert.play()
	yield(get_tree().create_timer(2), "timeout")
	temprature_text.text = "Cold"
	$Alert.stop()
	$Alert.hide()

