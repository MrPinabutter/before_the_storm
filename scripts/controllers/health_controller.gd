class_name HealthController extends Node

@export var max_health: float = 100.0: set = _set_max_health, get = _get_max_health
@export var health: float = 100.0: set = _set_health, get = _get_health

func _ready() -> void:
	pass

func _set_health(value: float) -> void:
	var parent: Node = get_parent()
	if parent:
		if value > max_health:
			_log("Full Health Already")
		elif value <= 0:
			_log("Character Dead")
		else:
			_log("health: " + str(value))
			health = value

func _get_health() -> float:
	return health

func _set_max_health(value: float) -> void:
	var parent: Node = get_parent()
	if parent:
		if (value < 0):
			_log("ERROR: negative max health are not valid")
			return
		max_health = value

func _get_max_health() -> float:
	return max_health
	
func hurt(value: float):
	health -= value
	
func healed(value: float):
	health += value
	
func increased_max_health(value: float):
	max_health += value
 
func _log(message: String):
	print("HEALTH_CONTROLLER:", message)
