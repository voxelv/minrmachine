extends Node

enum GRID_OBJECT_TYPE {GRID_NONE=-1, GRID_ROCK, GRID_COAL, GRID_IRON, GRID_COPPER, GRID_RADICAL}

enum DIRECTION {DIR_NONE, DIR_N, DIR_E, DIR_S, DIR_W, DIR_NW, DIR_SW, DIR_SE, DIR_NE, DIR_INV}

enum E_GRID {NONE = -1, WIRE}
enum O_GRID {NONE = -1, CENTRAL_UNIT}

var e_grid_organelles = [O_GRID.CENTRAL_UNIT]

const TILES_PER_SIDE = 25

const CELL_SIZE_PIXELS = 25.0

func _2d_to_idx(x, y, width):
	var result = (width * y) + x
	return(result)

func dir_inv(direction):
	var result = DIR_INV
	
	match(direction):
		DIR_N:
			result = DIR_S
		DIR_E:
			result = DIR_W
		DIR_S:
			result = DIR_N
		DIR_W:
			result = DIR_E
		DIR_NW:
			result = DIR_SE
		DIR_SW:
			result = DIR_NE
		DIR_SE:
			result = DIR_NW
		DIR_NE:
			result = DIR_SW
		DIR_INV:
			pass
		_:
			pass
	return(result)

func offset_to_dir(v_offset):
	var result = DIR_INV
	
	match(v_offset):
		Vector2(0, 0):
			result = DIR_NONE
		Vector2(1, 0):
			result = DIR_E
		Vector2(1, -1):
			result = DIR_NE
		Vector2(0, -1):
			result = DIR_N
		Vector2(-1, -1):
			result = DIR_NW
		Vector2(-1, 0):
			result = DIR_W
		Vector2(-1, 1):
			result = DIR_SW
		Vector2(0, 1):
			result = DIR_S
		Vector2(1, 1):
			result = DIR_SE
		_:
			pass
	return result

func dir_to_offset(direction):
	var x = 0
	var y = 0
	
	match(direction):
		DIR_N:
			y = -1
		DIR_E:
			x = 1
		DIR_S:
			y = 1
		DIR_W:
			x = -1
		DIR_NW:
			x = -1
			y = -1
		DIR_SW:
			x = -1
			y = 1
		DIR_SE:
			x = 1
			y = 1
		DIR_NE:
			x = 1
			y = -1
		DIR_INV:
			pass
		_:
			pass
	return Vector2(x, y)

