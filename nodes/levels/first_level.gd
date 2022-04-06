extends GameLevel

@export var vehicle_scenes : Array[PackedScene] = []
@export var quest_scenes : Array[PackedScene] = []

@export var turn_stream : AudioStream

@onready var _camera := $Camera
@onready var _entrance_path := $Paths/Entrance
@onready var _top_path := $Paths/Top
@onready var _middle_path := $Paths/Middle
@onready var _bottom_path := $Paths/Bottom
@onready var _top_indicator := $Turns/Top/Indicator
@onready var _middle_indicator := $Turns/Middle/Indicator
@onready var _bottom_indicator := $Turns/Bottom/Indicator
@onready var _highlight_turns := $HighlightTurns
@onready var _highlight_quest := $HighlightQuest
@onready var _quest_positions := $QuestPositions
@onready var _quests := $Quests
@onready var _tutorial_quest_position := $TutorialQuestPosition
@onready var _quest_spawn_timer := $QuestSpawnTimer

var is_top_open := false
var is_middle_open := false
var is_bottom_open := false
var tutorial_quest : GameQuest

enum tutorial_states {
	not_started,
	highlighting_turns,
	highlighting_quest,
	done,
	skip,
}

var tutorial_state := tutorial_states.not_started

var quests := {}

func _ready() -> void:
	_top_indicator.texture = Constants.turn_down_image
	_middle_indicator.texture = Constants.turn_down_image
	_bottom_indicator.texture = Constants.turn_right_image

	for i in range(_quest_positions.get_child_count()):
		quests[i] = null

	_camera.current = true

	for child in _highlight_turns.get_children():
		child.modulate =  color_for_cover(child, false)

	for child in _highlight_quest.get_children():
		child.modulate =  color_for_cover(child, false)

	_highlight_turns.visible = true
	_highlight_quest.visible = true
	progress_tutorial()

func spawn_quest(spawn_position : Position2D) -> GameQuest:
	var new_quest = quest_scenes[randi() % quest_scenes.size()].instantiate()
	_quests.add_child(new_quest)
	new_quest.global_position = spawn_position.global_position
	new_quest.show()

	return new_quest

func color_for_cover(child, will_show : bool) -> Color:
		if not will_show and child is Label:
			return Color(1.0, 1.0, 1.0, 0.0)

		if will_show and child is Label:
			return Color(1.0, 1.0, 1.0, 1.0)

		if not will_show:
			return Color(0.0, 0.0, 0.0, 0.0)

		return Color(0.0, 0.0, 0.0, 0.75)

func show_turn_highlight() -> void:
	var tween = get_tree().create_tween()

	for child in _highlight_turns.get_children():
		tween.parallel().tween_property(child, "modulate", color_for_cover(child, true), 1)

func hide_turn_highlight() -> void:
	var tween = get_tree().create_tween()

	for child in _highlight_turns.get_children():
		tween.parallel().tween_property(child, "modulate", color_for_cover(child, false), 1)

func show_quest_highlight() -> void:
	var tween = get_tree().create_tween()

	for child in _highlight_quest.get_children():
		tween.parallel().tween_property(child, "modulate", color_for_cover(child, true), 1)

func hide_quest_highlight() -> void:
	var tween = get_tree().create_tween()

	for child in _highlight_quest.get_children():
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
	var new_vehicle := vehicle_scenes[randi() % vehicle_scenes.size()].instantiate() as GameVehicle
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
			Audio.play_sound(turn_stream)

			if tutorial_state == tutorial_states.highlighting_turns:
				progress_tutorial()

			if is_top_open:
				is_top_open = false
				_top_indicator.texture = Constants.turn_down_image
			else:
				is_top_open = true
				_top_indicator.texture = Constants.turn_left_image

func _on_middle_indicator_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			Audio.play_sound(turn_stream)

			if tutorial_state == tutorial_states.highlighting_turns:
				progress_tutorial()

			if is_middle_open:
				is_middle_open = false
				_middle_indicator.texture = Constants.turn_down_image
			else:
				is_middle_open = true
				_middle_indicator.texture = Constants.turn_left_image

func _on_bottom_indicator_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			Audio.play_sound(turn_stream)

			if tutorial_state == tutorial_states.highlighting_turns:
				progress_tutorial()

			if is_bottom_open:
				is_bottom_open = false
				_bottom_indicator.texture = Constants.turn_right_image
			else:
				is_bottom_open = true
				_bottom_indicator.texture = Constants.turn_left_image

func progress_tutorial() -> void:
	if tutorial_state == tutorial_states.skip:
		return

	match tutorial_state:
		tutorial_states.not_started:
			tutorial_state = tutorial_states.highlighting_turns

			show_turn_highlight()

		tutorial_states.highlighting_turns:
			tutorial_state = tutorial_states.highlighting_quest

			hide_turn_highlight()

			await get_tree().create_timer(2.5).timeout
			tutorial_quest = spawn_quest(_tutorial_quest_position)

			tutorial_quest.did_complete.connect(
				func(that):
					that.hide_quest_highlight()
					that._quest_spawn_timer.start()
			.bind(self))

			await tutorial_quest.did_show
			progress_tutorial()

		tutorial_states.highlighting_quest:
			tutorial_state = tutorial_states.done

			await get_tree().create_timer(1.0).timeout
			show_quest_highlight()

		tutorial_states.done:
			hide_quest_highlight()

func _on_quest_spawn_timer_timeout() -> void:
	var has_slot := false

	for quest in quests:
		if quests[quest] == null:
			has_slot = true

	if not has_slot:
		return

	var index = randi() % _quest_positions.get_child_count()

	while quests[index] != null:
		index = randi() % _quest_positions.get_child_count()

	quests[index] = spawn_quest(_quest_positions.get_child(index))

	quests[index].did_complete.connect(
		func(that): that.quests[index] = null
	.bind(self))
