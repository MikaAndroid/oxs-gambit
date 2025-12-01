extends Node

## VARIABLES
var player_speed: Vector2
var player_direction: Vector2
var boxes_array: Array
var plr_pos: Vector2

@onready var music_player = $AudioStreamPlayer

#const TITLE_THEME = preload("res://Music/Lucky-Mallet-Title-theme-01.wav")
#const LUCKY_MALLET_THEME = preload("res://Music/Lucky-Mallet-theme.wav")
#const LUCKY_MALLET_THEME = preload("res://Music/Lucky-Mallet-theme-01.wav")
func _on_audio_stream_player_finished():
	music_player.play()
