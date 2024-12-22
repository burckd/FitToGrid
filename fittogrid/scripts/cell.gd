extends Node2D

signal input_taken

@onready var color_rect = $ColorRect

func set_cell_color (state):
	if state == 0:
		color_rect.Color.WHITE_SMOKE
	elif state == 1:
		color_rect.Color.SLATE_GRAY
	elif state == 2:
		color_rect.Color.GOLD
	elif state == 3:
		color_rect.Color.RED

func _on_cell_area_input_event(viewport, event, shape_idx):
	input_taken.emit(viewport, event, shape_idx)
