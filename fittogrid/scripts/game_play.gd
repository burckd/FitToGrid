extends Node2D

@onready var grid_manager = $GridManager
@onready var spawn_manager = $SpawnManager

var active_piece

func _ready():
	pass # Replace with function body.

func attempt_place_piece(piece: Node2D):
	var piece_number
	var is_valid = grid_manager.validate_placement(piece)
	piece_number = piece.piece_number
	if is_valid:
		grid_manager.snap_piece_to_grid(piece)
		grid_manager.mark_cells_occupied(piece)
		piece.queue_free()
		spawn_manager.spawn_desired_piece(piece_number)
		
	else:
		piece.return_spawn_pos()

func _on_spawn_manager_active_piece_information(piece):
	active_piece = piece
	attempt_place_piece(piece)

func _on_spawn_manager_hovered_piece_information(piece):
	if piece == null:
		grid_manager.clear_highlight()
	else:
		grid_manager.highlight_cells(piece)
