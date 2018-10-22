extends Control

export(String) var tile_name = "TEST"

onready var name_label = find_node("name")
onready var count_label = find_node("count")

func _ready():
	name_label.text = tile_name
	set_count(hash(tile_name))

func set_name(name_str):
	name_label.text = name_str

func set_count(num):
	count_label.text = str(num)

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("Pressed: ", tile_name)
			get_parent().inv_clicked(get_position_in_parent())
#			get_parent().remove_child(self)
