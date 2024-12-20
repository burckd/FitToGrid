extends Node2D

var cell_size = Global.CELL_SIZE
@onready var piece_data = $piece_data

const MAX_PIECE_HEIGHT = 3 
const PIECE_COUNT = 3

func _ready():
	randomize()
	spawn_pieces()


func spawn_pieces():
	var starting_y = 0 # center of spawnable area
	
	for i in range(PIECE_COUNT):
		var spawn_y = starting_y + i * (MAX_PIECE_HEIGHT + 1) * cell_size
		spawn_single_piece(Vector2(0, spawn_y))

func spawn_single_piece(position: Vector2):
	
	# choose random piece and rotation
	var piece_types = piece_data.pieces.keys()
	var chosen_type = piece_types[randi_range(0, piece_types.size() - 1)]
	var rotations = piece_data.pieces[chosen_type]
	var chosen_piece_rotation_data = rotations[randi_range(0, rotations.size() - 1)]
	
	# instantiate piece and initiate it with shape
	var piece_instance = preload("res://scenes/piece.tscn").instantiate()
	piece_instance.init_shape(chosen_piece_rotation_data,cell_size)
	piece_instance.position = position
	add_child(piece_instance)
