extends Node2D

var screen_size
var screen_size_offset := Vector2(126, 126)
var shape_data := []
var cells := []

var is_dragging := false
var drag_offset : Vector2
var start_position : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	start_position = global_position
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = global_position.clamp(Vector2.ZERO, (screen_size - screen_size_offset))

# called in spawner
func init_shape(shape: Array, cell_size: int):
	shape_data = shape
	
	for point in shape_data:
		var cell = preload("res://scenes/cell.tscn").instantiate()
		add_child(cell)
		cells.append(cell)
		cell.position = Vector2(point.x * cell_size, point.y * cell_size)
	for cell in cells:
		cell.input_taken.connect(_on_cell_input_event)

func _on_cell_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			start_dragging(event.position)
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			stop_dragging()
			return_spawn_pos()
	elif event is InputEventMouseMotion and is_dragging:
		snap_to_mouse()

func start_dragging(mouse_pos: Vector2):
	is_dragging = true
	drag_offset = mouse_pos - global_position
	snap_to_mouse()

func snap_to_mouse():
	global_position = get_global_mouse_position() - drag_offset

func stop_dragging():
	is_dragging = false

func return_spawn_pos():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", start_position, 0.2).set_trans(Tween.TRANS_SINE)
