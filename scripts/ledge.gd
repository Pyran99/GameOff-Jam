extends StaticBody2D
class_name Ledge

signal jumped_to
var can_jump_to: bool = false


func _ready() -> void:
#	jumped_to.connect(get_tree().get_first_node_in_group("Player").move_to_ledge)
	pass


func _on_mouse_entered() -> void:
	can_jump_to = true


func _on_mouse_exited() -> void:
	can_jump_to = false


func get_can_jump_to() -> bool:
	return can_jump_to
