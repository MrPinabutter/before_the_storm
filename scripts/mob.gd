extends CharacterBody2D

const SPEED = 210.0

@export var player: Node2D # RENAME TO TARGET
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D

enum {
	STAND,
	SURROUND,
	ATTACK,
	HIT
}

var state = ATTACK

func _ready() -> void:
	call_deferred("seeker_setup")

func seeker_setup():
	await get_tree().physics_frame
	if player:
		navigation_agent_2d.target_position = player.global_position
		

func move(target, delta):
	if navigation_agent_2d.is_navigation_finished():
		return
	var current_agent_position = global_position
	var next_agent_position = navigation_agent_2d.get_next_path_position()
	
	var direction = current_agent_position.direction_to(next_agent_position)
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	
	velocity += steering
	velocity = desired_velocity
	
	move_and_slide()
	
	if direction.x != 0:
		sprite.flip_h = direction.x < 0

func _physics_process(delta: float) -> void:
	if player:
		navigation_agent_2d.target_position = player.global_position
		
	match state:
		STAND:
			pass
		ATTACK:
			move(player.global_position, delta)
		HIT: # Parar a uma distância fixa e dar um dash no player
			pass
