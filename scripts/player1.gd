extends CharacterBody2D

var active: bool = false
const SPEED = 130.0
const JUMP_VELOCITY = -200.0

var is_rolling: bool = false
var can_roll: bool = true

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

func set_active(a: bool) -> void:
	active = a
	if $Camera2D:
		$Camera2D.enabled = active
	if animated_sprite:
		if active:
			animated_sprite.play("idle")
		else:
			animated_sprite.stop()

func _physics_process(delta: float) -> void:
	if not active and is_on_floor():
		animated_sprite.play("idle")
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_rolling:
		move_and_slide()
		return
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction : -1 , 0 , 1
	var direction := Input.get_axis("left", "right")
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if Input.is_action_just_pressed("roll") and is_on_floor() and can_roll:
		_start_roll(direction)
		
	move_and_slide()
		
func _start_roll(direction: float) -> void:
	var dir := direction
	if dir == 0:
		dir = -1.0 if animated_sprite.flip_h else 1.0

	# kickoff roll
	is_rolling = true
	can_roll = false
	animated_sprite.play("roll") 

	velocity.x = dir * SPEED * 1.1

	var roll_timer := get_tree().create_timer(.55)
	roll_timer.timeout.connect(Callable(self, "_on_roll_finished"))

func _on_roll_finished() -> void:
	is_rolling = false
	var cooldown_timer := get_tree().create_timer(0.3)
	cooldown_timer.timeout.connect(Callable(self, "_on_roll_cooldown_finished"))

func _on_roll_cooldown_finished() -> void:
	can_roll = true
