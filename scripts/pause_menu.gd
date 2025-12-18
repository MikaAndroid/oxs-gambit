extends CanvasLayer

@onready var resume_btn = $VBoxContainer/ResumeButton # Sesuaikan path node
@onready var restart_btn = $VBoxContainer/RestartButton
@onready var quit_btn = $VBoxContainer/QuitButton

func _ready():
	# Sembunyikan menu saat awal game
	visible = false
	
	# Hubungkan sinyal tombol jika belum dilakukan lewat editor
	# (Anda juga bisa menghubungkan sinyal pressed() via tab Node secara manual)
	
func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	# Balikkan status pause (jika true jadi false, jika false jadi true)
	get_tree().paused = not get_tree().paused
	
	# Tampilkan/Sembunyikan menu sesuai status pause
	visible = get_tree().paused
	
	# Opsional: Tampilkan/Sembunyikan mouse cursor
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		# Sesuaikan dengan mode game Anda (Visible atau Captured)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE 

func _on_resume_button_pressed():
	toggle_pause()

func _on_restart_button_pressed():
	toggle_pause() # Unpause dulu sebelum reload agar tidak stuck
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().quit()
