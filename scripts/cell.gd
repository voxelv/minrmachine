extends 'grid_entity.gd'

onready var o_grid:TileMap = find_node("o_grid") as TileMap
onready var e_grid:TileMap = find_node("e_grid") as TileMap

var instantiators = {
	utl.ORGANELLE.DRILL: preload("res://scenes/organelle/drill.tscn"),
	}

func add_wire(vcoord):
	if contains_coord(vcoord):
		e_grid.set_cell(vcoord.x, vcoord.y, utl.ENERGY.WIRE, false, false, false, Vector2(0, 0))
		e_grid.update_bitmask_area(vcoord)

func del_wire(vcoord):
	if contains_coord(vcoord):
		e_grid.set_cell(vcoord.x, vcoord.y, utl.ENERGY.NONE, false, false, false, Vector2(0, 0))
		e_grid.update_bitmask_area(vcoord)

func add_organelle(vcoord, organelle):
	if contains_coord(vcoord):
		var prev_organelle = o_grid.get_cellv(vcoord)
		if(prev_organelle != utl.ORGANELLE.NONE):
			return
		if organelle in instantiators:
			var new_entity = instantiators[organelle].instance()
			draw.add_child(new_entity)
			new_entity.position = o_grid.map_to_world(vcoord)
		o_grid.set_cell(vcoord.x, vcoord.y, organelle, false, false, false, Vector2(0, 0))
		if organelle in utl.e_grid_organelles:
			add_wire(vcoord)

func del_organelle(vcoord):
	if contains_coord(vcoord):
		var prev_organelle = o_grid.get_cell(vcoord.x, vcoord.y)
		o_grid.set_cell(vcoord.x, vcoord.y, utl.ORGANELLE.NONE, false, false, false, Vector2(0, 0))
		if prev_organelle in utl.e_grid_organelles:
			del_wire(vcoord)
		return(prev_organelle)

