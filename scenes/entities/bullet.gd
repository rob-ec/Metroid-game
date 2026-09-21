extends Area2D

var direction: Vector2
@export var speed: float = 200.0

func setup(pos: Vector2, dir: Vector2):
	position = pos
	direction = dir

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2.ONE, 0.5).from(Vector2.ZERO)


func _physics_process(delta: float) -> void:
	position += speed * direction * delta
