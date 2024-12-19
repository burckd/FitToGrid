extends Node2D

var screen_size

var shape_data := []
var cells := []

var is_dragging : bool
var drag_offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.clamp(Vector2.ZERO, screen_size)

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
	elif event is InputEventMouseMotion and is_dragging:
		drag_piece(event.relative)

func start_dragging(mouse_pos: Vector2):
	print("testo")
	is_dragging = true
	drag_offset = mouse_pos - global_position

func drag_piece(relative_motion: Vector2):
	position += relative_motion

func stop_dragging():
	is_dragging = false
	
