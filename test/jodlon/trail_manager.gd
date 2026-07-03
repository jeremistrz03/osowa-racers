extends Node2D

var cars: Array[TrailMaker]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cars = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func new_car() -> TrailMaker:
	var trailmaker = TrailMaker.new()
	cars.append(trailmaker)
	add_child(trailmaker)
	return trailmaker
