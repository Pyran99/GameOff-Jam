extends CharacterBody2D


signal hooked

var can_move: bool = false
var is_moving: bool = false

var target_pos: Vector2

@onready var rope_point: Marker2D = $RopePoint
@onready var line: Line2D = $Line2D



func _ready() -> void:
	connect("hooked", get_tree().get_first_node_in_group("Player").hook_finished)
	set_can_move()
	set_line_on_click()
	look_at(target_pos)


func _process(_delta: float) -> void:
	if can_move:
		is_moving = true
		move_to_ledge()
	else:
		velocity = Vector2.ZERO
	
	if global_position.distance_to(target_pos) < 10:
		hooked.emit()
		can_move = false
	if global_position.distance_to(get_tree().get_first_node_in_group("Player").global_position) < 10:
		queue_free()
	
	if line.points.size() > 0:
		line.set_point_position(0, to_local(self.global_position))
		line.set_point_position(1, to_local(get_tree().get_first_node_in_group("Player").global_position))


func set_target_pos(pos: Vector2) -> void:
	target_pos = pos


func move_to_ledge() -> void:
	var distance_to_platform = target_pos - global_position
	
	velocity = distance_to_platform.normalized() * (PlayerStats.leap_speed * 3)
	move_and_slide()


func set_can_move() -> void:
	can_move = true


func set_line_on_click() -> void:
	if line.points.size() == 0:
		line.add_point(to_local(global_position))
		line.add_point(to_local(global_position))

