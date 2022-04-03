extends Node

const turn_color_closed := Color("#ff000280")
const turn_color_open := Color("#00ff3680")

@export var music_streams : Array[AudioStream] = []

@export var credits_scene : PackedScene
@export var play_scene : PackedScene
@export var settings_scene : PackedScene
@export var welcome_scene : PackedScene

enum screens {
	none,
	credits,
	play,
	settings,
	welcome,
}

@onready var screens_scenes := {
	screens.credits : credits_scene,
	screens.settings : settings_scene,
	screens.play : play_scene,
	screens.welcome : welcome_scene,
}

const save_file_path := "user://toot_toot.save"
const save_file_key := "zUG!fQ}yw^ZGXDr#EiVK}q-r"
