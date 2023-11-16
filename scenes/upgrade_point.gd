extends Area2D




func _on_body_entered(body: Node2D) -> void:
	assert(body is Player)
	print("player picked up star")
	
	queue_free()
