extends Node

var inv_display:Node = null
var player_inv = [
{'name': "NONE", 'type': utl.GRID.NONE, 'count': 0},
{'name': "ROCK", 'type': utl.GRID.ROCK, 'count': 7},
{'name': "COAL", 'type': utl.GRID.COAL, 'count': 6},
{'name': "IRON", 'type': utl.GRID.IRON, 'count': 5},
{'name': "COPPER", 'type': utl.GRID.COPPER, 'count': 4},
{'name': "RADICAL", 'type': utl.GRID.RADICAL, 'count': 3},
]
var selected_index:int = 0
var inv_needs_update:bool = false

func _process(delta: float) -> void:
	if inv_needs_update:
		inv_needs_update = false
		if inv_display != null:
			inv_display.update_inventory()
