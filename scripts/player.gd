extends CharacterBody2D

@export var speed = 80
var player_state
var attacking = false
var last_direction = Vector2(0, 1)
var punch

@export var inventory: Inventory

var bow_equipped = false
var bow_cooldown = true
var arrow = preload("res://scenes/arrow.tscn")
var mouse_loc_from_player = null

func _ready():
	punch = $Punch

func _physics_process(delta: float):
	mouse_loc_from_player = get_global_mouse_position() - self.position
	
	$KillBox.position.x = 0
	$KillBox.position.y = 0
	$KillBox.scale = Vector2(0.1, 0.1)
	
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction == Vector2.ZERO:
		player_state = "idle"
	else:
		last_direction = direction
		player_state = "walking"
			
	velocity = direction * speed
		
	move_and_slide()
	
	if Input.is_action_just_pressed("b"):
		if bow_equipped:
			bow_equipped = false
		else:
			bow_equipped = true
	
	var mouse_position = get_global_mouse_position()
	$Marker2D.look_at(mouse_position)
	
	if Input.is_action_just_pressed("left_mouse") and bow_equipped and bow_cooldown:
		bow_cooldown = false
		var arrow_instance = arrow.instantiate()
		arrow_instance.rotation = $Marker2D.rotation
		arrow_instance.global_position = $Marker2D.global_position
		print("arrow pos:" + str(arrow_instance.global_position))
		print("player pos: " + str(global_position))
		add_child(arrow_instance)
		
		await get_tree().create_timer(0.4).timeout
		bow_cooldown = true
		
	if Input.is_action_just_pressed("left_mouse") and !bow_equipped:
		attacking = true
		apply_punch_effect()
		punch.play()
		if last_direction.x > 0.5 and last_direction.y < -0.5:
			$KillBox.position.x = 10
			$KillBox.position.y = 0
		elif last_direction.x > 0.5 and last_direction.y > 0.5:
			$KillBox.position.x = 10
			$KillBox.position.y = 0
		elif last_direction.x < -0.5 and last_direction.y < -0.5:
			$KillBox.position.x = -10
			$KillBox.position.y = 0
		elif last_direction.x < -0.5 and last_direction.y > 0.5:
			$KillBox.position.x = -10
			$KillBox.position.y = 0
		elif last_direction.y == -1:
			$KillBox.position.x = 0
			$KillBox.position.y = -15
		elif last_direction.y == 1:
			$KillBox.position.x = 0
			$KillBox.position.y = 15
		elif last_direction.x == -1:
			$KillBox.position.x = -10
			$KillBox.position.y = 0
		elif last_direction.x == 1:
			$KillBox.position.x = 10
			$KillBox.position.y = 0
		$KillBox.scale = Vector2(1, 1)
			
	
	
	play_anim(direction)

func apply_punch_effect():
	$Camera2D.position.x = 1
	$Camera2D.position.y = 1
	await get_tree().create_timer(0.1).timeout
	$Camera2D.position.x = -1
	$Camera2D.position.y = -1
	await get_tree().create_timer(0.1).timeout
	$Camera2D.position.x = 0
	

func play_anim(dir):
	if attacking:
		if last_direction.x > 0.5 and last_direction.y < -0.5:
			$AnimatedSprite2D.play("e_punch")
		elif last_direction.x > 0.5 and last_direction.y > 0.5:
			$AnimatedSprite2D.play("e_punch")
		elif last_direction.x < -0.5 and last_direction.y < -0.5:
			$AnimatedSprite2D.play("w_punch")
		elif last_direction.x < -0.5 and last_direction.y > 0.5:
			$AnimatedSprite2D.play("w_punch")
		elif last_direction.y == -1:
			$AnimatedSprite2D.play("n_punch")
		elif last_direction.y == 1:
			$AnimatedSprite2D.play("s_punch")
		elif last_direction.x == -1:
			$AnimatedSprite2D.play("w_punch")
		elif last_direction.x == 1:
			$AnimatedSprite2D.play("e_punch")
		await $AnimatedSprite2D.animation_finished
		attacking = false
	elif !bow_equipped:
		speed = 100
		if player_state == "idle":
			if last_direction.x > 0.5 and last_direction.y < -0.5:
				$AnimatedSprite2D.play("e_idle")
			elif last_direction.x > 0.5 and last_direction.y > 0.5:
				$AnimatedSprite2D.play("e_idle")
			elif last_direction.x < -0.5 and last_direction.y < -0.5:
				$AnimatedSprite2D.play("w_idle")
			elif last_direction.x < -0.5 and last_direction.y > 0.5:
				$AnimatedSprite2D.play("w_idle")
			elif last_direction.y == -1:
				$AnimatedSprite2D.play("n_idle")
			elif last_direction.y == 1:
				$AnimatedSprite2D.play("s_idle")
			elif last_direction.x == -1:
				$AnimatedSprite2D.play("w_idle")
			elif last_direction.x == 1:
				$AnimatedSprite2D.play("e_idle")
		if player_state == "walking":
			if dir.y == -1:
				$AnimatedSprite2D.play("n_walk")
			if dir.x == 1:
				$AnimatedSprite2D.play("e_walk")
			if dir.y == 1:
				$AnimatedSprite2D.play("s_walk")
			if dir.x == -1:
				$AnimatedSprite2D.play("w_walk")
			if dir.x > 0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("e_walk")
			if dir.x > 0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("e_walk")
			if dir.x < -0.5 and dir.y < -0.5:
				$AnimatedSprite2D.play("w_walk")
			if dir.x < -0.5 and dir.y > 0.5:
				$AnimatedSprite2D.play("w_walk")
	elif bow_equipped:
		speed = 0
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y < 0:
			$AnimatedSprite2D.play("n_attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x > 0:
			$AnimatedSprite2D.play("e_attack")
		if mouse_loc_from_player.x >= -25 and mouse_loc_from_player.x <= 25 and mouse_loc_from_player.y > 0:
			$AnimatedSprite2D.play("s_attack")
		if mouse_loc_from_player.y >= -25 and mouse_loc_from_player.y <= 25 and mouse_loc_from_player.x < 0:
			$AnimatedSprite2D.play("w_attack")
			
		if mouse_loc_from_player.x >= 25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("ne_attack")
		if mouse_loc_from_player.x >= 0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("se_attack")
		if mouse_loc_from_player.x <= -0.5 and mouse_loc_from_player.y >= 25:
			$AnimatedSprite2D.play("sw_attack")
		if mouse_loc_from_player.x <= -25 and mouse_loc_from_player.y <= -25:
			$AnimatedSprite2D.play("nw_attack")
			
func player():
	pass
	
func collect(item):
	inventory.insert(item)
	


func _on_kill_box_body_entered(body: Node2D) -> void:
	if attacking:
		if (body.has_method("die")):
			body.die()
