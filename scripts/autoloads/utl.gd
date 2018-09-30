extends Node

enum GRID_OBJECT_TYPE {GRID_NONE=-1, GRID_ROCK, GRID_COAL, GRID_IRON, GRID_COPPER, GRID_RADICAL, GRID_MULTI_CELL, GRID_MULTI_CELL_SUBCELL}

enum DIRECTION {DIR_N, DIR_E, DIR_S, DIR_W, DIR_INV}

const TILES_PER_SIDE = 25

const CELL_SIZE_PIXELS = 17.0

func _2d_to_idx(x, y, width):
	var result = (width * y) + x
	return(result)

func _dir_offset(direction):
	var X = 0
	var Y = 1
	var ofst = [0, 0]
	
	match(direction):
		DIR_N:
			ofst[Y] = -1
		DIR_E:
			ofst[X] = 1
		DIR_S:
			ofst[Y] = 1
		DIR_W:
			ofst[X] = -1
		DIR_INV:
			pass
		_:
			pass
	return ofst

