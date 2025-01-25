@tool
# no class_name because it is AutoLoaded
extends Node

const TILE_SIZE = 32

# for collision layer/mask setting/getting functions
enum CollisionLayers {
	ENVIRONMENT = 1,
	PLAYER = 2,
	ENVIRONMENT_ONE_WAY = 3,
	ENVIRONMENT_STOP_RAIN = 4,
}

# for direct manipulation of collision layers/masks
enum CollisionBits {
	ENVIRONMENT = 1 << CollisionLayers.ENVIRONMENT-1,
	PLAYER = 1 << CollisionLayers.PLAYER-1,
	ENVIRONMENT_ONE_WAY = 1 << CollisionLayers.ENVIRONMENT_ONE_WAY-1,
	ENVIRONMENT_STOP_RAIN = 1 << CollisionLayers.ENVIRONMENT_STOP_RAIN-1,
}

# flag values stolen shamelessly from BYOND
enum Dirs {
	UP = 1,
	DOWN = 2,
	RIGHT = 4,
	LEFT = 8,
}
enum Diags {
	UP_RIGHT = Dirs.UP|Dirs.RIGHT,
	UP_LEFT = Dirs.UP|Dirs.LEFT,
	DOWN_RIGHT = Dirs.DOWN|Dirs.RIGHT,
	DOWN_LEFT = Dirs.DOWN|Dirs.LEFT,
}

# used for iteration, exports, etc
enum AllDirs {
	UP = Dirs.UP,
	DOWN = Dirs.DOWN,
	RIGHT = Dirs.RIGHT,
	LEFT = Dirs.LEFT,
	UP_RIGHT = Diags.UP_RIGHT,
	UP_LEFT = Diags.UP_LEFT,
	DOWN_RIGHT = Diags.DOWN_RIGHT,
	DOWN_LEFT = Diags.DOWN_LEFT,
}
enum HDirs {
	RIGHT = Dirs.RIGHT,
	LEFT = Dirs.LEFT,
}
enum VDirs {
	UP = Dirs.UP,
	DOWN = Dirs.DOWN,
}

func dir2vector(dir) -> Vector2:
	var v := Vector2.ZERO
	if dir & Dirs.UP:
		v.y = -1
	if dir & Dirs.DOWN:
		v.y = 1
	if dir & Dirs.RIGHT:
		v.x = 1
	if dir & Dirs.LEFT:
		v.x = -1
	return v

func vec_scale_x_to(v: Vector2, x: float) -> Vector2:
	v = v.normalized()
	v /= v.x
	return v * x

func vec_scale_y_to(v: Vector2, y: float) -> Vector2:
	v = v.normalized()
	v /= v.y
	return v * y

func rad2vector(angle) -> Vector2:
	return Vector2(cos(angle), -sin(angle))

func deg2vector(angle) -> Vector2:
	return rad2vector(deg_to_rad(angle))
