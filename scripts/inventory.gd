extends VBoxContainer

var inv_item = preload("res://scenes/ui_widgets/tile_container.tscn")

func _ready():
	pass

func _input(event):
	if event is InputEventKey and event.scancode == KEY_BACKSLASH:
		_update_inventory()

func _update_inventory():
	for child in get_children():
		remove_child(child)
	for obj in gamedata.player_inv:
		var new_item = inv_item.instance()
		add_child(new_item)
		new_item.set_name(obj["name"])
		new_item.set_count(obj["count"])