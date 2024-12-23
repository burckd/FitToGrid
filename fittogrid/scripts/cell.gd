extends Node2D

signal input_taken

@onready var color_rect = $ColorRect

func _ready():
	set_cell_color(0)

func set_cell_color (state):
	if state == 0:
		color_rect.color = Color.WHITE_SMOKE
	elif state == 1:
		color_rect.color = Color.SLATE_GRAY
	elif state == 2:
		color_rect.color = Color.GOLD
	elif state == 3:
		color_rect.color = Color.RED

func _on_cell_area_input_event(viewport, event, shape_idx):
	input_taken.emit(viewport, event, shape_idx)
