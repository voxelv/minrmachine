extends 'grid_object.gd'

onready var organelle_grid = get_node("draw/organelles")
onready var e_grid = get_node("draw/e_grid")

var count = 0

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("TEST"):
		add_wire(Vector2(count % 5, count / 5))
		e_grid.update_bitmask_region()
		count += 1


func add_wire(vcoord):
	e_grid.set_cell(vcoord.x, vcoord.y, 0, false, false, false, Vector2(0, 0))


