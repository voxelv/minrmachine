extends Control

export(String) var tile_name = "TEST"

func _ready():
	$HBoxContainer/VBoxContainer/name.text = tile_name

func set_selected(selected):
	$HBoxContainer/VBoxContainer/count.visible = selected

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			print("Pressed: ", tile_name)