extends Node2D

var bullet_scene: PackedScene = preload("res://scenes/entities/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_shoot(pos: Vector2, dir: Vector2) -> void:
	var bullet := bullet_scene.instantiate() as Area2D
	var tween := get_tree().create_tween()
	bullet.setup(pos, dir)
	tween.tween_property(bullet, 'scale', Vector2(0.5, 0.5), 0.2)
	tween.tween_property(bullet, 'scale', Vector2(0.8, 0.8), 0.4)
	$Bullets.add_child(bullet)
	
