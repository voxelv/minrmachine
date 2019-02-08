extends Control

const TileContainer = preload("res://scenes/ui_widgets/tile_container.tscn")

onready var inv_list:VBoxContainer = find_node("inv_list") as VBoxContainer

func _ready():
	gamedata.inv_display = self
	update_inventory()

func update_inventory():
	for child in inv_list.get_children():
		inv_list.remove_child(child)
	for i in range(len(gamedata.player_inv)):
		var obj = gamedata.player_inv[i]
		var new_item = TileContainer.instance()
		new_item.connect("clicked", self, "inv_clicked")
		inv_list.add_child(new_item)
		new_item.set_selected(i == gamedata.selected_index)
		new_item.set_name(obj["name"])
		new_item.set_count(obj["count"])

func deselect_all():
	var tiles = inv_list.get_children()
	for tile in tiles:
		tile.set_selected(false)

func inv_clicked(index):
	var tiles = inv_list.get_children()
	deselect_all()
	gamedata.selected_index = index
	tiles[index].set_selected(true)