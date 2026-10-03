extends CharacterBody3D

const SPEED := 5.5
const GRAVITY := 18.0
var camera: Camera3D

func _ready():
    camera = get_meta("camera") as Camera3D

func _physics_process(delta):
    var input_vec := Vector2.ZERO
    if Input.is_key_pressed(KEY_A): input_vec.x -= 1
    if Input.is_key_pressed(KEY_D): input_vec.x += 1
    if Input.is_key_pressed(KEY_W): input_vec.y -= 1
    if Input.is_key_pressed(KEY_S): input_vec.y += 1
    if has_meta("mobile_input"):
        input_vec = get_meta("mobile_input")
    var dir = Vector3(input_vec.x, 0, input_vec.y).normalized()
    velocity.x = dir.x * SPEED
    velocity.z = dir.z * SPEED
    if not is_on_floor():
        velocity.y -= GRAVITY * delta
    else:
        velocity.y = 0
    if dir.length() > 0.1:
        rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), 0.12)
    move_and_slide()
