extends GameScreen

@export var level_scene : PackedScene

@onready var _anchor := $Center/Anchor

func _ready() -> void:
	var new_level := level_scene.instantiate()
	_anchor.add_child(new_level)
