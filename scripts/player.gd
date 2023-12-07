extends CharacterBody2D

const GRAVITY = 200.0
@export var speed = 500
@export var jump_velocity = 200
@export var max_speed = 300
@export_enum("Left", "Right") var starting_direction: int
var direction

func _ready():
	direction = starting_direction * 2 - 1

func _physics_process(delta):
	velocity.y += delta * GRAVITY
	
	var old_direction = direction
	direction = float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left")) 
	if direction == 0:
		direction = old_direction

	if Input.is_action_just_pressed("move_jump"):
		if is_on_floor():
			velocity.y = -jump_velocity

	velocity.x += speed * direction * delta
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	var motion = velocity * delta
	var collision = move_and_slide()
	
	if is_on_wall():
		direction *= -1;
		velocity.x *= -10;
	
	if $RayCast2D.get_collider() != null:
		get_tree().reload_current_scene()
