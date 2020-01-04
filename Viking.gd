extends KinematicBody2D


const GRAVITY = 20
var velocity = Vector2()
var state = "none"
var initial_collision = true
#var state_list = {'bash': 'shield', 'shield': 'strike', 'strike': 'bash', 'none': ''}
var state_index = {'bash': 0, 'shield': 1, 'strike': 2, 'none': 3}
var state_matrix = [[0, 1, -1, 1], [-1, 0, 1, 1], [1, -1, 0, 1], [-1, -1, -1, 0]]
var is_enemy = false

func _ready():
	if is_enemy:
		$Attack.start()
		$Body.self_modulate = Color(214/255, 1, 84/255, 1)
	set_physics_process(true)


func _physics_process(delta):
	velocity.y += GRAVITY
	
	move_and_slide(velocity, Vector2(0, 1))

func bash():
	state = "bash"
	if is_enemy:
		$AnimationPlayer.play("Bash_enemy")
		yield(get_tree().create_timer(1.0), "timeout")
	else:
		$AnimationPlayer.play("Bash")
	velocity.y = -500

func strike():
	state = "strike"
	if is_enemy:
		$AnimationPlayer.play("AxeSwing_enemy")
	else:
		$AnimationPlayer.play("AxeSwing")

func shield():
	state = "shield"
	if is_enemy:
		$AnimationPlayer.play("ShieldUp_enemy")
	else:
		$AnimationPlayer.play("ShieldUp")


func _on_HitBox_body_entered(body):
	if body.name != "Ground":
		#print('\nbody ', body.name)
		#print('\nbody ', body.state)
		#print('self ', self.name, self.state)
		print(self.name, ' colliding with ', body.name, ", ", self.state, " vs. ", body.state)
		var conflict_score = state_matrix[state_index[self.state]][state_index[body.state]]
		if initial_collision:
			initial_collision = false
		#elif (body.state == self.state) and (self.name != body.name):
		#	#print(' . ', self.name, ' tie animation')
		elif conflict_score == 1:
			print('win')
		elif conflict_score == -1:
			print('lose')
			die()
		else:
			print('tie')
			tie()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Die" and not is_enemy:
		print('reduce score')
	state = "none"

func die():
	$AnimationPlayer.play("Die")
	if not is_enemy:
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().reload_current_scene()
	#$CollisionShape2D.disabled = true
	#$HitBox/CollisionShape2D.disabled = true
	$Die.play()

func tie():
	#state = "tie"
	$AnimationPlayer.play("Tie")
	$Die.play()


func _on_Attack_timeout():
	var attack_idx = randi()%3
	$Jump.play()
	if attack_idx == 0:
		bash()
	elif attack_idx == 1:
		shield()
	elif attack_idx == 2:
		strike()
