class_name MovementController extends Node

var sprite: AnimatedSprite2D

@export var speed: float = 300.0
@export var dash_speed: float = 1500.0
@export var run_multiplier: float = 1.5
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.8

var velocity: Vector2 = Vector2.ZERO
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO

func initialize(sprite_node: AnimatedSprite2D) -> void:
	sprite = sprite_node

func move_character(delta: float, input_direction: Vector2, is_running: bool, should_dash: bool, _current_speed: float = speed) -> Vector2:
	var speed_multiplier = 1.0
	
	if is_running:
		speed_multiplier = run_multiplier
	
	if can_dash() and should_dash:
		start_dash(input_direction)
	
	if is_dashing:
		handle_dash(delta, _current_speed)
	else:
		velocity = input_direction * _current_speed * speed_multiplier
	
	update_sprite_direction()
	update_timers(delta)
	return velocity

func handle_dash(delta: float, _current_velocity: float = speed):
	var t = dash_timer / dash_duration
	var current_dash_speed = lerp(dash_speed, _current_velocity, 1 - t)
	if dash_timer <= 0:
		is_dashing = false
		dash_cooldown_timer = dash_cooldown
	else:
		velocity = dash_direction * current_dash_speed
	return velocity

func update_timers(delta: float) -> void:
	if dash_timer > 0:
		dash_timer -= delta
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

func start_dash(direction: Vector2) -> void:
	is_dashing = true
	dash_timer = dash_duration
	dash_direction = direction.normalized()

func update_sprite_direction() -> void:
	if sprite:
		if velocity.x < 0:
			sprite.flip_h = true
		elif velocity.x > 0:
			sprite.flip_h = false

func is_running() -> bool:
	return false

func can_dash() -> bool:
	return dash_cooldown_timer <= 0
