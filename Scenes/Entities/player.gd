extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var SPEED := 300.0
@export var JUMP_VELOCITY := 400.0
@export var MAX_JUMPS := 2

enum State { IDLE, RUN, JUMP, FALL, DOUBLE_JUMP, HIT }

var state: State = State.IDLE
var jumps_left := MAX_JUMPS
var hit_locked := false

func _physics_process(delta: float) -> void:
	if hit_locked:
		_apply_gravity(delta)
		move_and_slide()
		return

	_apply_gravity(delta)
	_handle_jump()
	_handle_move()
	_update_state()
	_play_animation()

	move_and_slide()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps_left = MAX_JUMPS

func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and jumps_left > 0:
		velocity.y = -JUMP_VELOCITY
		jumps_left -= 1

func _handle_move() -> void:
	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		sprite.flip_h = direction < 0
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _update_state() -> void:
	if hit_locked:
		state = State.HIT
		return

	if not is_on_floor():
		if velocity.y < 0:
			state = State.JUMP if jumps_left == MAX_JUMPS - 1 else State.DOUBLE_JUMP
		else:
			state = State.FALL
	else:
		if abs(velocity.x) > 0:
			state = State.RUN
		else:
			state = State.IDLE

func _play_animation() -> void:
	match state:
		State.IDLE:
			sprite.play("idle")
		State.RUN:
			sprite.play("run")
		State.JUMP:
			sprite.play("jump")
		State.DOUBLE_JUMP:
			sprite.play("double-jump")
		State.FALL:
			sprite.play("fall")
		State.HIT:
			sprite.play("hit")

func take_hit() -> void:
	hit_locked = true
	state = State.HIT
	sprite.play("hit")
	await sprite.animation_finished
	hit_locked = false


func death(body: Node2D) -> void:
	pass # Replace with function body.
