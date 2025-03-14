extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fall()
	
func fall():
	$AnimationPlayer.play("fall")
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play("fade")
	print("+1 apples")
	await get_tree().create_timer(0.3).timeout
	queue_free()
