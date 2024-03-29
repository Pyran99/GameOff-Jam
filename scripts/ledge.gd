@tool
extends StaticBody2D
class_name Ledge

signal jumped_to
var can_jump_to: bool = false

@export var target_pos: Marker2D

@onready var player: Player = (get_tree().get_first_node_in_group("Player") as Player)


func _ready() -> void:
	target_pos = $Marker2D
#	jumped_to.connect(get_tree().get_first_node_in_group("Player").move_to_ledge)
	pass


#func show_label() -> void:
#	$Label.show()
#
#func hide_label() -> void:
#	$Label.hide()

func _on_mouse_entered() -> void:
	can_jump_to = true
	player.set_usuable_icon(self)


func _on_mouse_exited() -> void:
	can_jump_to = false
	player.set_unusable_icon(self)


func get_can_jump_to() -> bool:
	return can_jump_to


func _draw() -> void:
	if Engine.is_editor_hint():
		var _center = Vector2.ZERO
		var radius = 400
		var angle_from = 0
		var angle_to = 360
		var color = Color(randi())
		color.a = 1
		draw_arc(target_pos.position, radius, angle_from, angle_to, 32, color, 2)
#	else:
#		var center = Vector2.ZERO
#		var radius = 400
#		var angle_from = 0
#		var angle_to = 360
#		var color = Color(randi())
#		color.a = 1
#		draw_arc(center, radius, angle_from, angle_to, 32, color, 2)
