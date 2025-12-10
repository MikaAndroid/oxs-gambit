extends Area2D

# Variabel untuk memilih pintu mana yang akan dibuka lewat Inspector
@export var door_to_open: StaticBody2D

# Menghitung berapa banyak box yang ada di atas pelat
var bodies_on_plate: int = 0

func check_plate_state():
	# Jika pintu belum di-assign di Inspector, jangan lakukan apa-apa
	if door_to_open == null:
		return

	# Jika ada setidaknya 1 box di atas pelat, buka pintu
	if bodies_on_plate > 0:
		door_to_open.open()
		# Opsional: Ganti sprite pelat jadi "tertekan"
		$Sprite2D.position.y = 2 # Geser sedikit ke bawah visualnya
	else:
		# Jika tidak ada box, tutup pintu
		door_to_open.close()
		# Opsional: Kembalikan sprite pelat jadi "naik"
		$Sprite2D.position.y = 0


func _on_body_entered(body: Node2D) -> void:
	if body is Box:
		bodies_on_plate += 1
		check_plate_state()	

func _on_body_exited(body: Node2D) -> void:
	if body is Box:
		bodies_on_plate -= 1
		check_plate_state()
