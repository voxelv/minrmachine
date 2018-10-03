extends 'grid_object.gd'

export(float) var input_wait = 0.05
var input_timer = 0.0
var input_on = false

func _ready():
	pass

func _process(delta):
#	if Input.is_action_just_pressed("move_cell_up"):
#		move(utl.DIR_N)
#	if Input.is_action_just_pressed("move_cell_down"):
#		move(utl.DIR_S)
#	if Input.is_action_just_pressed("move_cell_right"):
#		move(utl.DIR_E)
#	if Input.is_action_just_pressed("move_cell_left"):
#		move(utl.DIR_W)

	var dir_pressed = any_move_input()

	if dir_pressed != utl.DIR_NONE:
		input_on = true

	if input_on:
		input_timer += delta
	else:
		# Reset the timer
		input_timer = 0.0

	if input_timer >= input_wait:
		var x = 0
		var y = 0
		if Input.is_action_pressed("move_cell_up") or dir_pressed == utl.DIR_N:
			y -= 1
		if Input.is_action_pressed("move_cell_down") or dir_pressed == utl.DIR_S:
			y += 1
		if Input.is_action_pressed("move_cell_right") or dir_pressed == utl.DIR_E:
			x += 1
		if Input.is_action_pressed("move_cell_left") or dir_pressed == utl.DIR_W:
			x -= 1
		var move_dir = utl.offset_to_dir(Vector2(x, y))
		move(move_dir)
	
	if any_move_input() == utl.DIR_NONE:
		input_on = false
	

func any_move_input():
	var dir_pressed = utl.DIR_NONE
	if Input.is_action_pressed("move_cell_up"):
		dir_pressed = utl.DIR_N
	if Input.is_action_pressed("move_cell_down"):
		dir_pressed = utl.DIR_S
	if Input.is_action_pressed("move_cell_right"):
		dir_pressed = utl.DIR_E
	if Input.is_action_pressed("move_cell_left"):
		dir_pressed = utl.DIR_W
	return dir_pressed