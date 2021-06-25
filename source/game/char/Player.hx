package game.char;

import flixel.math.FlxVector;

class Player extends Actor {
	public static inline var M_SPEED = 200;

	var playerImpactSound:FlxSound;
	var firePosition:FlxPoint;
	var fireNormal:FlxVector;

	public function new(x:Float, y:Float, actorData:ActorData) {
		super(x, y, actorData);
		drag.y = drag.x = 350;
		firePosition = new FlxPoint(0, 0);
		fireNormal = new FlxVector(0, 0);
		playerImpactSound = FlxG.sound.load(AssetPaths.impact__wav);
		makeGraphic(8, 8, KColor.BLUE);
	}

	override public function assignStats() {
		super.assignStats();
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateFirePosition(elapsed);
		updateMovement(elapsed);
	}

	function updateFirePosition(elapsed:Float) {
		// Update Fire Position
		var distanceRadius = 12;
		var fireVec = new FlxVector(FlxG.mouse.x - x, FlxG.mouse.y - y);
		fireNormal = fireVec.normalize();
		firePosition.x = x;
		firePosition.y = y;
		firePosition.x = firePosition.x
			+ (distanceRadius * Math.cos(fireNormal.x));
		firePosition.y = firePosition.y
			+ (distanceRadius * Math.sin(fireNormal.y));
		this.angle = fireNormal.degrees;
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

	override public function takeDamage(value:Int) {
		playerImpactSound.play();
		super.takeDamage(value);
	}
}