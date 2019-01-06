extends 'grid_object.gd'

onready var o_grid = get_node("draw/o_grid")
onready var e_grid = get_node("draw/e_grid")

func _ready():
	pass

func _process(delta):
	pass

func _coord_in_cell(coord):
	return((0 <= coord.x) and (coord.x < width) and (0 <= coord.y) and (coord.y < height))

func add_wire(vcoord):
	if _coord_in_cell(vcoord):
		e_grid.set_cell(vcoord.x, vcoord.y, utl.E_GRID.WIRE, false, false, false, Vector2(0, 0))

func del_wire(vcoord):
	if _coord_in_cell(vcoord):
		e_grid.set_cell(vcoord.x, vcoord.y, utl.E_GRID.NONE, false, false, false, Vector2(0, 0))

func add_organelle(vcoord, organelle):
	if _coord_in_cell(vcoord):
		o_grid.set_cell(vcoord.x, vcoord.y, organelle, false, false, false, Vector2(0, 0))
		if organelle in utl.e_grid_organelles:
			add_wire(vcoord)

func del_organelle(vcoord):
	if _coord_in_cell(vcoord):
		var prev_organelle = o_grid.get_cell(vcoord.x, vcoord.y)
		o_grid.set_cell(vcoord.x, vcoord.y, utl.O_GRID.NONE, false, false, false, Vector2(0, 0))
		if prev_organelle in utl.e_grid_organelles:
			del_wire(vcoord)



