extends Node2D
class_name Construction, "res://assets/icons/construction.png"

export var workers_speed: PoolRealArray

var dependenciesToBeConstructed: Array
var dependenciesToBeVisible: Array
var progress = 0.0
var last_progress = 0.0
var num_workers = 0
var workers_current: Array
var is_available: bool
var Scene2D: Node2D

func make_asserts():
	assert(workers_speed.size() == workers_current.size())
	assert(get_construction_sprite() != null)

func init_scene():
	# Couldn't make $Scene2D nor $Node2D work
	# using inheritance instead
	Scene2D = get_parent().get_parent()

func init_workers():
	for child in get_children():
		if (child is Worker):
			workers_current.append(child)

func init_variables():
	init_scene()
	init_workers()

func _ready():
	init_variables()
	make_asserts()
	for sprite in workers_current:
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

func set_construction_sprite_frame(frame):
	get_construction_sprite().set_frame(frame)

func on_finished():
	Scene2D.num_workers_global -= num_workers
	num_workers = 0
	for worker in workers_current:
		worker.hide()
	Scene2D.update_phases_to_finish()

func is_finished() -> bool:
	return progress >= 100

func add_worker():
	if (num_workers < workers_current.size() and Scene2D.num_workers_global < Scene2D.MAX_SIMULTANEOUS_WORKERS):
		(workers_current[num_workers] as Worker).show()
		num_workers += 1
		Scene2D.num_workers_global += 1

func remove_worker():
	if (num_workers > 0):
		Scene2D.num_workers_global -= 1
		num_workers -= 1
		(workers_current[num_workers] as Worker).hide()
