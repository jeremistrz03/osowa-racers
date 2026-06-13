extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var speed = 0
var acceleration = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left") and not speed == 0:
		rotation -= deg_to_rad(2/int(pow(speed, 0.15)))
	if Input.is_action_pressed("ui_right") and not speed == 0:
		rotation += deg_to_rad(2/int(pow(speed, 0.15)))
		
	if Input.is_action_pressed("ui_up"):
		speed = min(500, speed + acceleration)
	else:
		speed = max(0, speed - acceleration)
		
	if Input.is_action_pressed("ui_down"):
		speed = max(0, speed - acceleration * 2)
		
	var vector = Vector2.RIGHT.rotated(rotation) * speed
	
	position += vector * delta
