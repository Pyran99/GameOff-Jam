extends CharacterBody2D

var can_powerup: bool = false
var current_pos: Vector2
var target_pos: Vector2

@export var reach_range: int

@onready var reach_collision: CollisionShape2D = $ReachRange/CollisionShape2D


func _ready() -> void:
	reach_collision.shape.radius = reach_range


func _physics_process(delta: float) -> void:
	# move from current pos to new pos
	
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("RightClick"):
		# activate powerup
		if can_powerup:
			print("activate powerup")
		else:
			print("powerup not available")


func _draw() -> void:
	var center = Vector2.ZERO
	var radius = reach_range
	var angle_from = 0
	var angle_to = 360
	var color = Color(randi())
	color.a = 1
	draw_arc(center, radius, angle_from, angle_to, 32, color, 2)


func move_to_ledge():
	print("move player to ledge")
	current_pos = global_position
	pass
