extends Node2D

var type = utl.GRID_NONE

var grid = null
var cellv = null
onready var cellv_test_pos = $cellv_test_pos.position

export(int) var width = 1
export(int) var height = 1

func _ready():
	get_parent().register_grid_object(self)

func get_cellv_test_pos():
	var result = to_global(cellv_test_pos)
	return result
