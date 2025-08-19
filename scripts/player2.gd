extends CharacterBody2D

var active: bool = false
const SPEED = 150.0
const JUMP_VELOCITY = -200.0

func set_active(a: bool) -> void:
	active = a
	if $Camera2D:
		$Camera2D.enabled = active
	if $AnimatedSprite2D:
		if active:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.stop()

func _physics_process(delta: float) -> void:
	if not active and is_on_floor():
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
