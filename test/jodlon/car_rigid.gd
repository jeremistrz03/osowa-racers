extends RigidBody2D

var acceleration := 300.0
#var speed := 0.0
var grip := 0.95
#var drift_force := Vector2.ZERO
#var random = RandomNumberGenerator.new();
var trailmaker: TrailMaker;

enum Wheel {
	FR, FL, RR, RL
}

var last_trail: Dictionary[Wheel, Vector2] = {}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var trailmanager = get_parent().get_node_or_null("TrailManager")
	if trailmanager:
		trailmaker = trailmanager.new_car()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	var heading = Vector2.UP.rotated(rotation);
	#draw_line(Vector2.ZERO, heading * acceleration * 1, Color.RED, 5)
	draw_line(Vector2.ZERO, linear_velocity.rotated(-rotation), Color.GREEN, 5)

	
func _physics_process(delta: float) -> void:
	var v = Input.get_axis("ui_down", "ui_up")
	var h = Input.get_axis("ui_left", "ui_right")
	
	#var velocity = linear_velocity.rotated(-rotation)
	#var forward_v = velocity.y
	#var side_v = velocity.x
	
	#apply_force(-linear_velocity)
	#apply_force(Vector2(0, -side_v * grip).rotated(rotation))
	
	# acceleration / breaking
	#speed = move_toward(speed, 0, acceleration / 3)
	#speed += acceleration * v
	var heading = Vector2.UP.rotated(rotation);
	if v == 1.0:
		apply_force(heading * acceleration)
	elif v == -1.0:
		apply_force(heading * acceleration * -2)
	#apply_force(-heading * acceleration * v)
	# ROTATION
	#rotate(h * delta * PI / 2)
	#var something = 20000 #3000
	#apply_torque()
	

	# handbrake (its bad)


	
	_counteract_drift()
	
	if Input.is_key_pressed(KEY_SPACE):
		grip = move_toward(grip, 0.2, 2.0 * delta)
		#apply_force(-heading * acceleration / 2)
	else:
		grip = move_toward(grip, 0.95, 0.3 * delta)
		
	_handle_rotation(h)
	if trailmaker:
		_handle_wheel_trails()
	
	queue_redraw()
	
func _counteract_drift() -> void:
	var steering_right_angle := 0.0;
	if angular_velocity > 0:
		steering_right_angle = 90
	elif angular_velocity < 0:
		steering_right_angle = -90
	
	var steering_direction = Vector2.UP.rotated(deg_to_rad(steering_right_angle) + rotation)
	
	var drift_force = linear_velocity.dot(steering_direction)
	
	# counterforce direction * -1.0 because drift_force is negative * 5.0 (grip)
	var counterforce = steering_direction * -1.0 * drift_force * 6.0 * grip
	
	apply_force(counterforce)
	
func _handle_rotation(h: float) -> void:
	var best_turn_speed := 250.0
	var turn_strength: float
	if linear_velocity.length() <= best_turn_speed:
		turn_strength = inverse_lerp(0.0, best_turn_speed, linear_velocity.length())
	else:
		turn_strength = clamp(inverse_lerp(1200, best_turn_speed, linear_velocity.length()), 0.5, 1.0)
	
	#print("V: ", linear_velocity.length(), " TURN STRENGTH: ", turn_strength)
	
	var base_turn_force := 20000 * h * PI / 2
	apply_torque(base_turn_force * turn_strength)

func _handle_wheel_trails() -> void:
	var drift_force = abs(linear_velocity.dot(transform.x))
	if drift_force > 200:
		var last_r; var last_l; var curr_r; var curr_l;
		
		print(rad_to_deg(abs(transform.y.angle_to(linear_velocity))))
		
		# meaning the car is going backward
		if rad_to_deg(abs(transform.y.angle_to(linear_velocity))) < 90:
			$SmokeParticlesFrontR.emitting = true
			$SmokeParticlesFrontL.emitting = true
			
			last_r = last_trail.get(Wheel.FR)
			last_l = last_trail.get(Wheel.FL)
			curr_r = $FR.global_position
			curr_l = $FL.global_position
		
			last_trail.set(Wheel.FR, curr_r)
			last_trail.set(Wheel.FL, curr_l)
		else:
			$SmokeParticlesRearR.emitting = true
			$SmokeParticlesRearL.emitting = true
		
			last_r = last_trail.get(Wheel.RR)
			last_l = last_trail.get(Wheel.RL)
			curr_r = $RR.global_position
			curr_l = $RL.global_position
		
			last_trail.set(Wheel.RR, curr_r)
			last_trail.set(Wheel.RL, curr_l)
		
		if last_l and last_r:
			trailmaker.add_line(last_r, curr_r)
			trailmaker.add_line(last_l, curr_l)
	else:
		$SmokeParticlesFrontR.emitting = false
		$SmokeParticlesFrontL.emitting = false
		$SmokeParticlesRearR.emitting = false
		$SmokeParticlesRearL.emitting = false
		
		last_trail.clear()
	
	
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	return
	#var v = state.linear_velocity.rotated(-rotation);
	#var side_v = v.x
	#state.linear_velocity.x *= grip
	
	#state.apply_central_force(Vector2(-side_v, 0).rotated(rotation) * 6 * grip)
