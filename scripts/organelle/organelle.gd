extends Node2D

signal interact_at_coord

var cell = null
var vcoord:Vector2 = Vector2(0, 0)

func _ready():
	connect("interact_at_coord", cell, "interact_at_coord")