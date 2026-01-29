extends Area2D

@export var gravitational_constant := 1.0
@export var min_distance := 40.0
@export var max_force := 44000.0

@onready var planet := get_parent()

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			var dir := global_position.direction_to(body.global_position)
			var distance := global_position.distance_to(body.global_position)
			distance = max(distance, min_distance)

			var force = gravitational_constant * planet.mass / (distance)
			force = min(force, max_force)
			#print(force)
			#print(dir*force)

			body.apply_central_force(-dir * force)
