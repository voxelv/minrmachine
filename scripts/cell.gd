extends 'grid_entity.gd'

onready var o_grid:TileMap = find_node("o_grid") as TileMap
onready var e_grid:TileMap = find_node("e_grid") as TileMap

var instantiators = {
	utl.ORGANELLE.DRILL: preload("res://scenes/organelle/drill.tscn"),
	}

var entity_organelles = []

func get_entity_organelle(vcoord):
	for entity_organelle in entity_organelles:
		if entity_organelle.vcoord == vcoord:
			return(entity_organelle)
	return(null)

func add_wire(vcoord):
	if contains_coord(vcoord):
		e_grid.set_cell(vcoord.x, vcoord.y, utl.ENERGY.WIRE, false, false, false, Vector2(0, 0))
		e_grid.update_bitmask_area(vcoord)

func del_wire(vcoord):
	if contains_coord(vcoord):
		e_grid.set_cell(vcoord.x, vcoord.y, utl.ENERGY.NONE, false, false, false, Vector2(0, 0))
		e_grid.update_bitmask_area(vcoord)

func add_organelle(vcoord, organelle_type):
	if contains_coord(vcoord):
		var prev_organelle = o_grid.get_cellv(vcoord)
		if(prev_organelle != utl.ORGANELLE.NONE):
			return
		if organelle_type in instantiators:
			var new_organelle = instantiators[organelle_type].instance()
			new_organelle.cell = self
			new_organelle.vcoord = vcoord
			draw.add_child(new_organelle)
			new_organelle.position = o_grid.map_to_world(vcoord)
			entity_organelles.append(new_organelle)
		o_grid.set_cell(vcoord.x, vcoord.y, organelle_type, false, false, false, Vector2(0, 0))
		if organelle_type in utl.energy_organelles:
			add_wire(vcoord)

func del_organelle(vcoord):
	if contains_coord(vcoord):
		var prev_organelle = o_grid.get_cell(vcoord.x, vcoord.y)
		o_grid.set_cell(vcoord.x, vcoord.y, utl.ORGANELLE.NONE, false, false, false, Vector2(0, 0))
		
		# Safe remove from entity_organelles
		var entity_organelle = get_entity_organelle(vcoord)
		if entity_organelle == null:
			pass
		else:
			entity_organelles.remove(entity_organelles.find(entity_organelle))
			draw.remove_child(entity_organelle)
			entity_organelle.queue_free()
		
		if prev_organelle in utl.energy_organelles:
			del_wire(vcoord)
		return(prev_organelle)

func get_coord_from_pos(world_pos:Vector2) -> Vector2:
	return(o_grid.world_to_map(world_pos))

func interact_at_coord(coord, interaction_type):
	match(interaction_type):
		utl.INTERACTION.REMOVE:
			print("REMOVE interaction at: ", coord)
			var got_tile = grid.remove_tile_at(grid.map_to_world(coord))
			if got_tile != utl.ROCK.NONE:
				for inv_item in gamedata.player_inv:
					if inv_item.type == got_tile:
						inv_item.count += 1
						gamedata.inv_needs_update = true
		_:
			pass