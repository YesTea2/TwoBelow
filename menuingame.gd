extends CanvasLayer


func _ready():
	print("running")
	GlobalVariables.is_sub_menu_open = true
	Signals.connect("closing_sub_menu", self, "_on_Resume_Button_pressed")


func _on_Options_Button_pressed():
	MusicController.play_button("down")
	var optionssub = load("res://ingame_options.tscn").instance()
	get_tree().current_scene.add_child(optionssub)
	pass # Replace with function body.


func _on_Options_Button_mouse_entered():
	MusicController.play_button("highlight")
	pass # Replace with function body.


func _on_Resume_Button_pressed():
	GlobalVariables.is_sub_menu_open = false
	MusicController.play_button("down")
	queue_free()
	pass # Replace with function body.


func _on_Resume_Button_mouse_entered():
	MusicController.play_button("highlight")
	pass # Replace with function body.


func _on_Exit_Button_pressed():
	print("attemping")
	MusicController.play_button("down")
	var menu = load("res://Menu.tscn").instance()
	pass # Replace with function body.


func _on_Exit_Button_mouse_entered():
	MusicController.play_button("highlight")
	pass # Replace with function body.
