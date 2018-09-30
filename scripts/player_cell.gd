extends 'grid_object.gd'

func _ready():
	type = utl.GRID_MULTI_CELL

func _process(delta):
	if Input.is_action_just_pressed("move_cell_up"):
		print("move cell up")
		self.position.y -= utl.CELL_SIZE_PIXELS
		grid.request_move(self, utl.DIR_N)
	if Input.is_action_just_pressed("move_cell_down"):
		print("move cell down")
		self.position.y += utl.CELL_SIZE_PIXELS
		grid.request_move(self, utl.DIR_S)
	if Input.is_action_just_pressed("move_cell_left"):
		print("move cell left")
		self.position.x -= utl.CELL_SIZE_PIXELS
		grid.request_move(self, utl.DIR_W)
	if Input.is_action_just_pressed("move_cell_right"):
		print("move cell right")
		self.position.x += utl.CELL_SIZE_PIXELS
		grid.request_move(self, utl.DIR_E)
