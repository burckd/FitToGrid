extends Node2D

@export var grid_size := 10
@export var cell_scene: PackedScene 

var cell_size = Global.CELL_SIZE
var grid_offset = Global.GRID_OFFSET
var grid_top_offset = Global.GRID_TOP_OFFSET

var grid_status := {}
var cells := []

var highlighted_cells := []

var last_placed_piece: Node2D = null
var last_piece_cells: Array = []


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
			var cell_instance = cell_scene.instantiate()
			# position cell
			cell_instance.position = Vector2(x * cell_size + grid_offset, y * cell_size + grid_offset + grid_top_offset)
			# add cell to scene 
			add_child(cell_instance)
			# all cells are empty
			var pos = Vector2(x, y)
			grid_status[pos] = false
			#store cell reference
			cells[x].append(cell_instance)

func clear_grid():
	grid_status.clear()
	cells.clear()
	last_piece_cells.clear()

func validate_placement(piece: Node2D) -> bool:
	var shape_data = piece.shape_data
	var global_piece_pos = piece.global_position
	for point in shape_data:
		# For each cell in the piece shape, get the cell's world position
		var cell_world_pos = piece.global_position + point * cell_size
		var grid_pos = world_to_grid(cell_world_pos)
		# Check boundaries
		if grid_pos.x < 0 or grid_pos.x >= grid_size or grid_pos.y < 0 or grid_pos.y >= grid_size:
			return false
		# Check occupancy
		if grid_status.has(grid_pos) and grid_status[grid_pos]:
			return false
	return true

func snap_piece_to_grid(piece: Node2D):
	var shape_data = piece.shape_data
	var anchor = shape_data[0]
	var anchor_world_pos = piece.global_position + anchor * cell_size
	var grid_pos = world_to_grid(anchor_world_pos)
	var final_anchor_pixel_pos = grid_to_world(grid_pos)
	var delta = final_anchor_pixel_pos - anchor_world_pos
	piece.global_position += delta

func mark_cells_occupied(piece: Node2D):
	last_placed_piece = piece
	last_piece_cells.clear()
	var cells_to_mark = get_cells_for_piece(piece)
	for cell in cells_to_mark:
		var grid_pos = world_to_grid(cell.position)
		if grid_pos.x >= 0 and grid_pos.x < grid_size and grid_pos.y >= 0 and grid_pos.y < grid_size:
			grid_status[grid_pos] = true
			cell.set_state(1)
			cell.update_power(1)
			last_piece_cells.append(grid_pos)

func highlight_cells(piece: Node2D):
	clear_highlight()
	var is_valid = validate_placement(piece)
	var cells_to_highlight = get_cells_for_piece(piece)
	for cell in cells_to_highlight:
		cell.set_highlight(true, not is_valid)
		highlighted_cells.append(cell)

func get_cells_for_piece(piece: Node2D) -> Array:
	var cells_list = []
	for point in piece.shape_data:
		var grid_pos = world_to_grid(piece.global_position + point * cell_size)
		if grid_pos.x >= 0 and grid_pos.x < grid_size and grid_pos.y >= 0 and grid_pos.y < grid_size:
			cells_list.append(cells[grid_pos.x][grid_pos.y])
	return cells_list

func clear_highlight():
	if highlighted_cells.size() == 0:
		return
	for cell in highlighted_cells:
		cell.set_highlight(false, false)
	highlighted_cells.clear()

func world_to_grid(world_pos: Vector2) -> Vector2:
	return Vector2(
		int((world_pos.x - grid_offset) / cell_size),
		int((world_pos.y - grid_offset - grid_top_offset) / cell_size)
	)

func grid_to_world(grid_pos: Vector2) -> Vector2:
	return Vector2(
		grid_pos.x * cell_size + grid_offset,
		grid_pos.y * cell_size + grid_offset + grid_top_offset
	)

func check_and_clear_lines():
	var cleared_lines = []
	# Check rows
	for y in range(grid_size):
		var is_row_filled = true
		for x in range(grid_size):
			if not grid_status.get(Vector2(x, y), false):
				is_row_filled = false
				break
		if is_row_filled:
			cleared_lines.append(y)
	# Check columns
	for x in range(grid_size):
		var is_col_filled = true
		for y in range(grid_size):
			if not grid_status.get(Vector2(x, y), false):
				is_col_filled = false
				break
		if is_col_filled:
			cleared_lines.append(x + grid_size)  # Offset column indices to differentiate
	
	var cleared_line_power = update_cleared_line_power(cleared_lines)
	
	# Clear lines
	for line in cleared_lines:
		if line < grid_size:  # Row
			for x in range(grid_size):
				var grid_pos = Vector2(x, line)
				if not is_cell_from_last_piece(grid_pos):
					grid_status[grid_pos] = false
					
					cells[x][line].clear_cell_power()
					cells[x][line].set_state(0)
				else:
					cells[x][line].update_power(cleared_line_power)
		else:  # Column
			for y in range(grid_size):
				var grid_pos = Vector2(line - grid_size, y)
				if not is_cell_from_last_piece(grid_pos):
					grid_status[grid_pos] = false
					
					cells[line - grid_size][y].clear_cell_power()
					cells[line - grid_size][y].set_state(0)
				else:
					cells[line - grid_size][y].update_power(cleared_line_power)
	print("cell power is ", cleared_line_power)
	return cleared_lines

func is_cell_from_last_piece(grid_pos: Vector2) -> bool:
	return grid_pos in last_piece_cells

func validate_position_placement(piece_shape: Array, grid_pos: Vector2)-> bool:
	for point in piece_shape:
		var target_pos = grid_pos + point
		if target_pos.x < 0 or target_pos.x >= grid_size or target_pos.y < 0 or target_pos.y >= grid_size:
			return false
		if grid_status.has(target_pos) and grid_status[target_pos]:
			return false
	return true

func can_place_piece(piece_shape: Array) -> bool:
	for x in range(grid_size):
		for y in range(grid_size):
			if validate_position_placement(piece_shape, Vector2(x, y)):
				return true
	return false

func update_cleared_line_power(cleared_lines):
	var cleared_line_power = 0
	for line in cleared_lines:
		if line < grid_size:  # Row
			for x in range(grid_size):
				var grid_pos = Vector2(x, line)
				if not is_cell_from_last_piece(grid_pos):
					cleared_line_power += cells[x][line].power
		else:  # Column
			for y in range(grid_size):
				var grid_pos = Vector2(line - grid_size, y)
				if not is_cell_from_last_piece(grid_pos):
					cleared_line_power += cells[line - grid_size][y].power
	print("cleared line power is ", cleared_line_power)
	return cleared_line_power
