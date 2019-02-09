extends Node2D

signal input_detected

onready var cellv_test_pos:Vector2 = $cellv_test_pos.position

var grid = null
var moving:bool = false

onready var movement = get_node("movement")
onready var draw:Node2D = find_node("draw") as Node2D

export(int) var width = 1
export(int) var height = 1
export(float) var speed = 0.5
export(bool) var can_move = false

func contains_coord(coord:Vector2):
	return((0 <= coord.x) and (coord.x < width) and (0 <= coord.y) and (coord.y < height))

func _ready():
	var ancestor = get_parent()
	while !ancestor.has_method("register_grid_entity"):
		ancestor = ancestor.get_parent()
	ancestor.register_grid_entity(self)

func _input(event: InputEvent) -> void:
	emit_signal("input_detected", event)

func click_at(coord:Vector2, event:InputEventMouseButton):
	print("Grid Entity clicked at: ", coord)

func get_cellv_test_pos():
	var result = to_global(cellv_test_pos)
	return result

func _move_callback():
	moving = false

func move(direction):
	# Returns whether the request was accepted
	if !can_move:
		return(false)
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
