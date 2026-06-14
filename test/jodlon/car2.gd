extends CharacterBody2D

var speed = 0
var acceleration = 5
var turn
var wheels_distance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.wheels_distance = $front.position.distance_to($back.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_pressed("ui_up"):
		speed = min(500, speed + acceleration)
	else:
		speed = max(0, speed - acceleration)
		
	if Input.is_action_pressed("ui_down"):
		speed = max(0, speed - acceleration * 2)
		
	var vector = Vector2.UP.rotated(rotation) * speed
	
	position += vector * delta
	
	
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	
	if left == right:
		turn = 0
	
	var degrees = deg_to_rad(22.5)
	
	if left:
		#rotation -= deg_to_rad(1)
		turn = -degrees
	if right:
		#rotation += deg_to_rad(1)
		turn = degrees
	
	rotation += turn * speed * delta / self.wheels_distance
	
	move_and_slide()
	
