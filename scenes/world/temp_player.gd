extends Node2D

@export var tilemaplayer: TileMapLayer
@export var moviment_speed: float = 300.0

var astar: AStarGrid2D
var current_id_path: Array[Vector2i]
var target_position: Vector2
var is_moving: bool = false

func _ready() -> void:
	astar = AStarGrid2D.new()
	astar.region = tilemaplayer.get_used_rect()
	astar.cell_size = tilemaplayer.tile_set.tile_size
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.update()

	for x: int in tilemaplayer.get_used_rect().size.x:
		for y: int in tilemaplayer.get_used_rect().size.y:
			var tile_position: Vector2i = Vector2i(
				x + tilemaplayer.get_used_rect().position.x,
				y + tilemaplayer.get_used_rect().position.y
			)

			var tile_data: TileData = tilemaplayer.get_cell_tile_data(tile_position)
			if not tile_data or not tile_data.get_custom_data("walkable"):
				astar.set_point_solid(tile_position, true)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("move_on_click"):
		return
	
	var id_path: Array[Vector2i] = astar.get_id_path(
		tilemaplayer.local_to_map(
			target_position if is_moving else global_position
		),
		tilemaplayer.local_to_map(get_global_mouse_position())
	)

	id_path = id_path if is_moving else id_path.slice(1)

	if not id_path.is_empty():
		current_id_path = id_path


func _physics_process(delta: float) -> void:
	if current_id_path.is_empty():
		return
	
	if not is_moving:
		target_position = tilemaplayer.map_to_local(current_id_path[0])
		is_moving = true

	global_position = global_position.move_toward(
		target_position, moviment_speed * delta)

	if global_position == target_position:
		current_id_path.pop_front()

		if not current_id_path.is_empty():
			target_position = tilemaplayer.map_to_local(current_id_path[0])
		else:
			is_moving = false
