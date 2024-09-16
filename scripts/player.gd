class_name Player extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $Sprite

var movement_controller: MovementController

func _ready():
	movement_controller = MovementController.new()
	movement_controller.initialize(sprite)
	
func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var is_running = Input.is_action_pressed("run")
	var should_dash = Input.is_action_just_pressed("dash")
	
	velocity = movement_controller.move_character(delta, input_direction, is_running, should_dash)
	move_and_slide()

func _exit_tree():
	movement_controller.free()
