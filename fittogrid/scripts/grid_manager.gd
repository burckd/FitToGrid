extends Node2D

@export var grid_size := 10

var grid_status := {}
var cells := []
var cell_size = Global.CELL_SIZE
var grid_offset = Global.GRID_OFFSET

var highlighted_cells = []

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
			cell_instance.position = Vector2(x * cell_size + grid_offset, y * cell_size + grid_offset)
			# add cell to scene 
			add_child(cell_instance)
			# all cells are empty
			var pos = Vector2(x, y)
			grid_status[pos] = false
			#store cell reference
			cells[x].append(cell_instance)

func validate_placement(piece: Node2D) -> bool:
	var shape_data = piece.shape_data
	var global_piece_pos = piece.global_position
	for point in shape_data:
		# For each cell in the piece shape, get the cell's world position
		var cell_world_x = global_piece_pos.x + (point.x * cell_size)
		var cell_world_y = global_piece_pos.y + (point.y * cell_size)
		# Convert that to grid coordinates
		var grid_x = int((cell_world_x - grid_offset) / cell_size)
		var grid_y = int((cell_world_y - grid_offset) / cell_size)
		# Check boundaries
		if grid_x < 0 or grid_x >= grid_size or grid_y < 0 or grid_y >= grid_size:
			return false
		# Check occupancy
		if grid_status.has(Vector2(grid_x, grid_y)):
			if grid_status[Vector2(grid_x, grid_y)] == true:
				return false
		else:
			return false
	return true

func snap_piece_to_grid(piece: Node2D):
	var shape_data = piece.shape_data
	var cell_size = Global.CELL_SIZE
	# For a lot of puzzle games, you pick an "anchor cell" in shape_data
	# (often the top-left or the first in the array).
	var anchor = shape_data[0]
	# anchor’s world position
	var anchor_world_x = piece.global_position.x + (anchor.x * cell_size)
	var anchor_world_y = piece.global_position.y + (anchor.y * cell_size)
	# convert anchor world to grid coords
	var grid_x = int((anchor_world_x - Global.GRID_OFFSET) / cell_size)
	var grid_y = int((anchor_world_y - Global.GRID_OFFSET) / cell_size)
	# Then figure out the pixel position that that grid cell corresponds to
	var final_anchor_pixel_x = grid_x * cell_size + Global.GRID_OFFSET
	var final_anchor_pixel_y = grid_y * cell_size + Global.GRID_OFFSET
	# The offset from the anchor to the piece’s top-left
	var delta = Vector2(final_anchor_pixel_x, final_anchor_pixel_y) - Vector2(anchor_world_x, anchor_world_y)
	# Now move the piece by delta
	piece.global_position += delta

func mark_cells_occupied(piece: Node2D):
	var shape_data = piece.shape_data
	var cell_size = Global.CELL_SIZE
	
	for point in shape_data:
		var cell_world_x = piece.global_position.x + (point.x * cell_size)
		var cell_world_y = piece.global_position.y + (point.y * cell_size)
		# Convert to grid coords
		var grid_x = int((cell_world_x - Global.GRID_OFFSET) / cell_size)
		var grid_y = int((cell_world_y - Global.GRID_OFFSET) / cell_size)
		var key = Vector2(grid_x, grid_y)
		grid_status[key] = true
		
		if cells[grid_x][grid_y]:
			cells[grid_x][grid_y].set_state(1)

func highlight_cells(piece: Node2D):
	clear_highlight()
	var shape_data = piece.shape_data
	var global_position = piece.global_position
	if validate_placement(piece) == true:
		for point in shape_data:
			# For each cell in the piece shape, get the cell's world position
			var cell_world_x = global_position.x + (point.x * cell_size)
			var cell_world_y = global_position.y + (point.y * cell_size)
			# Convert that to grid coordinates
			var grid_x = int((cell_world_x - grid_offset) / cell_size)
			var grid_y = int((cell_world_y - grid_offset) / cell_size)
			# Check boundaries
			if grid_x >= 0 and grid_x < grid_size and grid_y >= 0 and grid_y < grid_size:
				var cell = cells[grid_x][grid_y]
				if cell:
					if grid_status[Vector2(grid_x, grid_y)]:
						cell.set_highlight(true)
					else:
						cell.set_highlight(true)
					highlighted_cells.append(cell)

func clear_highlight():
	for cell in highlighted_cells:
		cell.set_highlight(false)
	highlighted_cells.clear()
