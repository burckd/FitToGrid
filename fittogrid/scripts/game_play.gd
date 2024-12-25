extends Node2D

@onready var grid_manager = $GridManager
@onready var spawn_manager = $SpawnManager

var active_piece
var active_pieces := []

enum GameState { PLAYING, GAME_OVER, PAUSE }
var current_state: GameState = GameState.PLAYING

func _ready():
	pass

func start_game():
	GameState.PLAYING
	spawn_manager.spawn_pieces()
	active_pieces = spawn_manager.first_active_pieces

func check_game_over():
	var can_place_any_piece = false
	for piece in active_pieces:
		if grid_manager.can_place_piece(piece.shape_data):
			return false
	GameState.GAME_OVER
	return true

func attempt_place_piece(piece: Node2D):
	var piece_number
	var is_valid = grid_manager.validate_placement(piece)
	piece_number = piece.piece_number
	if is_valid:
		grid_manager.snap_piece_to_grid(piece)
		grid_manager.mark_cells_occupied(piece)
		piece.queue_free()
		active_pieces.erase(piece)
		grid_manager.check_and_clear_lines()
		var new_piece = spawn_manager.spawn_desired_piece(piece_number)
		active_pieces.append(new_piece)
		check_game_over()
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
