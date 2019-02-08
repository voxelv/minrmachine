extends Node

# Enums
enum GRID {NONE=-1, ROCK, COAL, IRON, COPPER, RADICAL}
enum DIRECTION {NONE, N, E, S, W, NW, SW, SE, NE, INV}
enum E_GRID {NONE = -1, WIRE}
enum ORGANELLE {NONE = -1, CENTRAL_UNIT, DRILL}

var e_grid_organelles = [ORGANELLE.CENTRAL_UNIT, ORGANELLE.DRILL]

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

func rotate_25px_sprite(sprite:Sprite, direction:int):
	var _rotations = [0, PI/2, PI, 3*PI/2]
	var _positions = [Vector2(0, 0), Vector2(25, 0), Vector2(25, 25), Vector2(0, 25)]
	var _flip_v = [false, false, true, true]
	
	var idx:int = 0
	
	match(direction):
		DIRECTION.E:
			idx = 0
		DIRECTION.S:
			idx = 1
		DIRECTION.W:
			idx = 2
		DIRECTION.N:
			idx = 3
		_:
			pass
	
	sprite.rotation = _rotations[idx]
	sprite.position = _positions[idx]
	sprite.flip_v = _flip_v[idx]














