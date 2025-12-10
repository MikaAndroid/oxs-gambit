extends StaticBody2D

@onready var collision_shape = $CollisionShape2D
@onready var sprite = $Sprite2D

func open():
	# Matikan collision agar bisa dilewati
	collision_shape.set_deferred("disabled", true)
	
	# Visual feedback: buat transparan atau ganti sprite jadi pintu terbuka
	# Opsi 1: Buat agak transparan
	sprite.modulate.a = 0.5
	
func close():
	# Nyalakan kembali collision
	collision_shape.set_deferred("disabled", false)
	
	# Kembalikan visual seperti semula
	sprite.modulate.a = 1.0
	
	print("Pintu Tertutup")
