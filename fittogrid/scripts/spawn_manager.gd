extends Node2D

@export var piece_scene: PackedScene 

var cell_size = Global.CELL_SIZE
var spawn_offset = Global.SPAWN_OFFSET

@onready var piece_data = $piece_data

const MAX_PIECE_HEIGHT = 3 
const PIECE_COUNT = 3

signal active_piece_information(piece)
signal hovered_piece_information(piece)

var first_active_pieces := []

func _ready():
	randomize()

func spawn_pieces():
	var starting_y = spawn_offset.y # center of spawnable area
	var starting_x = spawn_offset.x # spawnable area x
	
	for i in range(PIECE_COUNT):
		var spawn_y = starting_y + i * (MAX_PIECE_HEIGHT + 1) * cell_size
		var spawn_x = starting_x
		var piece = spawn_single_piece(Vector2(spawn_x, spawn_y), i)
		first_active_pieces.append(piece)

func spawn_desired_piece(number) -> Node2D:
	var starting_y = spawn_offset.y # center of spawnable area
	var starting_x = spawn_offset.x # spawnable area x
	var n = number
	var spawn_y = starting_y + n * (MAX_PIECE_HEIGHT + 1) * cell_size
	var spawn_x = starting_x
	return spawn_single_piece(Vector2(spawn_x, spawn_y), number)

func spawn_single_piece(position: Vector2, piece_number) -> Node2D:
	# choose random piece and rotation
	var piece_types = piece_data.pieces.keys()
	var chosen_type = piece_types[randi_range(0, piece_types.size() - 1)]
	var rotations = piece_data.pieces[chosen_type]
	var chosen_piece_rotation_data = rotations[randi_range(0, rotations.size() - 1)]
	
	# instantiate piece and initiate it with shape
	var piece_instance = piece_scene.instantiate()
	piece_instance.init_shape(chosen_piece_rotation_data,cell_size)
	piece_instance.position = position
	add_child(piece_instance)
	piece_instance.piece_released.connect(_piece_information_give)
	piece_instance.piece_hovered.connect(_piece_hover_information_give)
	piece_instance.piece_number = piece_number
	
	return piece_instance

func _piece_information_give(piece):
	active_piece_information.emit(piece)

func _piece_hover_information_give(piece):
	hovered_piece_information.emit(piece)
