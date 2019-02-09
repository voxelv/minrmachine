extends Node

const InventoryItem = preload("res://scripts/inventory_item.gd")

var inv_display:Node = null
var player_inv = [
InventoryItem.new("NONE", utl.GRID.ROCK, utl.ROCK.NONE),
InventoryItem.new("ROCK", utl.GRID.ROCK, utl.ROCK.ROCK, 7),
InventoryItem.new("COAL", utl.GRID.ROCK, utl.ROCK.COAL, 6),
InventoryItem.new("IRON", utl.GRID.ROCK, utl.ROCK.IRON, 5),
InventoryItem.new("COPPER", utl.GRID.ROCK, utl.ROCK.COPPER, 4),
InventoryItem.new("RADICAL", utl.GRID.ROCK, utl.ROCK.RADICAL, 3),
InventoryItem.new("DRILL", utl.GRID.ORGANELLE, utl.ORGANELLE.DRILL, 5),
]
var selected_index:int = 0
var inv_needs_update:bool = false

func get_current_inv_item():
	return(player_inv[selected_index])

func _process(delta: float) -> void:
	if inv_needs_update:
		inv_needs_update = false
		if inv_display != null:
			inv_display.update_inventory()
