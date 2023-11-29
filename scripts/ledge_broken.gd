extends Ledge
class_name LedgeBroken

@export var break_count: int
var max_breaks: int = 2


func increase_break_count() -> void:
	break_count += 1
	if break_count == 1:
		$Sprite2D.hide()
		$Sprite2D2.show()
		$Sprite2D3.hide()
	if break_count == 2:
		$Sprite2D.hide()
		$Sprite2D2.hide()
		$Sprite2D3.show()
	if break_count > 2:
		trigger_platform_break()


func trigger_platform_break() -> void:
	if break_count > 2:
		hide()
		set_process(false)


func show_platform() -> void:
	set_process(true)
	break_count = 0
	$Sprite2D.show()
	$Sprite2D2.hide()
	$Sprite2D3.hide()
	show()