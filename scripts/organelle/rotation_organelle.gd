extends "organelle.gd"

var _direction_lkup:Array = [utl.DIRECTION.E, utl.DIRECTION.S, utl.DIRECTION.W, utl.DIRECTION.N]
onready var rotation_sprite:Sprite = get_rotation_sprite()

func get_rotation_sprite():
	return(null)

func activate():
	pass

func deactivate():
	pass

func set_rotation(rot_degrees:float):
	var rotation_idx:int = (int(rot_degrees) % 360) / 90
	face_direction(_direction_lkup[rotation_idx])

func face_direction(direction:int):
	utl.rotate_25px_sprite(rotation_sprite, direction)

