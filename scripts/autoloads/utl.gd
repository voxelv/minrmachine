extends Node

enum GRID_OBJECT_TYPE {GRID_NONE=-1, GRID_ROCK, GRID_COAL, GRID_IRON, GRID_COPPER, GRID_RADICAL, GRID_MULTI_CELL, GRID_MULTI_CELL_SUBCELL}

enum DIRECTION {DIR_N, DIR_E, DIR_S, DIR_W, DIR_INV}

const TILES_PER_SIDE = 25

const CELL_SIZE_PIXELS = 25.0

func _2d_to_idx(x, y, width):
	var result = (width * y) + x
	return(result)

func dir_offset(direction):
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
		DIR_INV:
			pass
		_:
			pass
	return Vector2(x, y)

