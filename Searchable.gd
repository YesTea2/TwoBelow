extends Resource

class_name Searchable_Object

export var has_been_searched = false

export var contains_log = false
export var contains_ice = false
export var contains_wire = false
export var contains_repair = false

var has_wire = false
var has_pipe = false
export var log_amount = 0
export var pipe_amount = 0
export var ice_amount = 0
export var wire_amount = 0

var rand_generate_num = RandomNumberGenerator.new()


func _ready():
	if has_been_searched == false:
		if contains_log == true:
			choose_resource_amounts_log_ice("log")
			pass
		if contains_ice == true:
			choose_resource_amounts_log_ice("ice")
			pass

		if contains_repair == true:
			choose_repair_resource()
			pass


func choose_resource_amounts_log_ice(resource):
	if resource == "log":
		var amount = get_random_number(1, 2)
		log_amount = amount
		pass
	if resource == "ice":
		var amount = get_random_number(1, 3)
		ice_amount = amount
		pass
	
func choose_repair_resource():
	var choice = get_random_number(1,3)
	if choice == 1:
		var amount = get_random_number(1,3)
		has_wire = true
		wire_amount = amount
		pass
	if choice == 2:
		var amount = get_random_number(1,2)
		has_pipe = true
		pipe_amount = amount
		pass
	if choice == 3:
		var amount_one = get_random_number(1,3)
		var amount_two = get_random_number(1,2)
		has_wire = true
		has_pipe = true
		wire_amount = amount_one
		pipe_amount = amount_two
		pass


func get_random_number(min_range, max_range):
	rand_generate_num.randomize()
	var rand_int = rand_generate_num.randi_range(min_range,max_range)
	return rand_int
