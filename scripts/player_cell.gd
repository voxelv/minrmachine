extends 'cell.gd'

signal player_moved

export(float) var input_wait = 0.05
var input_timer = 0.0
var input_on = false

func _ready():
	pass

func click_at(coord:Vector2, event:InputEventMouseButton):
	.click_at(coord, event)
	if event.pressed:
		match(event.button_index):
			BUTTON_LEFT:
				var current_item = gamedata.get_current_inv_item()
				if current_item.grid == utl.GRID.ORGANELLE:
					add_organelle(coord, current_item.type)
				else:
					add_organelle(coord, utl.ORGANELLE.CENTRAL_UNIT)
				get_tree().set_input_as_handled()
			BUTTON_RIGHT:
				if e_grid.get_cellv(coord) != utl.ENERGY.WIRE:
					add_wire(coord)
					get_tree().set_input_as_handled()
				else:
					del_organelle(coord)
					del_wire(coord)
			_:
				pass

func _process(delta):
	var dir_pressed = any_move_input()

	if dir_pressed != utl.DIRECTION.NONE:
		input_on = true

	if input_on:
		input_timer += delta
	else:
		# Reset the timer
		input_timer = 0.0

	if input_timer >= input_wait:
		var x = 0
		var y = 0
		if Input.is_action_pressed("move_cell_up") or dir_pressed == utl.DIRECTION.N:
			y -= 1
		if Input.is_action_pressed("move_cell_down") or dir_pressed == utl.DIRECTION.S:
			y += 1
		if Input.is_action_pressed("move_cell_right") or dir_pressed == utl.DIRECTION.E:
			x += 1
		if Input.is_action_pressed("move_cell_left") or dir_pressed == utl.DIRECTION.W:
			x -= 1
		var move_dir = utl.offset_to_dir(Vector2(x, y))
		var request_accepted = move(move_dir)
		if request_accepted:
			emit_signal("player_moved")
	
	if any_move_input() == utl.DIRECTION.NONE:
		input_on = false

func any_move_input():
	var dir_pressed = utl.DIRECTION.NONE
	if Input.is_action_pressed("move_cell_up"):
		dir_pressed = utl.DIRECTION.N
	if Input.is_action_pressed("move_cell_down"):
		dir_pressed = utl.DIRECTION.S
	if Input.is_action_pressed("move_cell_right"):
		dir_pressed = utl.DIRECTION.E
	if Input.is_action_pressed("move_cell_left"):
		dir_pressed = utl.DIRECTION.W
	return dir_pressed

func get_draw_center_pos():
	var result = to_global(draw.position)
	result.x += (width * utl.CELL_SIZE_PIXELS) / 2.0
	result.y += (height * utl.CELL_SIZE_PIXELS) / 2.0
	return(result)

func get_center_pos():
	var result = get_parent().to_global(position)
	result.x += (width * utl.CELL_SIZE_PIXELS) / 2.0
	result.y += (height * utl.CELL_SIZE_PIXELS) / 2.0
	return(result)

