extends Area2D
class_name GameQuest

signal did_show
signal did_complete

@export var quest_type : ConstantsScript.quest_types

func show() -> void:
	did_show.emit()

func _on_quest_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()

	if parent is GameVehicle and parent.quest_type == quest_type and not parent.has_completed_quest:
		parent.has_completed_quest = true
		did_complete.emit()
		queue_free()
