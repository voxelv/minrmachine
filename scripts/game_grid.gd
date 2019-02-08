extends Node2D

onready var tilemap:TileMap = get_node("TileMap") as TileMap

var grid_entities = []
var ready = false

func _ready():
	ready = true

func remove_at(coord:Vector2):
	var tile:int = tilemap.get_cellv(coord)
	tilemap.set_cellv(coord, utl.GRID.NONE)

func get_grid_rect():
	var side_length = tilemap.cell_size.x * utl.TILES_PER_SIDE
	var rect = Rect2(position, Vector2(side_length, side_length))
	return(rect)

func register_grid_entity(grid_entity):
	if not ready:
		yield(get_tree(), "idle_frame")

	grid_entity.grid = self
	grid_entity.position = map_to_world(world_to_map(grid_entity.position))
	grid_entities.append(grid_entity)

func world_to_map(pos):
	var result = tilemap.world_to_map(pos)
	return(result)

func map_to_world(cellv):
	var result = tilemap.map_to_world(cellv)
	return(result)

func request_move(grid_entity, direction):
	# Moves a grid_entity
	# Returns direction moved
	var dir_to_move = direction
	var coord = world_to_map(grid_entity.get_cellv_test_pos())
	
	# Check if out-of-bounds
	var oob_n = (coord.y - 1) < 0
	var oob_e = (coord.x + grid_entity.width) >= utl.TILES_PER_SIDE
	var oob_s = (coord.y + grid_entity.height) >= utl.TILES_PER_SIDE
	var oob_w = (coord.x - 1) < 0
	if     (direction == utl.DIRECTION.N and oob_n) \
		or (direction == utl.DIRECTION.E and oob_e) \
		or (direction == utl.DIRECTION.S and oob_s) \
		or (direction == utl.DIRECTION.W and oob_w) \
		or (direction == utl.DIRECTION.NE and (oob_n or oob_e)) \
		or (direction == utl.DIRECTION.NW and (oob_n or oob_w)) \
		or (direction == utl.DIRECTION.SW and (oob_s or oob_w)) \
		or (direction == utl.DIRECTION.SE and (oob_s or oob_e)):
			dir_to_move = utl.DIRECTION.NONE
	else:
		# Check if can move in-bounds
		dir_to_move = _check_obj_can_move_dir(grid_entity, direction)

	var new_coord = coord + utl.dir_to_offset(dir_to_move)
	grid_entity.position = map_to_world(new_coord)
	return(dir_to_move)

func _check_obj_can_move_dir(grid_entity, dir):
	var start_coord = world_to_map(grid_entity.get_cellv_test_pos())
	var dir_to_move = utl.DIRECTION.NONE
	var cardinal_lookup_bounds = {
		# direction:          col_min,               col_max,            row_min,                row_max
		utl.DIRECTION.N: [                0, grid_entity.width - 1,                 -1,                     -1 ],
		utl.DIRECTION.E: [grid_entity.width,     grid_entity.width,                  0, grid_entity.height - 1 ],
		utl.DIRECTION.S: [                0, grid_entity.width - 1, grid_entity.height,     grid_entity.height ],
		utl.DIRECTION.W: [               -1,                    -1,                  0, grid_entity.height - 1 ],
		}
	var diagonal_lookup_dirs = {
		utl.DIRECTION.NE: [utl.DIRECTION.N, utl.DIRECTION.E],
		utl.DIRECTION.NW: [utl.DIRECTION.N, utl.DIRECTION.W],
		utl.DIRECTION.SW: [utl.DIRECTION.S, utl.DIRECTION.W],
		utl.DIRECTION.SE: [utl.DIRECTION.S, utl.DIRECTION.E],
		}
	var diagonal_lookup_corners = {
		utl.DIRECTION.NE: Vector2(grid_entity.width, -1),
		utl.DIRECTION.NW: Vector2(-1, -1),
		utl.DIRECTION.SW: Vector2(-1, grid_entity.height),
		utl.DIRECTION.SE: Vector2(grid_entity.width, grid_entity.height),
		}
	if dir in cardinal_lookup_bounds:
		if _check_can_move_section(start_coord, cardinal_lookup_bounds[dir]):
			dir_to_move = dir
	elif dir in diagonal_lookup_dirs:
		var d0 = diagonal_lookup_dirs[dir][0]
		var d1 = diagonal_lookup_dirs[dir][1]
		var can_move_0 = _check_can_move_section(start_coord, cardinal_lookup_bounds[d0])
		var can_move_1 = _check_can_move_section(start_coord, cardinal_lookup_bounds[d1])
		var corner = diagonal_lookup_corners[dir]
		var can_move_corner = tilemap.get_cell(start_coord.x + corner.x, start_coord.y + corner.y) == utl.GRID.NONE
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
			if tilemap.get_cell(start.x + coord.x, start.y + coord.y) != utl.GRID.NONE:
				can_move = false
			coord.y += 1
		coord.y = params[2]
		coord.x += 1
	return can_move
