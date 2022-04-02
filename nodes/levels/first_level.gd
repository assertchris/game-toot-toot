extends GameLevel

@export var vehicles : Array[PackedScene] = []

@onready var _entrance_path := $Paths/Entrance
@onready var _top_path := $Paths/Top
@onready var _middle_path := $Paths/Middle
@onready var _bottom_path := $Paths/Bottom
@onready var _top_indicator := $Turns/Top/Indicator
@onready var _middle_indicator := $Turns/Middle/Indicator
@onready var _bottom_indicator := $Turns/Bottom/Indicator

var is_top_open := false
var is_middle_open := false
var is_bottom_open := false

func _ready() -> void:
	color_turns()

func _draw() -> void:
	draw_polyline(_entrance_path.curve.get_baked_points(), Color.BLACK, 2, false)
	draw_polyline(_top_path.curve.get_baked_points(), Color.BLACK, 2, false)
	draw_polyline(_middle_path.curve.get_baked_points(), Color.BLACK, 2, false)
	draw_polyline(_bottom_path.curve.get_baked_points(), Color.BLACK, 2, false)

func _process(delta: float) -> void:
	for child in _entrance_path.get_children():
		if child is GameVehicle:
			move_vehicle(child, child.speed * delta)

	for child in _top_path.get_children():
		if child is GameVehicle:
			move_vehicle(child, child.speed * delta)

	for child in _middle_path.get_children():
		if child is GameVehicle:
			move_vehicle(child, child.speed * delta)

	for child in _bottom_path.get_children():
		if child is GameVehicle:
			move_vehicle(child, child.speed * delta)

func move_vehicle(vehicle : GameVehicle, distance : float) -> void:
	if vehicle.unit_offset == 1.0:
		vehicle.fade_out()
		await vehicle.faded_out
		vehicle.queue_free()
	else:
		vehicle.offset += distance

func _on_vehicle_spawn_timer_timeout() -> void:
	var new_vehicle := vehicles[randi() % vehicles.size()].instantiate() as GameVehicle
	_entrance_path.add_child(new_vehicle)
	new_vehicle.fade_in()

func _on_top_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_top_open = not is_top_open
			color_turns()

func _on_middle_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_middle_open = not is_middle_open
			color_turns()

func _on_bottom_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			is_bottom_open = not is_bottom_open
			color_turns()

func color_turns() -> void:
	_top_indicator.color = Constants.turn_color_closed
	_middle_indicator.color = Constants.turn_color_closed
	_bottom_indicator.color = Constants.turn_color_closed

	if is_top_open:
		_top_indicator.color = Constants.turn_color_open

	if is_middle_open:
		_middle_indicator.color = Constants.turn_color_open

	if is_bottom_open:
		_bottom_indicator.color = Constants.turn_color_open

func _on_top_area_entered(area: Area2D) -> void:
	var vehicle := area.get_parent()

	if vehicle is GameVehicle and is_top_open and vehicle.get_parent() != _top_path:
		move_to_path(vehicle, _top_path)

func _on_middle_area_entered(area: Area2D) -> void:
	var vehicle := area.get_parent()

	if vehicle is GameVehicle and is_middle_open and vehicle.get_parent() != _middle_path:
		move_to_path(vehicle, _middle_path)

func _on_bottom_area_entered(area: Area2D) -> void:
	var vehicle := area.get_parent()

	if vehicle is GameVehicle and is_bottom_open and vehicle.get_parent() != _bottom_path:
		move_to_path(vehicle, _bottom_path)

func move_to_path(vehicle : GameVehicle, path : Path2D) -> void:
	vehicle.get_parent().remove_child(vehicle)
	path.add_child(vehicle)
	vehicle.offset = 0
	vehicle.flip()
