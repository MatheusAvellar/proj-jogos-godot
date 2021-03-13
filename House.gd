extends Node2D
class_name House

#func _process(delta):

func _ready():
	set_construction_dependencies()
	for child in get_children():
		if (child is Construction):
			set_construction_visibility_and_availability(child)
	
func reset_constructions():
	for child in get_children():
		if (child is Construction):
			child.progress = 0
			child.set_construction_sprite_frame(0)
	_ready()

func set_construction_dependencies():
	$BuildFloor1.dependenciesToBeVisible = []
	$BuildFloor1.dependenciesToBeConstructed = []
	
	$BuildDoor.dependenciesToBeVisible = [$BuildFloor1]
	$BuildDoor.dependenciesToBeConstructed = [$BuildFloor1]
	
	$BuildFloor2.dependenciesToBeVisible = []
	$BuildFloor2.dependenciesToBeConstructed = [$BuildFloor1]
	
	$BuildWindow.dependenciesToBeVisible = [$BuildFloor2]
	$BuildWindow.dependenciesToBeConstructed = [$BuildFloor2]
	
	$PaintFloor1.dependenciesToBeVisible = [$BuildFloor1]
	$PaintFloor1.dependenciesToBeConstructed = []
	
	$PaintFloor2.dependenciesToBeVisible = [$BuildFloor2]
	$PaintFloor2.dependenciesToBeConstructed = [$BuildFloor1]

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
