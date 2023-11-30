extends Area2D

@export var upgrades_amount: int = 1


func _on_body_entered(body: Node2D) -> void:
	assert(body is Player)
	$AudioStreamPlayer2D.play()
	GameManager.increase_upgrade_points(upgrades_amount)
	get_tree().get_first_node_in_group("UI").set_upgrade_points_text()
	hide()


func _on_audio_stream_player_2d_finished() -> void:
	queue_free()
