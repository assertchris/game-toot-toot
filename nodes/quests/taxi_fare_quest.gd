extends GameQuest

@onready var _sprite := $Sprite

func _ready() -> void:
	_sprite.position.x += 32
	_sprite.playing = false

func show() -> void:
	_sprite.playing = true

	var tween = get_tree().create_tween()
	tween.tween_property(_sprite, "position", Vector2(0, -4), 2)

	await tween.finished

	_sprite.playing = false

	super.show()
