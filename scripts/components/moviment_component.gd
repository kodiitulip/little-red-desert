extends Node
class_name MovimentComponent

@export var character: Node2D
@export var moviment_speed: float = 300.0

var direction_component: DirectionComponent
var direction: Vector2

func _ready() -> void:
	assert(character, "Character must be defined")
	
	if not character.has_meta("moviment_component"):
		character.set_meta("moviment_component", self)
	if character.has_meta("direction_component"):
		direction_component = character.get_meta("direction_component")


func _physics_process(delta: float) -> void:
	assert(character, "Character must be defined")
	assert(direction_component, "Character must have a DirectionComponent metadata")

	direction = direction_component.direction

	if direction:
		character.global_position = character.global_position.move_toward(
			character.global_position + direction * moviment_speed,
			moviment_speed * delta
		)
