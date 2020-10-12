extends MeshInstance

enum Directions {
	LEFT, RIGHT, UP, DOWN
}

var length = 0.7
var direction = Directions.LEFT


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self.mesh, "size", mesh.size, mesh.size + Vector2(length, 0), 1)
	tween.interpolate_property(self, "translation", translation, translation + Vector3(-length/2, 0, 0), 1)
	tween.start()
