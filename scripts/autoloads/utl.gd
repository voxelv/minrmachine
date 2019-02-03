extends Node

# Enums
enum GRID_OBJECT_TYPE {GRID_NONE=-1, GRID_ROCK, GRID_COAL, GRID_IRON, GRID_COPPER, GRID_RADICAL}
enum DIRECTION {NONE, N, E, S, W, NW, SW, SE, NE, INV}
enum E_GRID {NONE = -1, WIRE}
enum O_GRID {NONE = -1, CENTRAL_UNIT}

var e_grid_organelles = [O_GRID.CENTRAL_UNIT]

const TILES_PER_SIDE = 25
const CELL_SIZE_PIXELS = 25.0

func _2d_to_idx(x:int, y:int, width:int):
	var result = (width * y) + x
	return(result)

func dir_inv(direction:int):
	var result = DIRECTION.INV

	match(direction):
		DIRECTION.N:
			result = DIRECTION.S
		DIRECTION.E:
			result = DIRECTION.W
		DIRECTION.S:
			result = DIRECTION.N
		DIRECTION.W:
			result = DIRECTION.E
		DIRECTION.NW:
			result = DIRECTION.SE
		DIRECTION.SW:
			result = DIRECTION.NE
		DIRECTION.SE:
			result = DIRECTION.NW
		DIRECTION.NE:
			result = DIRECTION.SW
		DIRECTION.INV:
			pass
		_:
			pass
	return(result)

func offset_to_dir(v_offset:Vector2):
	var result = DIRECTION.INV

	match(v_offset):
		Vector2(0, 0):
			result = DIRECTION.NONE
		Vector2(1, 0):
			result = DIRECTION.E
		Vector2(1, -1):
			result = DIRECTION.NE
		Vector2(0, -1):
			result = DIRECTION.N
		Vector2(-1, -1):
			result = DIRECTION.NW
		Vector2(-1, 0):
			result = DIRECTION.W
		Vector2(-1, 1):
			result = DIRECTION.SW
		Vector2(0, 1):
			result = DIRECTION.S
		Vector2(1, 1):
			result = DIRECTION.SE
		_:
			pass
	return result

func dir_to_offset(direction:int):
	var x = 0
	var y = 0

	match(direction):
		DIRECTION.N:
			y = -1
		DIRECTION.E:
			x = 1
		DIRECTION.S:
			y = 1
		DIRECTION.W:
			x = -1
		DIRECTION.NW:
			x = -1
			y = -1
		DIRECTION.SW:
			x = -1
			y = 1
		DIRECTION.SE:
			x = 1
			y = 1
		DIRECTION.NE:
			x = 1
			y = -1
		DIRECTION.INV:
			pass
		_:
			pass
	return Vector2(x, y)

