extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 300
@export var push_force = 15.0
@export var pickup_radius = 100.0 # Seberapa jauh box bisa melayang dari player
var held_object: RigidBody2D = null # Menyimpan objek yang sedang dipegang

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 500:
			velocity.y = 500

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = -jump_force

	var horizontal_direction = Input.get_axis("move_left","move_right")
	velocity.x = speed * horizontal_direction
	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		# Jika yang ditabrak adalah RigidBody2D (Box)
		if collider is RigidBody2D:
			# Berikan gaya dorong berlawanan dengan arah normal tabrakan
			# Kita hanya ambil komponen X agar tidak mendorong ke bawah (lantai)
			var push_direction = -collision.get_normal()
			# Terapkan gaya hanya pada sumbu horizontal agar box tidak terbang aneh
			collider.apply_central_impulse(Vector2(push_direction.x * push_force, 0))

	if held_object != null:
			# Hitung posisi mouse
		var target_pos = get_global_mouse_position()

			# Hitung vektor jarak dari Player ke Mouse
		var direction_to_mouse = target_pos - global_position

			# Batasi jaraknya dengan radius (Clamping)
		if direction_to_mouse.length() > pickup_radius:
			target_pos = global_position + direction_to_mouse.normalized() * pickup_radius

			# Pindahkan objek yang dipegang ke posisi target
			held_object.global_position = target_pos

	Global.plr_pos = self.global_position
	#print(velocity)

func _input(event):
		# Cek apakah event adalah klik kiri mouse (Mouse Button Left)
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			cast_ray_to_mouse()

		

func cast_ray_to_mouse():
		# 1. Ambil state physics dunia game saat ini
		var space_state = get_world_2d().direct_space_state

		# 2. Tentukan titik awal (Player) dan titik tujuan (Mouse)
		var start_pos = global_position
		var end_pos = get_global_mouse_position()

		# 3. Buat parameter query untuk raycast
		var query = PhysicsRayQueryParameters2D.create(start_pos, end_pos)

		# PENTING: Agar raycast tidak menabrak diri sendiri (Player), kita exclude diri sendiri
		query.exclude = [self]

		# 4. Tembakkan raycast!
		var result = space_state.intersect_ray(query)

		# 5. Cek hasil tabrakan
		if result:
			# 'result.collider' adalah objek yang tertabrak raycast
			var object_hit = result.collider

			# Cek apakah objek tersebut punya fungsi 'toggle_size' (berarti itu Box)
			if object_hit.has_method("toggle_size"):
				object_hit.toggle_size()
				print("Box terkena raycast!")
