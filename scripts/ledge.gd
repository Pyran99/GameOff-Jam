extends StaticBody2D

signal jumped_to
var can_jump_to: bool = false


func _ready() -> void:
	jumped_to.connect(get_tree().get_first_node_in_group("Player").move_to_ledge)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		# jump to ledge
		if can_jump_to:
			print("jumped to ledge")
			jumped_to.emit()
		


func _on_mouse_entered() -> void:
	can_jump_to = true


func _on_mouse_exited() -> void:
	can_jump_to = false
