extends Node2D


@export var grid_size := 10

var grid_status := {}
var cells := []
var cell_size = Global.CELL_SIZE

# Called when the node enters the scene tree for the first time.
func _ready():
	init_grid(grid_size, cell_size)

func init_grid(grid_size: int, cell_size: int):
	# 2d array for cells 
	# list of lists
	cells.resize(grid_size)
	for x in range(grid_size):
		cells[x] = []
	
	# get cells from project and position them while filling cells and grid_status
	for x in range(grid_size):
		for y in range(grid_size):
			# load cells
			var cell_instance = preload("res://scenes/cell.tscn").instantiate()
			# position cell
			cell_instance.position = Vector2(x * cell_size, y * cell_size)
			# add cell to scene 
			add_child(cell_instance)
			# all cells are empty
			var pos = Vector2(x, y)
			grid_status[pos] = false
			#store cell reference
			cells[x].append(cell_instance)
