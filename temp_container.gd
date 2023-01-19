extends Node


var current_ice = 0
var current_wire = 0
var current_pipe = 0
var current_log = 0


var contains_log = false
var contains_ice = false
var contains_repair = false

var has_wire = false
var has_pipe = false

var has_been_searched = false


func clear_the_searchable():
	current_ice = 0
	current_wire = 0
	current_pipe = 0
	current_log = 0
	contains_log = false
	contains_ice = false
	contains_repair = false
	has_wire = false
	has_pipe = false
	has_been_searched = false
	pass
