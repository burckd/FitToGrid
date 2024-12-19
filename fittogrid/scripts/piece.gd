extends Node2D

var shape_data := []
var cells := []
var is_dragging : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# called in spawner
func init_shape(shape: Array, cell_size: int):
	shape_data = shape
	
	for point in shape_data:
		var cell = preload("res://scenes/cell.tscn").instantiate()
		add_child(cell)
		cells.append(cell)
		cell.position = Vector2(point.x * cell_size, point.y * cell_size)
	for cell in cells:
		cell.connect("input_event", self, "_on_cell_input_event")

func _on_cell_input_event(viewport, event, shape_idx):
	print("test")
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			start_dragging(event.position)
		elif event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			stop_dragging(event.position)
		elif event is InputEventMouseButton and is_dragging:
			drag_piece(event.relative)

func start_dragging(mouse_pos: Vector2):
	var drag_offset
	is_dragging = true
	drag_offset = mouse_pos - global_position

func drag_piece(relative_motion: Vector2):
	global_position += relative_motion

func stop_dragging(mouse_pos: Vector2):
	is_dragging = false
