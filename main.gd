extends Node3D

var player: CharacterBody3D
var challenges := []
var completed := 0
var score := 0
var status: Label

func _ready():
    _build_world()
    _build_player()
    _build_ui()

func _build_world():
    var env = WorldEnvironment.new()
    var e = Environment.new()
    e.background_mode = Environment.BG_COLOR
    e.background_color = Color(0.045, 0.065, 0.10)
    e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    e.ambient_light_color = Color(0.55, 0.62, 0.75)
    e.ambient_light_energy = 0.8
    env.environment = e
    add_child(env)

    var sun = DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-55, -25, 0)
    sun.light_energy = 1.2
    sun.shadow_enabled = true
    add_child(sun)

    var floor = StaticBody3D.new()
    var mesh = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = Vector3(70, 0.4, 70)
    mesh.mesh = box
    mesh.position.y = -0.2
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.10, 0.13, 0.18)
    box.material = mat
    floor.add_child(mesh)
    var shape = CollisionShape3D.new()
    var cs = BoxShape3D.new()
    cs.size = Vector3(70, 0.4, 70)
    shape.shape = cs
    shape.position.y = -0.2
    floor.add_child(shape)
    add_child(floor)

    for i in range(1, 13):
        var angle = float(i) * TAU / 12.0
        _make_challenge(i, Vector3(cos(angle) * 16.0, 1.0, sin(angle) * 16.0))

func _make_challenge(id: int, pos: Vector3):
    var body = StaticBody3D.new()
    body.position = pos
    var mesh = MeshInstance3D.new()
    var box = BoxMesh.new()
    box.size = Vector3(1.6, 2.0, 1.6)
    mesh.mesh = box
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.12, 0.32, 0.65)
    mat.emission_enabled = true
    mat.emission = Color(0.03, 0.12, 0.35)
    mat.emission_energy_multiplier = 1.5
    box.material = mat
    body.add_child(mesh)

    var collision = CollisionShape3D.new()
    var cs = BoxShape3D.new()
    cs.size = Vector3(1.6, 2.0, 1.6)
    collision.shape = cs
    body.add_child(collision)

    var label = Label3D.new()
    label.text = str(id)
    label.font_size = 96
    label.modulate = Color(0.75, 0.9, 1.0)
    label.position.y = 1.5
    body.add_child(label)
    add_child(body)
    challenges.append({"node": body, "done": false})

func _build_player():
    player = CharacterBody3D.new()
    player.name = "Player"
    player.position = Vector3(0, 1.2, 0)
    add_child(player)

    var mesh = MeshInstance3D.new()
    var capsule = CapsuleMesh.new()
    capsule.height = 1.8
    capsule.radius = 0.42
    mesh.mesh = capsule
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color(0.15, 0.55, 1.0)
    capsule.material = mat
    player.add_child(mesh)

    var collision = CollisionShape3D.new()
    var cs = CapsuleShape3D.new()
    cs.height = 1.8
    cs.radius = 0.42
    collision.shape = cs
    player.add_child(collision)

    var camera = Camera3D.new()
    camera.position = Vector3(0, 2.2, 5.5)
    camera.rotation_degrees = Vector3(-12, 180, 0)
    player.add_child(camera)
    camera.current = true
    player.set_meta("camera", camera)
    player.set_script(load("res://player.gd"))

func _build_ui():
    var layer = CanvasLayer.new()
    add_child(layer)
    status = Label.new()
    status.text = "SOLO  •  ПРОЙДЕНО 0  •  ОЧКИ 0"
    status.position = Vector2(30, 25)
    status.add_theme_font_size_override("font_size", 28)
    layer.add_child(status)

    var hint = Label.new()
    hint.text = "Подходи к синим испытаниям • WASD / джойстик"
    hint.position = Vector2(30, 65)
    hint.add_theme_font_size_override("font_size", 18)
    hint.modulate = Color(0.7, 0.75, 0.85)
    layer.add_child(hint)

    var joystick = load("res://joystick.gd").new()
    joystick.position = Vector2(70, 520)
    layer.add_child(joystick)

func _process(_delta):
    if not is_instance_valid(player):
        return
    for item in challenges:
        if item.done:
            continue
        var node: Node3D = item.node
        if player.global_position.distance_to(node.global_position) < 2.7:
            item.done = true
            completed += 1
            score += 10
            var mesh = node.get_child(0) as MeshInstance3D
            var box = mesh.mesh as BoxMesh
            var mat = StandardMaterial3D.new()
            mat.albedo_color = Color(0.12, 0.75, 0.35)
            mat.emission_enabled = true
            mat.emission = Color(0.03, 0.25, 0.08)
            mat.emission_energy_multiplier = 1.2
            box.material = mat
            status.text = "SOLO  •  ПРОЙДЕНО %d  •  ОЧКИ %d" % [completed, score]
