extends Area2D


export (Resource) var search_var
# search_var = load("res://searchables//searchable.gd).instance()
# next_level = load("res://" + next_level_name + ".tscn").instance()
var rand_generate_num = RandomNumberGenerator.new()

func _ready():
	pass

func on_seach_area():
	if search_var.has_been_searched == false:
		search_var.has_been_searched = true
		give_item()
		
func give_item():
	if search_var.contains_log == true:
		var amount = search_var.log_amount
		Signals.emit_signal("on_give_item","log", amount)
		# emit_signal("go_to_next_text", null, null, null, null)
		pass
	if search_var.contains_ice == true:
		var amount = search_var.ice_amount
		Signals.emit_signal("on_give_item","ice", amount)
		pass
	if search_var.has_pipe == true:
		var amount = search_var.pipe_amount
		Signals.emit_signal("on_give_item","pipe", amount)
		pass
	if search_var.has_wire == true:
		var amount = search_var.wire_amount
		Signals.emit_signal("on_give_item","wire", amount)
		pass

