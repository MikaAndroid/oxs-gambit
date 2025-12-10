extends CharacterBody2D

@export var speed = 300
@export var gravity: float = 30
@export var jump_force = 300
@export var push_force = 15.0
var is_in_range: bool = false
var target_object: RigidBody2D
var held_object: RigidBody2D
var starting_position: Vector2
@onready var hand_position: Marker2D = $HandPosition
@export var hand_radius: float = 24.0 # Jarak HandPosition dari tengah Player

func _physics_process(delta):
	update_hand_position()
	
	if Input.is_action_just_pressed("pickup"):
		if held_object == null:
			pickup_object()
		else:
			drop_object()
	
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

	Global.plr_pos = self.global_position
	#print(velocity)

func _ready():
	# Simpan posisi awal saat game benar-benar dimulai
	starting_position = global_position
	# Tambahkan line ini agar Player masuk ke group "Player" (opsional, untuk deteksi lebih aman)
	add_to_group("Player")

func _input(event):
		# Cek apakah event adalah klik kiri mouse (Mouse Button Left)
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			cast_ray_to_mouse()

func pickup_object() -> void:
	if is_in_range:
		#if Input.is_action_just_pressed("pickup") and !held_object:
			held_object = target_object
			held_object.freeze = true
			held_object.reparent(hand_position)
			held_object.position = Vector2.ZERO
			

func drop_object() -> void:
	#if Input.is_action_just_pressed("drop") and held_object:
		held_object.reparent(get_parent())
		#held_object.position = position +Vector2.RIGHT * 50
		held_object.freeze = false
		held_object = null

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

func die() -> void:
	position = starting_position

func update_hand_position():
	# 1. Dapatkan posisi mouse di dunia game
	var mouse_pos = get_global_mouse_position()
	
	# 2. Hitung arah dari Player ke Mouse
	# global_position adalah posisi Player saat ini
	var direction = (mouse_pos - global_position).normalized()
	
	# 3. Set posisi HandPosition
	# Karena HandPosition adalah child dari Player, posisinya (0,0) adalah tengah Player.
	# Kita cukup set posisi lokalnya berdasarkan arah * radius.
	hand_position.position = direction * hand_radius

func _on_range_body_entered(body: Node2D) -> void:
	if body is Box:
		is_in_range = true
		target_object = body


func _on_range_body_exited(body: Node2D) -> void:
	if body is Box:
		is_in_range = false
		target_object = null


func _on_spike_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.die()
