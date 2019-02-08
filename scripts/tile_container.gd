extends Control

signal clicked

var tile_name = "TEST"
var tile_type = utl.GRID.NONE
var tile_count = 0

onready var name_label:Label = find_node("name") as Label
onready var count_label:Label = find_node("count") as Label
onready var sel_box:Control = find_node("sel_box") as Control

var data = null

func set_selected(selected:bool):
	sel_box.visible = selected

func set_name(name_str):
	tile_name = name_str
	name_label.text = name_str

func set_count(num):
	tile_count = num
	count_label.text = str(num)

func set_data(new_data):
	var prev_data = data
	data = new_data
	return prev_data

func get_data():
	return data

func _gui_input(event:InputEvent):
	var evmb:InputEventMouseButton = event as InputEventMouseButton
	if evmb and evmb.button_index == BUTTON_LEFT:
		if event.pressed:
			print("Pressed: ", tile_name)
			emit_signal("clicked", get_position_in_parent())
