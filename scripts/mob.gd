extends CharacterBody2D

const SPEED = 210.0
const DASH_SPEED = 1200.0
const DASH_DURATION = 0.3

@export var player: Node2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var hit_timer: Timer = $HitTimer

var movement_controller: MovementController

enum {
	STAND,
	SURROUND,
	ATTACK,
	STOPPED,
	HIT
}

var state = ATTACK

func _ready() -> void:
	call_deferred("seeker_setup")
	movement_controller = MovementController.new()
	movement_controller.initialize(sprite)
	movement_controller.speed = SPEED
	movement_controller.dash_speed = DASH_SPEED
	movement_controller.dash_duration = DASH_DURATION
	
func seeker_setup():
	await get_tree().physics_frame
	if player:
		navigation_agent_2d.target_position = player.global_position

func move(target, delta, _current_speed = movement_controller.speed):
	if navigation_agent_2d.is_navigation_finished():
		return
	var current_agent_position = global_position
	var next_agent_position = navigation_agent_2d.get_next_path_position()
	
	var direction = current_agent_position.direction_to(next_agent_position)
	var desired_velocity = direction * SPEED
	velocity = movement_controller.move_character(delta, direction, false, false, _current_speed)
	
	move_and_slide()

func _physics_process(delta: float) -> void:
	if player:
		navigation_agent_2d.target_position = player.global_position
	match state:
		ATTACK:
			move(player.global_position, delta)
		HIT:
			handle_hit_player()
		STOPPED:
			pass # TODO: ADD ATTACK DIRECTION INDICATOR

func _on_range_hit_box_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and movement_controller.can_dash() and not movement_controller.is_dashing:
		state = STOPPED
		hit_timer.start()

func _on_hit_timer_timeout() -> void:
	if not movement_controller.can_dash() and movement_controller.is_dashing:
		state = ATTACK
	else:
		state = HIT

func handle_hit_player():
	movement_controller.start_dash(global_position.direction_to(player.global_position))
	state = ATTACK
