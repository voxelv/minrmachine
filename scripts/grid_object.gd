extends Node2D

var type = utl.GRID_NONE

var grid = null
var cellv = null
onready var cellv_test_pos = $cellv_test_pos.position
var moving = false

onready var movement = get_node("movement")
onready var draw = get_node("draw")

export(int) var width = 1
export(int) var height = 1
export(float) var speed = 20

func _ready():
	get_parent().register_grid_object(self)

func get_cellv_test_pos():
	var result = to_global(cellv_test_pos)
	return result

func _move_callback():
	moving = false

func move(direction):
	var prev_pos = position
	if not moving:
		moving = true
		position = grid.request_move(self, direction)
#		$draw.position = prev_pos
		movement.interpolate_callback(self, speed, "_move_callback")
#		movement.interpolate_property(draw, "transform/position", prev_pos, position, speed, Tween.TRANS_LINEAR, Tween.EASE_IN)
