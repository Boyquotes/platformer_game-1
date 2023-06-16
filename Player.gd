extends CharacterBody2D

@onready var ground_checker = $GroundChecker

@export var movement_speed := 100
@export var gravity := 980
@export var jump_height := 100.0
@onready var jump_velocity := sqrt(2 * jump_height * gravity)

var enabled = false

func disable():
	hide()
	velocity = Vector2.ZERO
	enabled = false

func enable():
	show()
	enabled = true

func _process(delta):
	if not enabled:
		return
	var movement = 0.0
	var grounded = ground_checker.get_collider() != null
	
	if Input.is_action_pressed("left"):
		movement -= 1
	if Input.is_action_pressed("right"):
		movement += 1
	if Input.is_action_just_pressed("jump") and grounded:
		velocity.y = jump_velocity * -1
	velocity.x = movement * movement_speed

func _physics_process(delta):
	if not enabled:
		return
	velocity += gravity * Vector2.DOWN * delta
	move_and_slide()
