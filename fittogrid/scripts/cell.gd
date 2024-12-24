extends Node2D

signal input_taken

@export var default_color := Color("white_smoke")   # Empty cells
@export var occupied_color := Color("slate_gray")  # Occupied cells
@export var highlight_color := Color("gold")       # Highlight for placement
@export var invalid_color := Color("red")          # Invalid placement highlight

@onready var color_rect = $ColorRect

var state = 0  # 0 = empty, 1 = occupied
var is_highlighted = false
var is_invalid = false

func _ready():
	update_color()

func update_color():
	if is_highlighted:
		if is_invalid:
			color_rect.color = invalid_color
		else:
			color_rect.color = highlight_color
	else:
		color_rect.color = default_color if state == 0 else occupied_color

func set_state(new_state: int):
	state = new_state
	update_color()

func set_highlight(highlight: bool, invalid: bool = false):
	is_highlighted = highlight
	is_invalid = invalid
	update_color()

func _on_cell_area_input_event(viewport, event, shape_idx):
	input_taken.emit(viewport, event, shape_idx)
