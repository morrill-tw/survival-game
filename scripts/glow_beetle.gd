extends CharacterBody2D

@export var speed: float = 15  # Movement speed
@export var change_direction_time: float = 1.5  # Time before changing direction
var carapace = preload("res://scenes/carapace_collectable.tscn")

@export var item: InvItem

var direction: Vector2 = Vector2.ZERO
var time_until_change: float = 0.0

func _ready():
	pick_new_direction()

func _physics_process(delta):
	time_until_change -= delta
	if time_until_change <= 0:
		pick_new_direction()
	
	velocity = direction * speed
	move_and_slide()
	
	play_anim()

func pick_new_direction():
	# Choose a random direction (Up, Down, Left, Right)
	var directions = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	direction = directions[randi() % directions.size()]
	
	# Set time for next direction change
	time_until_change = change_direction_time
	
func play_anim():
	if direction.y == -1:
		$AnimatedSprite2D.play("n_walk")
	if direction.x == 1:
		$AnimatedSprite2D.play("e_walk")
	if direction.y == 1:
		$AnimatedSprite2D.play("s_walk")
	if direction.x == -1:
		$AnimatedSprite2D.play("w_walk")
		
func die():
	call_deferred("drop_carapace")
	queue_free()
	
func drop_carapace():
	var carapace_instance = carapace.instantiate()
	carapace_instance.global_position = $Marker2D.global_position
	get_parent().add_child(carapace_instance)
