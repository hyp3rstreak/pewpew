extends RigidBody2D

@onready var animator: AnimatedSprite2D = $AnimatedSprite2D
@onready var bulletTimer: Timer = $bulletTimer
@onready var bulletRelease: Marker2D = $Marker2D
@export var bulletScene: PackedScene
@export var thrust_force := 300.0
@export var rotation_speed := 2.0
@export var max_speed := 600.0
@export var linear_drag := 0.98

#const SPEED = 30
var dir := "up"
var canShoot := true
var inLandingZone := false
var bulletSpeed := 600

# Called when the node enters the scene tree for the  first time.
func _ready() -> void:
	mass = .5

func _physics_process(delta):
	# --- Rotation ---
	var turn := 0.0
	if Input.is_action_pressed("left"):
		dir = "left"
		turn -= 1.0
	if Input.is_action_pressed("right"):
		dir = "right"
		turn += 1.0
	
	angular_velocity = turn * rotation_speed

	# --- Thrust ---
	if Input.is_action_pressed("up"):
		var forward := Vector2.RIGHT.rotated(rotation)
		apply_central_force(forward * thrust_force)
		dir = "up"

	if Input.is_action_pressed("down"):
		apply_central_force(-linear_velocity * 8)
		dir = "down"
		
	if Input.is_action_pressed("interact"):
		print(safeLanding())
		if safeLanding():
			print("touchdown!")
	

	# --- Manual drag ---
	linear_velocity *= linear_drag

	# --- Clamp speed ---
	if linear_velocity.length() > max_speed:
		linear_velocity = linear_velocity.normalized() * max_speed
		
	if Input.is_action_pressed("shoot"):
		_bulletShoot()
		
	_updateAnim(dir)

func safeLanding() -> bool:
	return linear_velocity.length() < 5.0

func _bulletShoot():
	#print("pew pew")
	if canShoot:
		bulletTimer.start()
		
		var bullet = bulletScene.instantiate()		
		var dir = Vector2.RIGHT.rotated(rotation)		
		bullet.global_position = bulletRelease.global_position
		bullet.rotation - rotation
		bullet.direction = dir
		bullet.speed += linear_velocity.length()
		
		#bullet.linear_velocity = dir * bulletSpeed
		
		
		#bullet.direction = -bulletRelease.global_transform.y
		#bullet.speed = bulletSpeed
		#print(bulletRelease.global_position)
		
		get_tree().current_scene.add_child(bullet)
	canShoot = false
	
func _updateAnim(dir):
	#print("animator.play(",dir,")")
	#animator.play(dir)
	#print(velocity)
	pass

func _on_bullet_timer_timeout() -> void:
	canShoot = true
