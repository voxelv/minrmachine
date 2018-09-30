extends 'grid_object.gd'

func _ready():
	type = utl.GRID_MULTI_CELL

func _process(delta):
	if Input.is_action_just_pressed("move_cell_up"):
		print("move cell up")
		grid.request_move(self, utl.DIR_N)
		self.position.y -= utl.CELL_SIZE_PIXELS
	if Input.is_action_just_pressed("move_cell_down"):
		print("move cell down")
		grid.request_move(self, utl.DIR_S)
		self.position.y += utl.CELL_SIZE_PIXELS
	if Input.is_action_just_pressed("move_cell_left"):
		print("move cell left")
		grid.request_move(self, utl.DIR_W)
		self.position.x -= utl.CELL_SIZE_PIXELS
	if Input.is_action_just_pressed("move_cell_right"):
		print("move cell right")
		grid.request_move(self, utl.DIR_E)
		self.position.x += utl.CELL_SIZE_PIXELS
