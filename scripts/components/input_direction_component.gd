extends DirectionComponent
class_name InputDirectionComponent

func _process(_delta: float) -> void:
    direction = Input.get_vector(
        "move_left",
        "move_right",
        "move_up",
        "move_down"
    )