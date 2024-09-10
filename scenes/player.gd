extends CharacterBody2D

const SPEED = 300.0
const DASH_SPEED = 1500.0
const RUN_MULTIPLIER = 1.5
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 0.8

var dash_timer = 0.0
var dash_cooldown_timer = 0.0
var is_dashing = false
var dash_direction = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var speed_multiplier = 1
	
	if Input.is_action_pressed("run"):
		speed_multiplier = RUN_MULTIPLIER
		
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		start_dash(input_direction)
	
	if is_dashing:
		handle_dash(delta)
	else:
		velocity = input_direction * SPEED * speed_multiplier
	
	move_and_slide()
	update_timers(delta)

func handle_dash(delta: float):
	var t = dash_timer / DASH_DURATION
	var current_dash_speed = lerp(DASH_SPEED, SPEED, 1 - t)
	velocity = dash_direction * current_dash_speed

	if dash_timer <= 0:
		is_dashing = false
		dash_cooldown_timer = DASH_COOLDOWN
		
func update_timers(delta: float):
	if dash_timer > 0:
		dash_timer -= delta
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta


func start_dash(direction: Vector2):
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_direction = direction.normalized()
