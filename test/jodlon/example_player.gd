extends CharacterBody2D

enum Lastdir {
	LEFT,
	RIGHT,
	NONE
}

var speed = 100
var lastdir = Lastdir.NONE

func _ready() -> void:
	$AnimatedSprite2D.play("walk_right")
	$AnimatedSprite2D.stop()

func _process(delta) -> void:
	if Input.is_action_pressed("ui_left"):
		position += Vector2.LEFT * speed * delta
		lastdir = Lastdir.LEFT
	elif Input.is_action_pressed("ui_right"):
		position += Vector2.RIGHT * speed * delta
		lastdir = Lastdir.RIGHT
	else:
		lastdir = Lastdir.NONE
	
	if Input.is_action_pressed("ui_up"):
		position += Vector2.UP * speed * delta
	if Input.is_action_pressed("ui_down"):
		position += Vector2.DOWN * speed * delta
	
	elif lastdir == Lastdir.LEFT:
		$AnimatedSprite2D.play("walk_left")
	elif lastdir == Lastdir.RIGHT:
		$AnimatedSprite2D.play("walk_right")
	else:
		$AnimatedSprite2D.stop()
