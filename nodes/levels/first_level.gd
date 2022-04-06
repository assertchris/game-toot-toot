extends GameLevel

@export var vehicles : Array[PackedScene] = []

@onready var _camera := $Camera
@onready var _entrance_path := $Paths/Entrance
@onready var _top_path := $Paths/Top
@onready var _middle_path := $Paths/Middle
@onready var _bottom_path := $Paths/Bottom
@onready var _top_indicator := $Turns/Top/Indicator
@onready var _middle_indicator := $Turns/Middle/Indicator
@onready var _bottom_indicator := $Turns/Bottom/Indicator
@onready var _quests := $Quests
@onready var _highlight_turns := $HighlightTurns

var is_top_open := false
var is_middle_open := false
var is_bottom_open := false

var quests := []

func _ready() -> void:
	_top_indicator.texture = Constants.turn_down_image
	_middle_indicator.texture = Constants.turn_down_image
	_bottom_indicator.texture = Constants.turn_right_image

	for i in range(_quests.get_child_count()):
		quests.append(null)

	_camera.current = true

	for child in _highlight_turns.get_children():
		child.modulate =  color_for_cover(child, false)

	show_highlight()

func color_for_cover(child, show : bool) -> Color:
		if not show and child is Label:
			return Color(1.0, 1.0, 1.0, 0.0)

		if show and child is Label:
			return Color(1.0, 1.0, 1.0, 1.0)

		if not show:
			return Color(0.0, 0.0, 0.0, 0.0)

		return Color(0.0, 0.0, 0.0, 0.5)

func show_highlight() -> void:
	var tween = get_tree().create_tween()

	for child in _highlight_turns.get_children():
		tween.parallel().tween_property(child, "modulate", color_for_cover(child, true), 1)

func hide_highlight() -> void:
	var tween = get_tree().create_tween()

	for child in _highlight_turns.get_children():
		tween.parallel().tween_property(child, "modulate", color_for_cover(child, false), 1)

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
	path.call_deferred("add_child", vehicle)
	vehicle.call_deferred("set_offset", 0)
	vehicle.call_deferred("flip")

func _on_top_indicator_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			hide_highlight()

			if is_top_open:
				is_top_open = false
				_top_indicator.texture = Constants.turn_down_image
			else:
				is_top_open = true
				_top_indicator.texture = Constants.turn_left_image

func _on_middle_indicator_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			hide_highlight()

			if is_middle_open:
				is_middle_open = false
				_middle_indicator.texture = Constants.turn_down_image
			else:
				is_middle_open = true
				_middle_indicator.texture = Constants.turn_left_image

func _on_bottom_indicator_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			hide_highlight()

			if is_bottom_open:
				is_bottom_open = false
				_bottom_indicator.texture = Constants.turn_right_image
			else:
				is_bottom_open = true
				_bottom_indicator.texture = Constants.turn_left_image
