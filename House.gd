extends Node2D
class_name House

#func _process(delta):

func _ready():
	$BuildFloor1.dependencies = []
	$BuildFloor2.dependencies = [$BuildFloor1]
	$PaintFloor1.dependencies = [$BuildFloor1]
	$PaintFloor2.dependencies = [$BuildFloor2]
	#$BuildRoof.dependencies = [$BuildFloor2]
	
func _process(delta):
	for child in get_children():
		if (child is Construction):
			if (dependencies_have_been_finished(child)):
				child.is_available = true
			else:
				child.is_available = false

func dependencies_have_been_finished(c: Construction):
	var result = true
	for d in c.dependencies:
		if (!d.is_finished()):
			result = false
	return result
