extends Control

#signal start_game()
@export_file("*.tscn") var next_level_path: String
@onready var button_v_box = %ButtonsVBox


func _on_start_game_button_pressed() -> void:
	get_tree().change_scene_to_file(next_level_path)
	hide()
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func _on_visibility_changed() -> void:
	if button_v_box:
		var button: Button = button_v_box.get_child(0)
		if button is Button:
			button.grab_focus()
		
