extends Panel
class_name ControlPanel

func make_asserts():
	assert(get_progress_bar() != null)
	

# Called when the node enters the scene tree for the first time.
func _ready():
	make_asserts()
	$ButtonLess.connect("pressed", self, "_on_ButtonLess_pressed")
	$ButtonMore.connect("pressed", self, "_on_ButtonMore_pressed")
	var trw = $CenterContainer.rect_size.x
	var trh = $CenterContainer.rect_size.y
	var image = get_construction_sprite().texture.get_data()
	var hframes = get_construction_sprite().get_hframes()
	var vframes = get_construction_sprite().get_vframes()
	var w = image.get_width()
	var h = image.get_height()
	var new_w = w/hframes
	var new_h = h/vframes
	image = image.get_rect(Rect2(w-new_w, h-new_h, new_w, new_h))
	var frac = new_h/trh
	print(frac)
	image.resize(new_w/frac, new_h/frac)
	var itex = ImageTexture.new()
	itex.create_from_image(image)
	$CenterContainer/TextureRect.texture = itex

func _process(delta):
	update_progress_bar()
	update_buttons()
	update_text()
	
func update_buttons():
	var construction = get_construction()
	if (!construction.is_available or construction.is_finished()):
		$ButtonLess.disabled = true
		$ButtonMore.disabled = true
	elif (construction.num_workers <= 0):
		$ButtonLess.disabled = true
		$ButtonMore.disabled = false
	elif (construction.num_workers >= construction.workers_speed.size()):
		$ButtonMore.disabled = true
		$ButtonLess.disabled = false
	else:
		$ButtonLess.disabled = false
		$ButtonMore.disabled = false	
	
func update_progress_bar():
	var bar = get_progress_bar()
	if (get_parent().progress > 0 and get_parent().progress < 100):
		bar.show()
		bar.value = get_parent().progress
	else:
		bar.hide()

func get_progress_bar() -> ProgressBar:
	for x in get_children():
		if (x is ProgressBar):
			return x
	return null
	
func get_construction_sprite() -> ConstructionSprite:
	return get_construction().get_construction_sprite()
	
func get_construction() -> Construction:
	return get_parent() as Construction

func _on_ButtonLess_pressed():
	get_construction().remove_worker()
	update_text()
	
func _on_ButtonMore_pressed():
	get_construction().add_worker()
	update_text()
	
func update_text():
	$Label.text = str(get_construction().num_workers)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
