extends Node2D

onready var tilemap = get_node("TileMap")

var ready = false

func _ready():
	ready = true

func get_grid_rect():
	var side_length = tilemap.cell_size.x * utl.TILES_PER_SIDE
	var rect = Rect2(position, Vector2(side_length, side_length))
	return(rect)

func register_grid_object(grid_object):
	if not ready:
		yield(get_tree(), "idle_frame")

	grid_object.grid = self
	grid_object.cellv = world_to_map(grid_object.position)
	grid_object.position = map_to_world(grid_object.cellv)

func world_to_map(pos):
	var result = tilemap.world_to_map(pos)
	return(result)

func map_to_world(cellv):
	var result = tilemap.map_to_world(cellv)
	return(result)

func request_move(grid_object, direction):
	# Moves a grid_object
	# Returns direction moved
	var dir_to_move = direction
	var coord = world_to_map(grid_object.get_cellv_test_pos())
	
	# Check if out-of-bounds
	if     (direction == utl.DIR_W and (coord.x - 1) < 0) \
		or (direction == utl.DIR_N and (coord.y - 1) < 0) \
		or (direction == utl.DIR_E and (coord.x + grid_object.width) >= utl.TILES_PER_SIDE) \
		or (direction == utl.DIR_S and (coord.y + grid_object.height) >= utl.TILES_PER_SIDE):
			dir_to_move = utl.DIR_NONE
		#TODO: check diagonals...
	else:
		# Check if can move in-bounds
		dir_to_move = _check_obj_can_move_dir(grid_object, direction)

	var new_coord = coord + utl.dir_to_offset(dir_to_move)
	grid_object.position = map_to_world(new_coord)
	return(dir_to_move)

func _check_obj_can_move_cardinal_dir(start_coord, grid_object, direction):
	var can_move = true
	
	match(direction):
		utl.DIR_N:
			for i in range(grid_object.width):
				print("check: ", start_coord.x + i, ", ", start_coord.y - 1)
				if tilemap.get_cell(start_coord.x + i, start_coord.y - 1) != utl.GRID_NONE:
					can_move = false
		utl.DIR_E:
			for i in range(grid_object.height):
				print("check: ", start_coord.x + grid_object.width, ", ", start_coord.y + i )
				if tilemap.get_cell(start_coord.x + grid_object.width, start_coord.y + i) != utl.GRID_NONE:
					can_move = false
		utl.DIR_S:
			for i in range(grid_object.width):
				print("check: ", start_coord.x + i, ", ", start_coord.y + grid_object.height)
				if tilemap.get_cell(start_coord.x + i, start_coord.y + grid_object.height) != utl.GRID_NONE:
					can_move = false
		utl.DIR_W:
			for i in range(grid_object.height):
				print("check: ", start_coord.x - 1, ", ", start_coord.y + i)
				if tilemap.get_cell(start_coord.x - 1, start_coord.y + i) != utl.GRID_NONE:
					can_move = false
	return(can_move)

func _check_obj_can_move_diag_dir(start_coord, grid_object, direction):
	var can_move = true
	
	match(direction):
		utl.DIR_NE:
			for i in range(grid_object.width):
				print("check: ", start_coord.x + i, ", ", start_coord.y - 1)
				if tilemap.get_cell(start_coord.x + i, start_coord.y - 1) != utl.GRID_NONE:
					can_move = false
			for i in range(grid_object.height):
				print("check: ", start_coord.x + grid_object.width, ", ", start_coord.y + i )
				if tilemap.get_cell(start_coord.x + grid_object.width, start_coord.y + i) != utl.GRID_NONE:
					can_move = false
			if tilemap.get_cell(start_coord.x + grid_object.width, start_coord.y -1) != utl.GRID_NONE:
				can_move = false
		utl.DIR_NW:
			for i in range(grid_object.width):
				print("check: ", start_coord.x + i, ", ", start_coord.y - 1)
				if tilemap.get_cell(start_coord.x + i, start_coord.y - 1) != utl.GRID_NONE:
					can_move = false
			for i in range(grid_object.height):
				print("check: ", start_coord.x - 1, ", ", start_coord.y + i)
				if tilemap.get_cell(start_coord.x - 1, start_coord.y + i) != utl.GRID_NONE:
					can_move = false
			if tilemap.get_cell(start_coord.x - 1, start_coord.y -1) != utl.GRID_NONE:
				can_move = false
		utl.DIR_SW:
			for i in range(grid_object.width):
				print("check: ", start_coord.x + i, ", ", start_coord.y + grid_object.height)
				if tilemap.get_cell(start_coord.x + i, start_coord.y + grid_object.height) != utl.GRID_NONE:
					can_move = false
			for i in range(grid_object.height):
				print("check: ", start_coord.x - 1, ", ", start_coord.y + i)
				if tilemap.get_cell(start_coord.x - 1, start_coord.y + i) != utl.GRID_NONE:
					can_move = false
			if tilemap.get_cell(start_coord.x - 1, start_coord.y + grid_object.height) != utl.GRID_NONE:
				can_move = false
		utl.DIR_SE:
			for i in range(grid_object.width):
				print("check: ", start_coord.x + i, ", ", start_coord.y + grid_object.height)
				if tilemap.get_cell(start_coord.x + i, start_coord.y + grid_object.height) != utl.GRID_NONE:
					can_move = false
			for i in range(grid_object.height):
				print("check: ", start_coord.x + grid_object.width, ", ", start_coord.y + i )
				if tilemap.get_cell(start_coord.x + grid_object.width, start_coord.y + i) != utl.GRID_NONE:
					can_move = false
			if tilemap.get_cell(start_coord.x + grid_object.width, start_coord.y + grid_object.height) != utl.GRID_NONE:
				can_move = false
	return(can_move)

func _check_obj_can_move_dir(grid_object, dir):
	var start_coord = world_to_map(grid_object.get_cellv_test_pos())
	var dir_to_move = utl.DIR_NONE
	var cardinal_lookup_bounds = {
		# direction:          col_min,               col_max,            row_min,                row_max
		utl.DIR_N: [                0, grid_object.width - 1,                 -1,                     -1 ],
		utl.DIR_E: [grid_object.width,     grid_object.width,                  0, grid_object.height - 1 ],
		utl.DIR_S: [                0, grid_object.width - 1, grid_object.height,     grid_object.height ],
		utl.DIR_W: [               -1,                    -1,                  0, grid_object.height - 1 ],
		}
	var diagonal_lookup_dirs = {
		utl.DIR_NE: [utl.DIR_N, utl.DIR_E],
		utl.DIR_NW: [utl.DIR_N, utl.DIR_W],
		utl.DIR_SW: [utl.DIR_S, utl.DIR_W],
		utl.DIR_SE: [utl.DIR_S, utl.DIR_E],
		}
	var diagonal_lookup_corners = {
		utl.DIR_NE: Vector2(grid_object.width, -1),
		utl.DIR_NW: Vector2(-1, -1),
		utl.DIR_SW: Vector2(-1, grid_object.height),
		utl.DIR_SE: Vector2(grid_object.width, grid_object.height),
		}
	if dir in cardinal_lookup_bounds:
		print(utl.DIRECTION.keys()[dir])
		if _check_can_move_section(start_coord, cardinal_lookup_bounds[dir]):
			dir_to_move = dir
	elif dir in diagonal_lookup_dirs:
		var d0 = diagonal_lookup_dirs[dir][0]
		var d1 = diagonal_lookup_dirs[dir][1]
		print(utl.DIRECTION.keys()[d0])
		var can_move_0 = _check_can_move_section(start_coord, cardinal_lookup_bounds[d0])
		print(utl.DIRECTION.keys()[d1])
		var can_move_1 = _check_can_move_section(start_coord, cardinal_lookup_bounds[d1])
		var corner = diagonal_lookup_corners[dir]
		print("check: ", start_coord + corner)
		var can_move_corner = tilemap.get_cell(start_coord.x + corner.x, start_coord.y + corner.y) == utl.GRID_NONE
		if can_move_0 and can_move_1 and can_move_corner:
			dir_to_move = dir
		elif can_move_0 and (not can_move_1):
			dir_to_move = d0
		elif can_move_1 and (not can_move_0):
			dir_to_move = d1
	return(dir_to_move)

func _check_can_move_section(start, params):
	var can_move = true
	var coord = Vector2(params[0], params[2])
	while coord.x <= params[1]:
		while coord.y <= params[3]:
			print("check: ", params, " ", coord + start)
			if tilemap.get_cell(start.x + coord.x, start.y + coord.y) != utl.GRID_NONE:
				can_move = false
			coord.y += 1
		coord.y = params[2]
		coord.x += 1
	return can_move
