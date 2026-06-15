extends CharacterBody2D

var speed : float = 0.0
var acceleration : float = 2.0
var turn
var wheels_distance
var centrifugal : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.wheels_distance = $front.position.distance_to($back.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var up = Input.is_action_pressed("ui_up")
	var down = Input.is_action_pressed("ui_down")
	
	if up == down:
		speed = min(speed + acceleration / 2, max(0, speed - acceleration / 2))
	elif up:
		speed = min(500, speed + acceleration)
	elif down:
		speed = max(-200, speed - acceleration * 2)
		
	velocity = Vector2.UP.rotated(rotation) * speed
	
	#position += velocity * delta
	
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	
	if left == right:
		turn = 0
	
	var degrees = deg_to_rad(45)
	
	if left:
		#rotation -= deg_to_rad(1)
		turn = -degrees
	if right:
		#rotation += deg_to_rad(1)
		turn = degrees
		
	var current_rotation = turn * speed * delta / self.wheels_distance
	
	rotation += current_rotation
	
	centrifugal = move_toward(centrifugal, 0.0, acceleration * 3)
	
	if (current_rotation != 0.0):
		var radius : float =  (velocity.length() / (2 * sin(current_rotation / delta / 2)))
		centrifugal = (velocity.length() / radius) * 0.15
	
	position += Vector2.LEFT.rotated(rotation) * centrifugal * delta
	print(centrifugal)
	
	
	move_and_slide()
	
