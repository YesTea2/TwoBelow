extends TextureProgress


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_percent_value_int(100)
	

func set_percent_value_int(values):
	value = values

func lower_value(amount):
	value -= amount
	
func raise_value(amount):
	value += amount
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Outside_lower_temp_fast():
	lower_value(5)


func _on_Outside_lower_temp_slow():
	lower_value(2)


func _on_Outside_raise_temp_fast():
	raise_value(5)


func _on_Outside_raise_temp_slow():
	raise_value(1)
