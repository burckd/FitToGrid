extends Node2D

@onready var grid_manager = $GridManager
@onready var spawn_manager = $SpawnManager

var active_piece

func _ready():
	pass # Replace with function body.

func _on_spawn_manager_active_piece_information(piece):
	active_piece = piece
