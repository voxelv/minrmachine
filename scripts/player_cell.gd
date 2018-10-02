extends 'grid_object.gd'

export(float) var input_wait = 0.05
var input_timer = 0.0
var input_on = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("move_cell_up"):
		move(utl.DIR_N)

#	if any_move_input():
#		input_on = true
#
#	if input_on:
#		input_timer += delta
#	else:
#		# Reset the timer
#		input_timer = 0.0
#
#	if input_timer >= input_wait:
#		var x = 0
#		var y = 0
#		if Input.is_action_pressed("move_cell_up"):
#			y -= 1
#		if Input.is_action_pressed("move_cell_down"):
#			y += 1
#		if Input.is_action_pressed("move_cell_right"):
#			x += 1
#		if Input.is_action_pressed("move_cell_left"):
#			x -= 1
#		move(utl.offset_to_dir(Vector2(x, y)))
	

func any_move_input():
	if Input.is_action_pressed("move_cell_up"):
		return true
	if Input.is_action_pressed("move_cell_down"):
		return true
	if Input.is_action_pressed("move_cell_left"):
		return true
	if Input.is_action_pressed("move_cell_right"):
		return true
	return false