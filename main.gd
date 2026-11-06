extends Node3D
## T04 experiment: start a WebXR "immersive-ar" session and show a 1 m box.
##
## WebXR is the browser's API for AR and VR. Godot wraps it in WebXRInterface,
## which is only available in web exports. Browsers only allow an AR session to
## start from a user action, so the session is started from a button press.

const SESSION_MODE := "immersive-ar"

var _webxr: WebXRInterface

@onready var _ui: CanvasLayer = $UI
@onready var _button: Button = $UI/Panel/StartARButton
@onready var _status: Label = $UI/Panel/StatusLabel


func _ready() -> void:
	_button.pressed.connect(_on_start_ar_pressed)

	_webxr = XRServer.find_interface("WebXR") as WebXRInterface
	if _webxr == null:
		_status.text = "WebXR is not available (only in a web export)."
		return

	_webxr.session_supported.connect(_on_session_supported)
	_webxr.session_started.connect(_on_session_started)
	_webxr.session_ended.connect(_on_session_ended)
	_webxr.session_failed.connect(_on_session_failed)

	# Asynchronous: the answer arrives through the session_supported signal.
	_webxr.is_session_supported(SESSION_MODE)


func _on_session_supported(session_mode: String, supported: bool) -> void:
	if session_mode != SESSION_MODE:
		return
	_button.disabled = not supported
	_status.text = "AR is supported." if supported else "AR is not supported in this browser."


func _on_start_ar_pressed() -> void:
	_webxr.session_mode = SESSION_MODE
	# "local-floor": the origin is on the floor below where the session starts.
	# "local" is the fallback if the device cannot find the floor.
	_webxr.requested_reference_space_types = "local-floor, local"
	_webxr.required_features = "local"
	_webxr.optional_features = "local-floor, hit-test"
	if not _webxr.initialize():
		_status.text = "Could not start the AR session."


func _on_session_started() -> void:
	_ui.visible = false
	# Let the camera image show through where nothing is drawn.
	get_viewport().transparent_bg = true
	# Render the main viewport through the XR interface.
	get_viewport().use_xr = true
	print("AR started. Reference space: %s. Enabled features: %s" % [
		_webxr.reference_space_type, _webxr.enabled_features])


func _on_session_ended() -> void:
	get_viewport().use_xr = false
	get_viewport().transparent_bg = false
	_ui.visible = true
	_status.text = "AR session ended."


func _on_session_failed(message: String) -> void:
	_status.text = "AR session failed: %s" % message
