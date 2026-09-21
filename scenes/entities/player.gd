extends CharacterBody2D


@export var SPEED: float = 300.0
@export var JUMP_VELOCITY: float = -400.0
@export var MARKER_RANGE: float = 80.0

var direction: float
signal shoot(pos: Vector2, dir: Vector2)

const gun_directions = {
	Vector2i(1,0):		0, # EAST
	Vector2i(1,1):		1, # NORTHEAST
	Vector2i(0,1):		2, # NORTH
	Vector2i(-1,1):		3, # NORTHWEST
	Vector2i(-1,0):		4, # WEST
	Vector2i(-1,-1):	5, # SOUTHWEST
	Vector2i(0,-1):		6, # SOUTH
	Vector2i(1,-1):		7, # SOUTHEST
}

func update_marker() -> void:
	$Marker.position = get_local_mouse_position().normalized() * MARKER_RANGE

func animation() -> void:
	update_marker()
	$Legs.flip_h = direction < 0
	if is_on_floor():
		$AnimationPlayer.current_animation = 'run' if direction else 'idle'
	else:
		$AnimationPlayer.current_animation = 'jump'
	
	var raw_dir := get_local_mouse_position().normalized()
	var adjusted_dir := Vector2i(round(raw_dir.x), round(raw_dir.y))
	
	$Torso.frame = gun_directions[adjusted_dir]

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle shoot
	if Input.is_action_just_pressed("shoot") and $ReloadTimer.time_left == 0:
		shoot.emit(position, get_local_mouse_position().normalized())
		$ReloadTimer.start()
		var tween := get_tree().create_tween()
		tween.tween_property($Marker, "scale", Vector2(0.1, 0.1), 0.2)
		tween.tween_property($Marker, "scale", Vector2(0.5, 0.5), 0.4)

	move_and_slide()
	animation()
