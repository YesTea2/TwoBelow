extends CanvasLayer

export var player_profile : Texture
export var villager_profile : Texture
export var walki_profile : Texture
export (Resource) var player_var
export (Resource) var weather_var
export (Resource) var inventory_var
#export var villager_profile : T
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var bar : TextureProgress = $TextureProgress
onready var alert : AnimatedSprite = $Alert
onready var temprature_text : Label = $temp_text
onready var message_time : Timer = $center_message_time
onready var temp_freeze_time : Timer = $temp_freezing_timer
onready var temp_normal_time : Timer = $temp_normal_timer
onready var temp_below_freeze_time : Timer = $temp_below_freeze_timer

onready var ice_amount_text : Label = $Inventory/Ice_Block_Amount
onready var log_amount_text : Label = $Inventory/Log_Amount
onready var pipe_amount_text : Label = $Inventory/Pipe_Amount
onready var wire_amount_text : Label = $Inventory/Wire_Amount

onready var buy_ice_button : Button = $Inventory/Ice_Button
onready var buy_fire_button : Button = $Inventory/Fire_Button
onready var buy_repair_button : Button = $Inventory/Repair_Button

onready var inventory_container : ReferenceRect = $Inventory
onready var crafting_prompt : ReferenceRect = $Cratft_Prompt
onready var bottom_inventory : ReferenceRect = $Bottom_Bar

onready var crafting_prompt_Text : Label = $Cratft_Prompt/Label
onready var yes_craft_button : Button = $Cratft_Prompt/Yes_Craft
onready var no_craft_button : Button = $Cratft_Prompt/No_Craft


var rand_generate = RandomNumberGenerator.new()
var giving_weather_alert = false
# Called when the node enters the scene tree for the first time.
func _ready():
	player_var.connect("doorway_entered", self, "_on_Player_doorway_entered")
	player_var.connect("doorway_exited", self, "_on_Player_doorway_exited")
	weather_var.connect("clear_of_storm", self, "_on_clear_of_storm")
	weather_var.connect("current_temp_below_freezing", self, "_on_current_temp_below_freezing")
	weather_var.connect("current_temp_freezing", self, "_on_current_temp_freezing")
	weather_var.connect("current_temp_normal", self, "_on_current_temp_normal")
	weather_var.connect("raise_temp_fast", self, "_on_raise_temp_fast")
	weather_var.connect("lower_temp_fast", self, "_on_lower_temp_fast")
	weather_var.connect("lower_temp_slow", self, "_on_lower_temp_slow")
	weather_var.connect("raise_temp_slow", self, "_on_raise_temp_slow")
	weather_var.connect("warn_of_weather", self, "_on_warn_of_weather")
	
	$Text_Container.hide()
	$Text_Container/Container_Text.hide()
	$Text_Container/Character_Photo.hide()
	$Alert.hide()
	set_percent_value_int(100)
	
func _process(delta):
	bar.value = weather_var.bar_value / 2

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
	message_time.wait_time = length_of_alert
	message_time.start()

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
	weather_var.bar_value = values

func _on_lower_temp_fast():
	weather_var.bar_value -= .02
	print("lowering" + str(weather_var.bar_value))
	pass

func _on_lower_temp_slow():
	weather_var.bar_value -= .007
	print("lowering" + str(weather_var.bar_value))
	pass

func _on_raise_temp_fast():
	weather_var.bar_value += .15
	pass

func _on_raise_temp_slow():
	weather_var.bar_value += .02
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
	
func _on_warn_of_weather():
	weather_warning()

func _on_clear_of_storm():
	weather_clear()

func _on_current_temp_below_freezing():
	temp_below_freeze_time.wait_time = 6
	temp_below_freeze_time.start()

func _on_current_temp_freezing():
	$Alert.show()
	$Alert.speed_scale = .5
	$Alert.play()
	temp_freeze_time.wait_time = 2
	temp_freeze_time.start()

func _on_current_temp_normal():
	
	$Alert.show()
	$Alert.speed_scale = .5
	$Alert.play()
	temp_normal_time.wait_time = 2
	temp_normal_time.start()

func _on_center_message_time_timeout():
	$Text_Container/Character_Photo.hide()
	$Text_Container/Container_Text.hide()
	$Text_Container.hide()
	if $Alert.playing:
		$Alert.stop()
		$Alert.hide()
	if giving_weather_alert == true:
		giving_weather_alert = false

func _on_temp_below_freeze_timer_timeout():
	temprature_text.text = "Below Zero"

func _on_temp_freezing_timer_timeout():
	temprature_text.text = "Freezing"
	$Alert.stop()
	$Alert.hide()

func _on_temp_normal_timer_timeout():
	temprature_text.text = "Cold"
	$Alert.stop()
	$Alert.hide()

func _on_trying_to_craft_wall():
	show_crafting_choice("Ice Wall", "Ice Brick", "none", 6, 0)
	pass
func _on_trying_to_craft_fire():
	show_crafting_choice("Fire Kit", "Log", "none", 3, 0)
	pass
func _on_trying_to_craft_repair():
	show_crafting_choice("Repair Kit", "Copper Pipe", "Wire", 2, 6)
	pass
func crafting_fire():
	pass
func crafting_wall():
	pass
func crafting_repair():
	pass
	
func show_crafting_choice(type_of_item: String, item_needed : String, second_item : String, item_one_amount, item_two_amount):
	if second_item == "none":
		crafting_prompt_Text.text = "Craft " + "type_of_item" + "? /n The cost is " + "item_needed" + " x" + str(item_one_amount)
	if second_item != "none":
		crafting_prompt_Text.text = "Craft " + "type_of_item" + "? /n The cost is " + "item_needed" + " x" + str(item_one_amount) + " and " + "item_needed" + " x" + str(item_two_amount)
	crafting_prompt_Text.show()
	
