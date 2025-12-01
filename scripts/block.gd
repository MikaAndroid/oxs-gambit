extends RigidBody2D


## POSITIVE FOR SMALL, NEGATIVE FOR LARGE.
@export var box_type := 1

@onready var collision_shape_2d = $CollisionShape2D
#@onready var indicator_color = $CollisionShape2D/Colors/IndicatorColor
#@onready var colors = $CollisionShape2D/Colors

## SIZE MULTIPLIER FOR SMALL BOX
@export var size_small: Vector2

## SIZE MULTIPLIER FOR LARGE BOX
@export var size_large: Vector2

## DEFAULT SIZE
@export var size_default: Vector2 = Vector2(18, 18)

## DEFAULT MASS. USES SIZE MULTIPLIER X VALUE
@export var mass_default: float = 0.5


func _ready():
	Global.boxes_array.append(self)
	self.mass = mass_default
	size_properties()

func _on_area_2d_area_entered(_area):
	box_type *= -1
	size_properties()

#func _process(delta):
	#self.global_position = Global.plr_pos

func size_properties():
	if box_type > 0: # for small box
		#indicator_color.color = Color(0, 1, 0)
		#colors.scale = size_small
		collision_shape_2d.shape.size = size_default * size_small
		self.mass = mass_default * size_small.x

	elif box_type < 0: # for large box
		#indicator_color.color = Color(1, 0, 0)
		#colors.scale = size_large
		collision_shape_2d.shape.size = size_default * size_large
		self.mass = mass_default * size_large.x
