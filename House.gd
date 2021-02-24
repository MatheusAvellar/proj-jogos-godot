extends Node2D
class_name House

#func _process(delta):

func _ready():
	$FirstFloor.is_available = true
	$SecondFloor.is_available = false
	
func _process(delta):
	if ($SecondFloor.is_available == false and $FirstFloor.is_finished()):
		$SecondFloor.is_available = true
