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
	var can_move = true
	var coord = world_to_map(grid_object.get_cellv_test_pos())
	print("cellv coord: ", coord)
	
	# Check if out-of-bounds
	if     (direction == utl.DIR_W and (coord.x - 1) < 0) \
		or (direction == utl.DIR_N and (coord.y - 1) < 0) \
		or (direction == utl.DIR_E and (coord.x + grid_object.width) >= utl.TILES_PER_SIDE) \
		or (direction == utl.DIR_S and (coord.y + grid_object.height) >= utl.TILES_PER_SIDE):
			can_move = false
	else:
		# Check if can move in-bounds
		match(direction):
			utl.DIR_N:
				for i in range(grid_object.width):
					print("check: ", coord.x + i, ", ", coord.y - 1)
					if tilemap.get_cell(coord.x + i, coord.y - 1) != utl.GRID_NONE:
						can_move = false
			utl.DIR_E:
				for i in range(grid_object.height):
					print("check: ", coord.x + grid_object.width, ", ", coord.y + i )
					if tilemap.get_cell(coord.x + grid_object.width, coord.y + i) != utl.GRID_NONE:
						can_move = false
			utl.DIR_S:
				for i in range(grid_object.width):
					print("check: ", coord.x + i, ", ", coord.y + grid_object.height)
					if tilemap.get_cell(coord.x + i, coord.y + grid_object.height) != utl.GRID_NONE:
						can_move = false
			utl.DIR_W:
				for i in range(grid_object.height):
					print("check: ", coord.x - 1, ", ", coord.y + i)
					if tilemap.get_cell(coord.x - 1, coord.y + i) != utl.GRID_NONE:
						can_move = false
	print("CAN MOVE? ", can_move)

	# Return the new position if can_move
	var new_coord = coord + utl.dir_offset(direction)
	if can_move:
	    return map_to_world(new_coord)
	else:
	    return map_to_world(coord)




