extends Node2D

onready var tm:TileMap = find_node("rock_grid") as TileMap

var grid_entities = []
var ready = false

func _ready():
	ready = true

func _grid_coord_to_entity_coord(entity, coord:Vector2) -> Vector2:
	var entity_coord:Vector2 = tm.world_to_map(entity.get_cellv_test_pos())
	return(coord - entity_coord)

func _entity_coord_to_grid_coord(entity, coord:Vector2) -> Vector2:
	var entity_coord:Vector2 = tm.world_to_map(entity.get_cellv_test_pos())
	return(coord + entity_coord)

func _entity_clicked(coord:Vector2):
	var result = null
	for entity in grid_entities:
		if entity.contains_coord(_grid_coord_to_entity_coord(entity, coord)):
			result = entity
			break
	return result

func _click_rock_grid(coord):
	var current_item = gamedata.get_current_inv_item()
	if current_item.grid == utl.GRID.ROCK:
		var prev_tile = tm.get_cellv(coord)
		if current_item.type == utl.ROCK.NONE:
			tm.set_cellv(coord, utl.ROCK.NONE)
			if prev_tile != utl.ROCK.NONE:
				for item in gamedata.player_inv:
					if item.grid == utl.GRID.ROCK and item.type == prev_tile:
						item.count += 1
		else:
			if current_item.count > 0:
				current_item.count -= 1
				tm.set_cellv(coord, current_item.type)
				if prev_tile != utl.ROCK.NONE:
					for item in gamedata.player_inv:
						if item.grid == utl.GRID.ROCK and item.type == prev_tile:
							item.count += 1
		gamedata.inv_needs_update = true
	print(coord, ": ", tm.get_cellv(coord))

func clicked_at(world_pos:Vector2, event:InputEventMouseButton) -> void:
	var v = tm.world_to_map(world_pos)
	var entity = _entity_clicked(v)
	if entity != null:
		entity.click_at(_grid_coord_to_entity_coord(entity, v), event)
	else:
		if event.button_index == BUTTON_LEFT and event.pressed:
			_click_rock_grid(v)

func get_grid_rect():
	var side_length = tm.cell_size.x * utl.TILES_PER_SIDE
	var rect = Rect2(position, Vector2(side_length, side_length))
	return(rect)

func register_grid_entity(grid_entity):
	if not ready:
		yield(get_tree(), "idle_frame")
	
	grid_entity.grid = self
	grid_entity.position = map_to_world(world_to_map(grid_entity.position))
	grid_entities.append(grid_entity)

func world_to_map(pos):
	var result = tm.world_to_map(pos)
	return(result)

func map_to_world(cellv):
	var result = tm.map_to_world(cellv)
	return(result)

func remove_tile_at(world_pos:Vector2) -> int:
	var v = tm.world_to_map(world_pos)
	var prev_tile:int = tm.get_cellv(v)
	tm.set_cellv(v, utl.ROCK.NONE)
	return(prev_tile)

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
		var can_move_corner = tm.get_cell(start_coord.x + corner.x, start_coord.y + corner.y) == utl.ROCK.NONE
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
			if tm.get_cell(start.x + coord.x, start.y + coord.y) != utl.ROCK.NONE:
				can_move = false
			coord.y += 1
		coord.y = params[2]
		coord.x += 1
	return can_move
