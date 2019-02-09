extends Node

var item_name:String
var grid:int
var type:int
var count:int

func _init(item_name:String, grid:int, type:int, count:int=0) -> void:
	self.item_name = item_name
	self.grid = grid
	self.type = type
	self.count = count



