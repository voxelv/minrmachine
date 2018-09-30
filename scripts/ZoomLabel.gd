extends Label

func _on_Camera2D_zoom_label_set(i):
	text = "Zoom: {zoom_lvl}x".format({'zoom_lvl': str(i)})
