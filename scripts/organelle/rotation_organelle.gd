extends Node2D

var rotation_sprite:Sprite = null

func activate():
	pass

func deactivate():
	pass

func set_rotation(rot_degrees:float):
	var _direction_lkup:Array = [utl.DIRECTION.E, utl.DIRECTION.S, utl.DIRECTION.W, utl.DIRECTION.N]
	var rotation_idx:int = (int(rot_degrees) % 360) / 90
	face_direction(_direction_lkup[rotation_idx])

func face_direction(direction:int):
	utl.rotate_25px_sprite(rotation_sprite, direction)

