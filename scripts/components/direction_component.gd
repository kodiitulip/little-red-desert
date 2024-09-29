extends Node
class_name DirectionComponent

@export var character: Node2D

var direction: Vector2

func _ready() -> void:
    assert(character, "Character must be defined")

    if not character.has_meta("direction_component"):
        character.set_meta("direction_component", self)
