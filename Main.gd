extends Node2D

onready var enemy = load("res://Enemy.tscn")
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_EnemySpawn_timeout():
	var NewEnemy = enemy.instance()
	NewEnemy.global_position = $Position2D.global_position
	NewEnemy.is_enemy = true
	self.add_child(NewEnemy)


func _on_DespawnArea_body_entered(body):
	if  body.is_in_group("viking"):
		body.queue_free()
