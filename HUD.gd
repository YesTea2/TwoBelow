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
onready var crafting_promp_time : Timer = $Crafting_Promp_Timer
onready var w_alert_anim : AnimationPlayer = $Alert_Player

onready var ice_amount_text : Label = $Inventory/Ice_Block_Amount
onready var log_amount_text : Label = $Inventory/Log_Amount
onready var pipe_amount_text : Label = $Inventory/Pipe_Amount
onready var wire_amount_text : Label = $Inventory/Wire_Amount

onready var buy_ice_button : TextureButton = $Crafting_Holder/Ice_Button
onready var buy_fire_button : TextureButton = $Crafting_Holder/Fire_Button
onready var buy_repair_button : TextureButton = $Crafting_Holder/Repair_Button

onready var inventory_container : ReferenceRect = $Inventory
onready var crafting_prompt : ReferenceRect = $Cratft_Prompt
onready var crafting_container : ReferenceRect = $Crafting_Holder
onready var bottom_inventory : ReferenceRect = $Bottom_Bar

onready var crafting_prompt_Text : Label = $Cratft_Prompt/Label
onready var yes_craft_button :TextureButton = $Cratft_Prompt/Yes_Craft
onready var no_craft_button : TextureButton = $Cratft_Prompt/No_Craft

onready var bottom_bar_wall_amount : Label = $Wall_Use_Text
onready var bottom_bar_fire_amount : Label = $Fire_Use_Text
onready var bottom_bar_repair_amount : Label = $Repair_Use_Text

onready var chat_anim : AnimationPlayer = $Chat_Player

onready var alert_text_01 : Label = $Bottom_Alert/Bottom_Alert_Text

var is_freezing
var is_below
var is_cold

var is_trying_to_craft_fire = false
var is_trying_to_craft_wall = false
var is_trying_to_craft_repair = false

var is_yes_currently_pressed_for_crafting = false
var is_timer_running_for_crafting = false
var is_crafting = false
var has_yes_been_pressed = false
var is_inventory_open = false
var rand_generate = RandomNumberGenerator.new()
var giving_weather_alert = false

var search
# Called when the node enters the scene tree for the first time.
func _ready():
	temprature_text.text = WeatherControl.current_temp
	WeatherControl.connect("player_left_fire", self, "player_left_fire")
# warning-ignore:return_value_discarded
	Signals.connect("ice_pick_not_near_wall", self, "cant_use_pick")
# warning-ignore:return_value_discarded
	Signals.connect("build_ice_wall", self, "used_ice_wall")
# warning-ignore:return_value_discarded
	Signals.connect("build_fire", self, "used_fire")
# warning-ignore:return_value_discarded
	Signals.connect("not_next_to_generator", self, "not_next_to_generator")
# warning-ignore:return_value_discarded
	Signals.connect("trying_to_build_indoor", self, "trying_to_build_indoor")
# warning-ignore:return_value_discarded
	Signals.connect("not_surrounded_by_ice", self, "not_surrounded_by_ice")
# warning-ignore:return_value_discarded
	Signals.connect("no_fire_kit", self, "no_fire_kit")
# warning-ignore:return_value_discarded
	Signals.connect("no_ice_wall", self, "no_ice_wall")
# warning-ignore:return_value_discarded
	Signals.connect("no_repair_kit", self, "no_repair_kit") 
# warning-ignore:return_value_discarded
	Signals.connect("close_inventory", self, "_on_close_inventory")
# warning-ignore:return_value_discarded
	Signals.connect("on_searched_container", self, "_on_loot_container")
# warning-ignore:return_value_discarded
	Signals.connect("doorway_entered", self, "_on_Player_doorway_entered")
# warning-ignore:return_value_discarded
	Signals.connect("doorway_exited", self, "_on_Player_doorway_exited")
# warning-ignore:return_value_discarded
	Signals.connect("is_opening_inventory", self,  "_on_opening_inventory")
# warning-ignore:return_value_discarded
	WeatherControl.connect("clear_of_storm", self, "_on_clear_of_storm")
# warning-ignore:return_value_discarded
	WeatherControl.connect("current_temp_below_freezing", self, "_on_current_temp_below_freezing")
# warning-ignore:return_value_discarded
	WeatherControl.connect("current_temp_freezing", self, "_on_current_temp_freezing")
# warning-ignore:return_value_discarded
	WeatherControl.connect("current_temp_normal", self, "_on_current_temp_normal")
# warning-ignore:return_value_discarded
	WeatherControl.connect("raise_temp_fast", self, "_on_raise_temp_fast")
# warning-ignore:return_value_discarded
	WeatherControl.connect("lower_temp_fast", self, "_on_lower_temp_fast")
# warning-ignore:return_value_discarded
	WeatherControl.connect("lower_temp_slow", self, "_on_lower_temp_slow")
# warning-ignore:return_value_discarded
	WeatherControl.connect("raise_temp_slow", self, "_on_raise_temp_slow")
# warning-ignore:return_value_discarded
	WeatherControl.connect("warn_of_weather", self, "_on_warn_of_weather")
	
	WeatherControl.connect("warm_player", self, "_on_warm_player")
# warning-ignore:return_value_discarded
	Signals.connect("on_next_to_searchable", self, "_on_show_searchable")
# warning-ignore:return_value_discarded
	Signals.connect("on_give_item", self, "_on_give_resource")
# warning-ignore:return_value_discarded
	Signals.connect("on_closed_container", self, "_on_clear_and_close")
# warning-ignore:return_value_discarded
	Signals.connect("to_close_to_building", self, "to_close_to_building")
# warning-ignore:return_value_discarded
	Signals.connect("need_to_move", self, "need_to_move")
	Signals.connect("open_menu", self, "open_menu")
	Signals.connect("trying_to_leave_mountain", self, "trying_to_leave")
	Signals.connect("no_repair_kit_at_gen", self, "no_repair_kit_at_gen")
	Signals.connect("update_repair_amount", self, "update_repair_amount")
	Signals.connect("at_a_gen", self, "at_a_gen")
	Signals.connect("fixed_gen", self, "fixed_gen")
	_on_update_bottom_amount("fire")
	_on_update_bottom_amount("wall")
	_on_update_bottom_amount("repair")
	
	inventory_container.hide()
	crafting_prompt.hide()
	crafting_container.hide()
	
	$Text_Container.hide()
	$Text_Container/Container_Text.hide()
	$Text_Container/Character_Photo.hide()
	$Alert.hide()
	
	wire_amount_text.text = "Wires: " + str(GlobalVariables.current_total_wire)
	log_amount_text.text = "Logs: " + str(GlobalVariables.current_total_logs)
	pipe_amount_text.text = "Pipes: " + str(GlobalVariables.current_total_pipe)
	ice_amount_text.text = "Ice Blocks: " + str(GlobalVariables.current_total_ice)

func open_menu():
	var options = load("res://Settings_Menu.tscn").instance()
	get_tree().current_scene.add_child(options)
	pass # Replace with function body.
# warning-ignore:unused_argument
func _process(delta):
	WeatherControl.bar_value = clamp(WeatherControl.bar_value, 0, 100)
	bar.value = WeatherControl.bar_value
	

func _display_center_message(message_to_display, profile, length_of_alert):
	chat_anim.play("Show_Message")
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
	if length_of_alert != 99:
		message_time.wait_time = length_of_alert
		message_time.start()

func fixed_gen():
	if GlobalVariables.gen_total_fixed < 2:
		_display_center_message("Hey its working!!", "Player", 2.5)
		return
	elif GlobalVariables.gen_total_fixed >= 2:
		_display_center_message("Whatever you did worked!! the power is restored to the town, can't wait to see you back down here!", "walki", 3.5)
		Signals.emit_signal("game_won")
func at_a_gen():
	_display_center_message("This is one of the generators I need to fix!", "Player", 2.5)
func no_repair_kit_at_gen():
	_display_center_message("I need a repair kit to fix this generator", "Player", 2.5)
func update_repair_amount():
	update_amounts()
	
func trying_to_leave():
	_display_center_message("I need to fix the generators before going back down the mountain", "Player", 2.5)
func player_left_fire():
	temprature_text.text = WeatherControl.current_temp
func need_to_move():
	_display_center_message("It would be a waste to build more walls here, I should move farther away", "Player", 2.5)
func to_close_to_building():
	_display_center_message("I need to be further away from the building before making walls", "Player", 2.5)
func cant_use_pick():
	_display_center_message("There are no ice walls around to use this", "Player", 2.5)
func used_ice_wall():
	print("using ice")
	GlobalVariables.current_crafted_wall_amount -= 1
	_on_update_bottom_amount("wall")
func used_fire():
	GlobalVariables.current_crafted_fire_amount -=  1
	_on_update_bottom_amount("fire")
	pass
func not_next_to_generator():
	_display_center_message("I should be at a generator to use this", "Player", 2.5)
		
func trying_to_build_indoor():
	_display_center_message("I should build this outside", "Player", 2.5)
func not_surrounded_by_ice():
	_display_center_message("I should be behind some ice before starting a fire or this wind would just blow it out", "Player", 2.5)
	
func no_repair_kit():
	_display_center_message("I have no repair kits to use.", "Player", 2.5)

func no_ice_wall():
	_display_center_message("I have no ice walls currently.", "Player", 2.5)

func no_fire_kit():
	_display_center_message("I need a fire kit to do that.", "Player", 2.5)
	
func _on_show_searchable(search_var):
	
	TempContainer.current_ice = search_var.ice_amount
	TempContainer.current_log = search_var.log_amount
	TempContainer.current_pipe = search_var.pipe_amount
	TempContainer.current_wire = search_var.wire_amount
	TempContainer.has_pipe = search_var.has_pipe
	TempContainer.has_wire = search_var.has_wire
	TempContainer.contains_ice = search_var.contains_ice
	TempContainer.contains_log = search_var.contains_log
	TempContainer.contains_repair = search_var.contains_repair
	TempContainer.has_been_searched = search_var.has_been_searched
	#var scrip = script.script_var
	
	if search_var.is_cab == true:
		GlobalVariables.is_searching_drawer = true
		_display_center_message("Search the cabinet?.  Press E to open", "Player", 99)
		pass
	if search_var.is_fireplace == true:
		GlobalVariables.is_searching_drawer = true
		_display_center_message("Search the fireplace?.  Press E to open", "Player",  99)
		pass
	if search_var.is_fridge == true:
		GlobalVariables.is_searching_drawer = true
		_display_center_message("Search the fridge?.  Press E to open", "Player", 99)
		pass
	if search_var.is_nightstand == true:
		GlobalVariables.is_searching_drawer = true
		_display_center_message("Search the nightstand?.  Press E to open", "Player", 99)
		pass
	
func _on_loot_container():
	GlobalVariables.is_giving_item = true
	
	if TempContainer.has_been_searched == true:
		$Text_Container/Container_Text.text = "There is nothing left inside"
		GlobalVariables.is_searching_drawer = false
		return
	if TempContainer.has_wire == true && TempContainer.has_pipe == true:
		$Text_Container/Container_Text.text = "I found " + str(TempContainer.current_wire) + " wire and " + str(TempContainer.current_pipe) + " pipe!"
		var give_pipe = TempContainer.current_pipe
		var give_wire = TempContainer.current_wire
		_on_give_resource("pipe", give_pipe)
		_on_give_resource("wire", give_wire)
		GlobalVariables.is_searching_drawer = false
		TempContainer.has_been_searched = true
		
		return
	if TempContainer.has_wire == true:
		$Text_Container/Container_Text.text = "I found " + str(TempContainer.current_wire) + " wire!"
		var give_wire = TempContainer.current_wire
		_on_give_resource("wire", give_wire)
		TempContainer.has_been_searched = true
		GlobalVariables.is_searching_drawer = false
		return
	if TempContainer.has_pipe == true:
		$Text_Container/Container_Text.text = "I found " + str(TempContainer.current_pipe) + " pipe!"
		var give_pipe = TempContainer.current_pipe
		_on_give_resource("pipe", give_pipe)
		TempContainer.has_been_searched = true
		GlobalVariables.is_searching_drawer = false
		return
	if TempContainer.contains_log == true:
		$Text_Container/Container_Text.text = "I found " + str(TempContainer.current_log) + " log!"
		var give_log = TempContainer.current_log
		_on_give_resource("log", give_log)
		TempContainer.has_been_searched = true
		GlobalVariables.is_searching_drawer = false
		return
	if TempContainer.contains_ice == true:
		$Text_Container/Container_Text.text = "I found " + str(TempContainer.current_ice) + " ice brick!"
		var give_ice = TempContainer.current_ice
		_on_give_resource("ice", give_ice)
		TempContainer.has_been_searched = true
		GlobalVariables.is_searching_drawer = false
		return
	#is_cab = false
	#is_fireplace = false
	#is_fridge = false
	#is_nightstand = false

func _on_give_resource(type, amount):
	if type =="ice":
		var new_amount = GlobalVariables.current_total_ice + amount
		GlobalVariables.current_total_ice += amount
		ice_amount_text.text = "Ice Blocks: " + str(new_amount)
		GlobalVariables.is_giving_item = false
		return
	if type =="wire":
		var new_amount = GlobalVariables.current_total_wire + amount
		GlobalVariables.current_total_wire += amount
		wire_amount_text.text = "Wires: " + str(new_amount)
		GlobalVariables.is_giving_item = false
		return
	if type =="pipe":
		var new_amount = GlobalVariables.current_total_pipe + amount
		GlobalVariables.current_total_pipe += amount
		pipe_amount_text.text = "Copper Pipes: " + str(new_amount)
		GlobalVariables.is_giving_item = false
		return
	if type =="log":
		var new_amount = GlobalVariables.current_total_logs + amount
		GlobalVariables.current_total_logs += amount
		log_amount_text.text = "Logs: " + str(new_amount)
		GlobalVariables.is_giving_item = false
		return
	
func weather_warning():
	giving_weather_alert = true
	$Alert.show()
	$Alert.speed_scale = .5
	$Alert.play()
	
	alert_text_01.text = "Weather alert: Incoming storm, shelter immediately!"
	w_alert_anim.play("Blizzard_Note")


func weather_clear():
	giving_weather_alert = true
	$Alert.show()
	$Alert.speed_scale = .5
	$Alert.play()
	if WeatherControl.is_cold == true:
		alert_text_01.text = "Weather alert: The storm has passed over, temperatures rising"
	if WeatherControl.is_freeze == true:
		alert_text_01.text = "Weather alert: Storm clear, temperatures remain frigid"
	w_alert_anim.play("Blizzard_Note")

func set_percent_value_int(values):
	WeatherControl.bar_value = values

func _on_lower_temp_fast():
	if GlobalVariables.is_player_next_to_fire == true:
		return
	WeatherControl.bar_value -= .02
	
	pass

func _on_lower_temp_slow():
	if GlobalVariables.is_player_next_to_fire == true:
		return
	WeatherControl.bar_value -= .007
	pass

func _on_raise_temp_fast():
	if GlobalVariables.is_player_next_to_fire == true:
		return
	WeatherControl.bar_value += .15
	pass

func _on_raise_temp_slow():
	if GlobalVariables.is_player_next_to_fire == true:
		return
	WeatherControl.bar_value += .02
	pass
	
func _on_warm_player():
	WeatherControl.current_temp = "Cold"
	temprature_text.text = "Cold"
	WeatherControl.bar_value += .15
	pass
	

func _on_Player_doorway_entered():
	rand_generate.randomize()
	var rand_int = rand_generate.randi_range(1,4)
	if GlobalVariables.is_outside == true:
		GlobalVariables.finished_displaying_door_message = true
		if rand_int == 1:
			_display_center_message("Should I go inside? \n \n Press E to enter", "Player", 99)
			return
		if rand_int == 2:
			_display_center_message("I may find things of use inside. \n \n Press E to enter", "Player", 99)
			return
		if rand_int ==3:
			_display_center_message("I can go inside to escape the cold. \n \n Press E to enter", "Player", 99)
			return
		if rand_int ==4:
			_display_center_message("I never thought I would be searching abandoned buildings. \n \n Press E to enter", "Player", 99)
			return
		return
	if GlobalVariables.is_inside == true:
		GlobalVariables.finished_displaying_door_message = true
		if rand_int == 1:
			_display_center_message("I hope the town is doing ok without heating. \n \n Press E to exit", "Player", 99)
			return
		if rand_int == 2:
			_display_center_message("I guess I should head back out. \n \n Press E to exit", "Player", 99)
			return
		if rand_int ==3:
			_display_center_message("I should get back to fixing the generators. \n \n Press E to exit", "Player", 99)
			return
		if rand_int ==4:
			_display_center_message("I hope I get a hotcoco after this. \n \n Press E to exit", "Player", 99)
			return
		return
	
func _on_Player_doorway_exited():
	chat_anim.play("Hide_Message")
	$Text_Container/Character_Photo.hide()
	$Text_Container/Container_Text.hide()
	pass
func _on_close_chat_box():
	chat_anim.play("Hide_Message")
	$Text_Container/Character_Photo.hide()
	$Text_Container/Container_Text.hide()
func _on_clear_and_close():
	TempContainer.clear_the_searchable()
	chat_anim.play("Hide_Message")
	$Text_Container/Character_Photo.hide()
	$Text_Container/Container_Text.hide()
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
	is_cold = false
	is_freezing = true
	temp_freeze_time.wait_time = 2
	temp_freeze_time.start()

func _on_current_temp_normal():
	
	$Alert.show()
	$Alert.speed_scale = .5
	$Alert.play()
	is_freezing = false
	is_cold = true
	temp_normal_time.wait_time = 2
	temp_normal_time.start()

func _on_center_message_time_timeout():
	$Text_Container/Character_Photo.hide()
	$Text_Container/Container_Text.hide()
	chat_anim.play("Hide_Message")
	


func _on_temp_below_freeze_timer_timeout():
	$Alert.stop()
	$Alert.hide()
	WeatherControl.current_temp = "Below Zero"
	if GlobalVariables.is_player_next_to_fire == true:
		return
	temprature_text.text = "Below Zero"

func _on_temp_freezing_timer_timeout():
	WeatherControl.current_temp = "Freezing"
	if GlobalVariables.is_player_next_to_fire == true:
		return
	temprature_text.text = "Freezing"
	$Alert.stop()
	$Alert.hide()

func _on_temp_normal_timer_timeout():
	WeatherControl.current_temp = "Cold"
	if GlobalVariables.is_player_next_to_fire == true:
		return
	temprature_text.text = "Cold"
	$Alert.stop()
	$Alert.hide()

func _on_trying_to_craft_wall():
	if has_yes_been_pressed == false:
		show_crafting_choice("Ice Wall", "Ice Brick", "none", 6, 0)
		is_trying_to_craft_wall = true
		pass
func _on_trying_to_craft_fire():
	if has_yes_been_pressed == false:
		show_crafting_choice("Fire Kit", "Log", "none", 3, 0)
		is_trying_to_craft_fire = true
		pass
func _on_trying_to_craft_repair():
	if has_yes_been_pressed == false:
		show_crafting_choice("Repair Kit", "Copper Pipe", "Wire", 2, 6)
		is_trying_to_craft_repair = true
		pass
func crafting_fire():
	GlobalVariables.current_crafted_fire_amount += 1
	_on_update_bottom_amount("fire")
	pass
func crafting_wall():
	GlobalVariables.current_crafted_wall_amount += 1
	_on_update_bottom_amount("wall")
	pass
func crafting_repair():
	GlobalVariables.current_crafted_repair_amount +=1
	_on_update_bottom_amount("repair")
	pass
	
func _on_update_bottom_amount(type):
	print ("changing ice")
	if type == "fire":
		bottom_bar_fire_amount.text =str(GlobalVariables.current_crafted_fire_amount)
	if type == "wall":
		bottom_bar_wall_amount.text =str(GlobalVariables.current_crafted_wall_amount)
	if type == "repair":
		bottom_bar_repair_amount.text =str(GlobalVariables.current_crafted_repair_amount)
	
func show_crafting_choice(type_of_item, item_needed, second_item, item_one_amount, item_two_amount):
	crafting_prompt.show()
	yes_craft_button.show()
	no_craft_button.show()
	if second_item == "none":
		crafting_prompt_Text.text = "Craft " + type_of_item + "? \n It costs "+ str(item_one_amount) + " " + item_needed
	if second_item != "none":
		crafting_prompt_Text.text = "Craft " + type_of_item + "? \n It costs "+ str(item_one_amount) + " " + item_needed + " and " + str(item_two_amount) + " " + second_item
	crafting_prompt_Text.show()
	

func _on_opening_inventory():
	if is_inventory_open == false:
		is_inventory_open = true
		crafting_container.show()
		inventory_container.show()
	elif is_inventory_open == true:
		_on_close_inventory()
		
func _on_Ice_Button_pressed():
	if is_crafting == false && has_yes_been_pressed == false:
		is_crafting = true
		inventory_container.hide()
		_on_trying_to_craft_wall()
		pass
	if is_crafting == true && has_yes_been_pressed == false:
		is_trying_to_craft_fire = false
		is_trying_to_craft_repair = false
		_on_trying_to_craft_wall()
		pass
		

func _on_Fire_Button_pressed():
	if is_crafting == false && has_yes_been_pressed == false:
		is_crafting = true
		inventory_container.hide()
		_on_trying_to_craft_fire()
		pass
	if is_crafting == true && has_yes_been_pressed == false:
		is_trying_to_craft_repair = false
		is_trying_to_craft_wall = false
		_on_trying_to_craft_fire()
		pass

func _on_Repair_Button_pressed():
	if is_crafting == false && has_yes_been_pressed == false:
		is_crafting = true
		inventory_container.hide()
		_on_trying_to_craft_repair()
		pass
	if is_crafting == true && has_yes_been_pressed == false:
		is_trying_to_craft_fire = false
		is_trying_to_craft_wall = false
		_on_trying_to_craft_repair()
		pass


func _on_Yes_Craft_pressed():
	if is_yes_currently_pressed_for_crafting == false && has_yes_been_pressed == false:
		has_yes_been_pressed = true
		is_yes_currently_pressed_for_crafting = true
		yes_craft_button.hide()
		no_craft_button.hide()
		var log_missing = 3 - GlobalVariables.current_total_logs
		var ice_missing = 6 -GlobalVariables.current_total_ice
		var wire_missing = 6 - GlobalVariables.current_total_wire
		var pipe_missing = 2 - GlobalVariables.current_total_pipe
		if pipe_missing < 0:
			pipe_missing = 0
		if wire_missing < 0:
			wire_missing = 0
		
		if is_trying_to_craft_fire == true:
			is_trying_to_craft_fire = false
			if GlobalVariables.current_total_logs >= 3:
				crafting_prompt_Text.text = "\n Crafted a Fire Kit!"
				GlobalVariables.current_total_logs -= 3
				update_amounts()
				crafting_fire()
				crafting_promp_time.wait_time = 1.5
				crafting_promp_time.start()
				is_timer_running_for_crafting = true
			elif GlobalVariables.current_total_logs < 3:
				crafting_prompt_Text.text = "I need " + str(log_missing) + " more logs."
				crafting_promp_time.wait_time = 1.5
				crafting_promp_time.start()
				is_timer_running_for_crafting = true
			pass
		if is_trying_to_craft_repair == true:
			is_trying_to_craft_repair = false
			if GlobalVariables.current_total_pipe >= 2 && GlobalVariables.current_total_wire >= 6:
				crafting_prompt_Text.text = "\n Crafted a Repair Kit!"
				GlobalVariables.current_total_pipe -= 2
				GlobalVariables.current_total_wire -= 6
				update_amounts()
				crafting_repair()
				crafting_promp_time.wait_time = 1.5
				crafting_promp_time.start()
				is_timer_running_for_crafting = true
			elif GlobalVariables.current_total_pipe < 2 || GlobalVariables.current_total_wire < 6:
				crafting_prompt_Text.text = "I need " + str(pipe_missing) + " more pipes and " + str(wire_missing) + " wire."
				crafting_promp_time.wait_time = 1.5
				crafting_promp_time.start()
				is_timer_running_for_crafting = true
			pass
		if is_trying_to_craft_wall == true:
			is_trying_to_craft_wall = false
			if GlobalVariables.current_total_ice >= 6:
				crafting_prompt_Text.text = "\n Crafted a Ice Wall!"
				crafting_wall()
				GlobalVariables.current_total_ice -= 6
				update_amounts()
				crafting_promp_time.wait_time = 1.5
				crafting_promp_time.start()
				is_timer_running_for_crafting = true
			elif GlobalVariables.current_total_ice < 6:
				crafting_prompt_Text.text = "I need " + str(ice_missing) + " more ice bricks."
				crafting_promp_time.wait_time = 1.5
				crafting_promp_time.start()
				is_timer_running_for_crafting = true
			pass
	
func update_amounts():
	wire_amount_text.text = "Wires: " + str(GlobalVariables.current_total_wire)
	log_amount_text.text = "Logs: " + str(GlobalVariables.current_total_logs)
	pipe_amount_text.text = "Pipes: " + str(GlobalVariables.current_total_pipe)
	ice_amount_text.text = "Ice Blocks: " + str(GlobalVariables.current_total_ice)

func _on_close_inventory():
	crafting_promp_time.stop()
	inventory_container.hide()
	crafting_container.hide()
	crafting_prompt.hide()
	is_crafting = false
	is_trying_to_craft_fire = false
	is_trying_to_craft_repair = false
	is_trying_to_craft_wall = false
	is_inventory_open = false
	is_yes_currently_pressed_for_crafting = false
	is_timer_running_for_crafting = false
	has_yes_been_pressed = false
	
func _on_No_Craft_pressed():
	if is_timer_running_for_crafting == false:
		is_crafting = false
		crafting_prompt.hide()
		inventory_container.show()
		is_yes_currently_pressed_for_crafting = false


func _on_Crafting_Promp_Timer_timeout():
	is_crafting = false
	crafting_prompt.hide()
	is_yes_currently_pressed_for_crafting = false
	is_timer_running_for_crafting = false
	inventory_container.show()
	has_yes_been_pressed = false
	


func _on_close_inv_b_pressed():
	_on_close_inventory()
	


func _on_Bottom_Fire_Button_pressed():
	Signals.emit_signal("pressing_place_fire")
	pass # Replace with function body.


func _on_Bottom_Ice_Pick_Button_pressed():
	Signals.emit_signal("looking_for_ice_wall")
	if GlobalVariables.is_currently_next_to_icewall == false:
			Signals.emit_signal("ice_pick_not_near_wall")
	pass # Replace with function body.


func _on_Bottom_Repair_Button_pressed():
	Signals.emit_signal("pressing_use_repair")
	pass # Replace with function body.


func _on_Bottom_ice_Wall_Button_pressed():
	Signals.emit_signal("pressing_place_ice_wall")
	pass # Replace with function body.
