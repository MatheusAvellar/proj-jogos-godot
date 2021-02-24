extends Node2D
class_name Construction, "res://assets/icons/construction.png"

export var workers_speed: PoolIntArray
export var dependencies: Array

var progress = 0.0
var last_progress = 0.0
var num_workers = 0
var is_available: bool

func make_asserts():
	assert(workers_speed.size() == get_workers().size())
	assert(get_construction_sprite() != null)

func _ready():
	make_asserts()
	for sprite in get_workers():
		(sprite as Worker).play()
		(sprite as Worker).hide()

func _process(delta):
	last_progress = progress
	if (num_workers != 0 and !is_finished()):
		progress += delta*workers_speed[num_workers-1]
	if (last_progress != progress):
		update_frame()
	
func get_thumbnail():
	return get_construction_sprite().texture
	
func update_frame():
	var hframes = get_construction_sprite().get_hframes()
	var vframes = get_construction_sprite().get_vframes()
	var num_sprites = vframes * hframes
	var frame: int
	if (progress <= 0):
		frame = 0
	elif (progress >= 100):
		frame = num_sprites-1
		on_finished()
	else:
		frame = floor((num_sprites-2)*progress/100) + 1
	get_construction_sprite().set_frame(frame)
	
func get_construction_sprite() -> ConstructionSprite:
	for x in get_children():
		if (x is ConstructionSprite):
			return x
	return null

func get_workers() -> Array:
	var result = Array()
	for x in get_children():
		if (x is Worker):
			result.append(x)
	return result

func on_finished():
	num_workers = 0
	for worker in get_workers():
		worker.hide()

func is_finished() -> bool:
	return progress >= 100

func add_worker():
	if (num_workers < get_workers().size()):
		num_workers += 1
		(get_workers()[num_workers-1] as Worker).show()

func remove_worker():
	if (num_workers > 0):
		num_workers -= 1
		(get_workers()[num_workers] as Worker).hide()
