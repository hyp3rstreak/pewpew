extends Area2D

@export var speed := 900.0
@export var lifetime := 1.5

var direction := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	# Kill bullet after lifetime
	await get_tree().create_timer(lifetime).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	global_position += direction*speed*delta
