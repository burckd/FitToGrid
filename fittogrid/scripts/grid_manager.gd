extends Node2D


@export var grid_size := 10

var grid_status := {}
var cells := []
var cell_size = Global.CELL_SIZE

# Called when the node enters the scene tree for the first time.
func _ready():
	init_grid(grid_size, cell_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

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

func is_cell_occupied(x: int, y: int) -> bool:
	# check grid bounds
	if x < 0 or x >= grid_size or y < 0 or y >= grid_size:
		return true
	return grid_status[Vector2(x,y)]

func set_cell_occupancy(x: int, y: int, occupied: bool):
	if x < 0 or x >= grid_size or y < 0 or y >= grid_size:
		return
	grid_status[Vector2(x, y)] = occupied
	cells[x][y].set_filled(occupied)

func get_world_position_from_grid(x: int, y: int) -> Vector2:
	return Vector2(x * cell_size, y * cell_size)
