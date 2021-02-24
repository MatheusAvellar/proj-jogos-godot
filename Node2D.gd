extends Node2D
class_name Scene2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(int) var num_workers_global = 0
export(int) var MAX_SIMULTANEOUS_WORKERS = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Button_pressed():
	var a
	if a is Construction:
		a.add_worker()
		
