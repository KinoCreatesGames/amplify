package game.char;

class Player extends Actor {
	public static inline var M_SPEED = 200;

	public function new(x:Float, y:Float, actorData:ActorData) {
		super(x, y, actorData);
		drag.y = drag.x = 350;
		makeGraphic(8, 8, KColor.BLUE);
	}

	override public function assignStats() {
		super.assignStats();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateMovement(elapsed);
	}

	function updateMovement(elapsed:Float) {
		var left = FlxG.keys.anyPressed([A, LEFT]);
		var right = FlxG.keys.anyPressed([D, RIGHT]);
		var up = FlxG.keys.anyPressed([W, UP]);
		var down = FlxG.keys.anyPressed([S, DOWN]);

		var angle = 0;

		if (left || right || up || down) {
			if (left) {
				angle = 180;
				if (up) {
					angle += 45;
				} else if (down) {
					angle += -45;
				}
			} else if (right) {
				if (up) {
					angle += -45;
				} else if (down) {
					angle += 45;
				}
			} else if (up) {
				angle = -90;
			} else if (down) {
				angle = 90;
			}

			this.velocity.set(M_SPEED, 0);
			this.velocity.rotate(FlxPoint.weak(0, 0), angle);
		}
	}
}