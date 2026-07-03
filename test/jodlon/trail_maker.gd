class_name TrailMaker extends Node2D

class Line:
	var from: Vector2
	var to: Vector2
	func _init(from: Vector2, to: Vector2):
		self.from = from
		self.to = to

var _trails: Array[Line]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_trails = []


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw() -> void:
	for line in _trails:
		draw_line(line.from, line.to, Color(Color.BLACK, 0.3), 10.0)
		

func add_line(from: Vector2, to: Vector2):
	_trails.append(Line.new(from, to))
	queue_redraw()
