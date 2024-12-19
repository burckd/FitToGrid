extends Node

# Each piece is keyed by its name and has four rotation states (0°, 90°, 180°, 270°).
# Even if some rotations are duplicates (like O or the 3x3 square), we list them all for consistency.
# Coordinates are given as Vector2(x, y).

var pieces := {
	"I": [
		[Vector2(0,0), Vector2(1,0), Vector2(2,0)], # 0°
		[Vector2(0,0), Vector2(0,1), Vector2(0,2)], # 90°
		[Vector2(0,0), Vector2(1,0), Vector2(2,0)], # 180° (same as 0°)
		[Vector2(0,0), Vector2(0,1), Vector2(0,2)]  # 270° (same as 90°)
	],

	"O": [
		[Vector2(0,0), Vector2(1,0), Vector2(0,1), Vector2(1,1)], # 0°
		[Vector2(0,0), Vector2(1,0), Vector2(0,1), Vector2(1,1)], # 90°
		[Vector2(0,0), Vector2(1,0), Vector2(0,1), Vector2(1,1)], # 180°
		[Vector2(0,0), Vector2(1,0), Vector2(0,1), Vector2(1,1)]  # 270°
	],

	"T": [
		[Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(1,1)], # 0°
		# For 90°, we shift to ensure top-left is (0,0)
		# Original rotation: (1,0),(1,1),(1,2),(2,1)
		# Shift left by 1 to get min x = 0: (0,0),(0,1),(0,2),(1,1)
		[Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(1,1)], # 90°
		
		[Vector2(0,1), Vector2(1,1), Vector2(2,1), Vector2(1,0)], # 180° (already top-left at (0,0))
		# Checking min x,y: min x=0, min y=0 since there's (1,0)
		
		# For 270°, original rotation might be (0,1),(1,1),(1,0),(1,2)
		# min x=0, min y=0 from (1,0) is good. No shift needed.
		[Vector2(0,1), Vector2(1,1), Vector2(1,0), Vector2(1,2)]  # 270°
	],

	"S": [
		# 0°: shape like:
		#  (1,0),(2,0)
		# (0,1),(1,1)
		# min x=0 from (0,1), good.
		[Vector2(1,0), Vector2(2,0), Vector2(0,1), Vector2(1,1)],
		# 90°:
		# (0,0),(0,1),(1,1),(1,2)
		[Vector2(0,0), Vector2(0,1), Vector2(1,1), Vector2(1,2)],
		# 180° same as 0°
		[Vector2(1,0), Vector2(2,0), Vector2(0,1), Vector2(1,1)],
		# 270° same as 90°
		[Vector2(0,0), Vector2(0,1), Vector2(1,1), Vector2(1,2)]
	],

	"Z": [
		# 0°:
		[Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(2,1)],
		# 90°:
		# Original rotation: (1,0),(1,1),(0,1),(0,2)
		# min x=0: already 0 at (0,1), no shift needed.
		[Vector2(1,0), Vector2(1,1), Vector2(0,1), Vector2(0,2)],
		# 180° same as 0°
		[Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(2,1)],
		# 270° same as 90°
		[Vector2(1,0), Vector2(1,1), Vector2(0,1), Vector2(0,2)]
	],

	"J": [
		# 0°: J shape
		[Vector2(0,0), Vector2(0,1), Vector2(1,1), Vector2(2,1)],
		# 90°:
		# Original: (1,0),(1,1),(1,2),(0,2)
		# min x=0 already (0,2) is x=0,
		[Vector2(1,0), Vector2(1,1), Vector2(1,2), Vector2(0,2)],
		# 180°:
		# Original: (2,1),(2,0),(1,0),(0,0)
		# min x=0 (0,0) is min x=0, min y=0 good.
		[Vector2(2,1), Vector2(2,0), Vector2(1,0), Vector2(0,0)],
		# 270°:
		# Original: (0,0),(0,1),(0,2),(1,0)
		# Already min x=0, min y=0 good.
		[Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(1,0)]
	],

	"L": [
		# 0°:
		# Original: (2,0),(2,1),(1,1),(0,1)
		# min x=0 from (0,1), min y=0 from (2,0)
		# After shifting so that smallest x,y = 0:
		# Actually, min x = 0 already (0,1)
		# min y=0 at (2,0)
		# So coordinates are fine as is.
		[Vector2(2,0), Vector2(2,1), Vector2(1,1), Vector2(0,1)],
		
		# 90°:
		# Original: (0,0),(0,1),(0,2),(1,2)
		# Already minimal
		[Vector2(0,0), Vector2(0,1), Vector2(0,2), Vector2(1,2)],
		
		# 180°:
		# Original: (0,0),(1,0),(2,0),(0,1)
		# Already minimal
		[Vector2(0,0), Vector2(1,0), Vector2(2,0), Vector2(0,1)],

		# 270°:
		# Original: (0,0),(1,0),(1,1),(1,2)
		# Already minimal
		[Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(1,2)]
	],

	# 3x3 square (covers all cells in a 3x3 block)
	# All rotations are identical.
	"3X3": [
		[
			Vector2(0,0), Vector2(1,0), Vector2(2,0),
			Vector2(0,1), Vector2(1,1), Vector2(2,1),
			Vector2(0,2), Vector2(1,2), Vector2(2,2)
		],
		[
			Vector2(0,0), Vector2(1,0), Vector2(2,0),
			Vector2(0,1), Vector2(1,1), Vector2(2,1),
			Vector2(0,2), Vector2(1,2), Vector2(2,2)
		],
		[
			Vector2(0,0), Vector2(1,0), Vector2(2,0),
			Vector2(0,1), Vector2(1,1), Vector2(2,1),
			Vector2(0,2), Vector2(1,2), Vector2(2,2)
		],
		[
			Vector2(0,0), Vector2(1,0), Vector2(2,0),
			Vector2(0,1), Vector2(1,1), Vector2(2,1),
			Vector2(0,2), Vector2(1,2), Vector2(2,2)
		]
	]
}
