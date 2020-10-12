tool
extends Spatial

const tilePackedScene = preload("res://scenes/Game/Tile/Tile.tscn")

func _ready():
	for x in range(0, 15):
		for y in range(0, 10):
			spawn_tile(x, y)

func spawn_tile(x, y):
	var tile = tilePackedScene.instance()
	add_child(tile)
	tile.set_owner(self)
	tile.translation.x = (x - 15) * 0.7
	tile.translation.y = (y - 10) * 0.7 
