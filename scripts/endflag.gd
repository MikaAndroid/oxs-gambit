extends Area2D

@export_file("*.tscn") var next_level_path: String

func _on_body_entered(body):
	# Cek apakah yang masuk adalah Player
	if body.name == "Player":
		if next_level_path == "" or next_level_path == null:
			print("Error: Path level selanjutnya belum diisi di Inspector!")
			return
			
		# Pindah ke scene level selanjutnya
		# Menggunakan call_deferred agar aman saat proses physics sedang berjalan
		call_deferred("change_level")

func change_level():
	get_tree().change_scene_to_file(next_level_path)
