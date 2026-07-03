extends CharacterBody2D



var curr_rotation := 0.0
var acceleration := 0.0

const base_grip := .9
const STH := 0.5
const V_MAX := 1200

var best_turn_speed: float = 200.0 # distance between front and back wheels
var bts_proportion := inverse_lerp(0, V_MAX / STH, best_turn_speed)

const best_turn_strength := PI
const energy_loss := 0.8

func turn_strength() -> float:
	# PI so front velocity is treated as y+
	var speed: float = velocity.rotated(-rotation + PI).y
	
	var strength: float
	
	if abs(speed) < best_turn_speed:
		strength = best_turn_strength * (abs(speed) / best_turn_speed)
	else:
		strength = best_turn_strength - ((abs(speed) - best_turn_speed) / (V_MAX /1.5))
	
	# can be negative to simulate car turning
	# in an opposite direction while reversing
	if speed < 0:
		strength *= -1
	
	return strength

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#print($front.position.distance_to($back.position))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var v = Input.get_axis('ui_down', 'ui_up')
	var h = Input.get_axis('ui_left', 'ui_right')
	var handbrake = Input.is_key_pressed(KEY_SPACE)
	
	var grip = base_grip
	if handbrake:
		grip = .01
	
	#var direction_angle := velocity.angle_to(Vector2.UP) - rotation
	#
	#var borders = [0.0, PI/4, PI/2, 3*PI/4, PI];
	
	var relative_velocity = velocity.rotated(-rotation + PI)
	var hori_v: float = relative_velocity.x
	var vert_v: float = relative_velocity.y
	hori_v *= 1 - grip
	#print(hori_v, " ", vert_v)
	
	if v == 1.0:
		vert_v = move_toward(vert_v, V_MAX, 200 * delta)
	elif v == -1.0:
		vert_v = move_toward(vert_v, -200, 300 * delta)
	else:
		vert_v = move_toward(vert_v, 0, 50 * delta)
	
	#velocity -= Vector2.from_angle(velocity.angle()) * 100 * delta
	#print(vert_v)
	
	velocity = Vector2(hori_v, vert_v).rotated(rotation + PI)
	
	#velocity += Vector2.UP.rotated(rotation) * acceleration * delta
	
	#var turn_angle = turn_strength() * best_turn_strength  * grip
	##print("Strength: ", turn_strength(), " Speed: ", abs(velocity.rotated(-rotation).y))
	#if h == 1.0:
		#curr_rotation = move_toward(curr_rotation, PI / 2, turn_angle)
	#elif h == -1.0:
		#curr_rotation = move_toward(curr_rotation, -PI / 2, turn_angle)
	#else:
		#curr_rotation = move_toward(curr_rotation, 0, turn_angle)
		#
	#print(turn_strength())
	#
	rotation += turn_strength() * h * delta
	#rotation += hori_v * delta
	
	#if h == 1.0:
		#rotation += deg_to_rad(90) * delta
	#elif h == -1.0:
		#rotation += -deg_to_rad(90) * delta
	
	move_and_slide()
