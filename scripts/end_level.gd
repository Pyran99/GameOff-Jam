extends Area2D


func _on_body_entered(body: Node) -> void:
	assert(body is Player)
	GameManager.game_win()
