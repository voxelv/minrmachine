extends Node

var player_inv = [
{"name": "TEST ITEM 1", "count": 123},
{"name": "TEST ITEM 2", "count": 456},
{"name": "TEST ITEM 3", "count": 789},
]
var refresh_player_inv = true

func _process(delta):
	if refresh_player_inv:
		refresh_player_inv = false

