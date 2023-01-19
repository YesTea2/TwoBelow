extends Resource
class_name player_variables

signal doorway_entered
signal doorway_exited
signal using_door
signal pressing_use_wall
signal pressing_use_fire
signal pressing_use_repair
signal is_opening_inventory


var is_at_door = false
var is_waiting = false

export(PackedScene) var foot_step
export(PackedScene) var foot_step_side
export(PackedScene) var foot_step_idle
export(PackedScene) var snow_footstep_side
export(PackedScene) var snow_footstep


export var time_foot_outdoor = 0.5
export var time_foot_indoor = 1.0
export var speed = 200.0
export var is_inside = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
