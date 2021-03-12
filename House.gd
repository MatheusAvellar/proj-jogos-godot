extends Node2D
class_name House

#func _process(delta):

func _ready():
	set_construction_dependencies()
	for child in get_children():
		if (child is Construction):
			set_construction_visibility_and_availability(child)
	
func set_construction_dependencies():
	$BuildFloor1.dependenciesToBeVisible = []
	$BuildFloor1.dependenciesToBeConstructed = []
	
	$BuildFloor2.dependenciesToBeVisible = []
	$BuildFloor2.dependenciesToBeConstructed = [$BuildFloor1]
	
	$PaintFloor1.dependenciesToBeVisible = [$BuildFloor1]
	$PaintFloor1.dependenciesToBeConstructed = []
	
	$PaintFloor2.dependenciesToBeVisible = [$BuildFloor2]
	$PaintFloor2.dependenciesToBeConstructed = [$BuildFloor1]
	
	
#func _process(delta):
#	for child in get_children():
#		if (child is Construction):
#			if (dependencies_have_been_finished(child.dependenciesToBeConstructed)):
#				child.is_available = true
#			else:
#				child.is_available = false

#func construction_has_finished():
func _process(delta):
	for child in get_children():
		if (child is Construction):
			set_construction_visibility_and_availability(child)

func set_construction_visibility_and_availability(c: Construction):
	if (dependencies_have_been_finished(c.dependenciesToBeVisible)):
		c.show()
		if (dependencies_have_been_finished(c.dependenciesToBeConstructed)):
			c.is_available = true
		else:
			c.is_available = false
	else:
		c.hide()
		c.is_available = false
	
func dependencies_have_been_finished(dependencies: Array):
	var result = true
	for d in dependencies:
		if (!d.is_finished()):
			result = false
	return result
