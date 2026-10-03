extends Control

var finger_id := -1
var center := Vector2(90, 90)
var stick := Vector2.ZERO
var radius := 80.0

func _ready():
    custom_minimum_size = Vector2(180, 180)
    mouse_filter = Control.MOUSE_FILTER_STOP
    queue_redraw()

func _gui_input(event):
    if event is InputEventScreenTouch:
        if event.pressed and finger_id == -1:
            finger_id = event.index
            _set_stick(event.position)
        elif not event.pressed and event.index == finger_id:
            finger_id = -1
            stick = Vector2.ZERO
            _send()
            queue_redraw()
    elif event is InputEventScreenDrag and event.index == finger_id:
        _set_stick(event.position)

func _set_stick(p: Vector2):
    var local = p - center
    if local.length() > radius:
        local = local.normalized() * radius
    stick = local / radius
    _send()
    queue_redraw()

func _send():
    var player = get_tree().current_scene.get_node_or_null("Player")
    if player:
        player.set_meta("mobile_input", stick)

func _draw():
    draw_circle(center, radius, Color(0.08, 0.12, 0.20, 0.78))
    draw_circle(center + stick * radius, 32, Color(0.20, 0.55, 1.0, 0.95))
