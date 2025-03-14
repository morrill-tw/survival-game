extends StaticBody2D

@export var item: InvItem
var player = null

func _ready():
	$AnimationPlayer.play("drop")
	$InteractableArea.set_deferred("monitoring", false) 
	await get_tree().create_timer(0.4).timeout
	$InteractableArea.set_deferred("monitoring", true) 

func _on_interactable_area_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player = body
		player_collect()
		await get_tree().create_timer(0.1).timeout
		self.queue_free()
		
func player_collect():
	player.collect(item)
