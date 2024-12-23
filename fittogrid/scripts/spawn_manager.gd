extends Node2D

var cell_size = Global.CELL_SIZE
var spawn_offset = Global.SPAWN_OFFSET

@onready var piece_data = $piece_data

const MAX_PIECE_HEIGHT = 3 
const PIECE_COUNT = 3

signal active_piece_information(piece)
signal hovered_piece_information(piece)

func _ready():
	randomize()
	spawn_pieces()

func spawn_pieces():
	var starting_y = spawn_offset.y # center of spawnable area
	var starting_x = spawn_offset.x # spawnable area x
	
	for i in range(PIECE_COUNT):
		var spawn_y = starting_y + i * (MAX_PIECE_HEIGHT + 1) * cell_size
		var spawn_x = starting_x
		spawn_single_piece(Vector2(spawn_x, spawn_y), i)

func spawn_desired_piece(number):
	var starting_y = spawn_offset.y # center of spawnable area
	var starting_x = spawn_offset.x # spawnable area x
	var n = number
	var spawn_y = starting_y + n * (MAX_PIECE_HEIGHT + 1) * cell_size
	var spawn_x = starting_x
	spawn_single_piece(Vector2(spawn_x, spawn_y), number)

func spawn_single_piece(position: Vector2, piece_number):
	# choose random piece and rotation
	var piece_types = piece_data.pieces.keys()
	var chosen_type = piece_types[randi_range(0, piece_types.size() - 1)]
	var rotations = piece_data.pieces[chosen_type]
	var chosen_piece_rotation_data = rotations[randi_range(0, rotations.size() - 1)]
	
	var game_play = "/root/Main/GameManager"  
	
	# instantiate piece and initiate it with shape
	var piece_instance = preload("res://scenes/piece.tscn").instantiate()
	piece_instance.init_shape(chosen_piece_rotation_data,cell_size)
	piece_instance.position = position
	add_child(piece_instance)
	piece_instance.piece_released.connect(_piece_information_give)
	piece_instance.piece_hovered.connect(_piece_hover_information_give)
	piece_instance.piece_number = piece_number

func _piece_information_give(piece):
	active_piece_information.emit(piece)

func _piece_hover_information_give(piece):
	hovered_piece_information.emit(piece)
