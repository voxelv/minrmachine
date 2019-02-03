extends Node2D

var grid = null
var cellv = null
onready var cellv_test_pos = $cellv_test_pos.position
var moving = false

onready var movement = get_node("movement")
onready var draw = get_node("draw")

export(int) var width = 1
export(int) var height = 1
export(float) var speed = 0.5

func _ready():
	get_parent().register_grid_object(self)

func get_cellv_test_pos():
	var result = to_global(cellv_test_pos)
	return result

func _move_callback():
	moving = false

func move(direction):
	# Returns whether the request was accepted
	var request_accepted = false
	if not moving:
		var moved_dir = grid.request_move(self, direction)
		if moved_dir != utl.DIRECTION.NONE and moved_dir != utl.DIRECTION.INV:
			moving = true
			var draw_pos = grid.map_to_world(utl.dir_to_offset(utl.dir_inv(moved_dir)))
			draw.position = draw_pos
			movement.interpolate_property(draw, "position", draw_pos, Vector2(0, 0), speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
			movement.interpolate_callback(self, speed, "_move_callback")
			movement.start()
		request_accepted = true
	return(request_accepted)
