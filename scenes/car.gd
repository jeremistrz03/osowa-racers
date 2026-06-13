extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var direction = 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += deg_to_rad(2) * direction
	var v = Vector2.RIGHT.rotated(rotation)
	v *= 200
	position += v * delta

func _on_button_pressed() -> void:
	direction *= -1
