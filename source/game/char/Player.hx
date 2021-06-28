package game.char;

import flixel.addons.display.FlxSliceSprite;
import flixel.math.FlxRect;
import game.objects.SliceLaser;
import flixel.math.FlxVector;
import openfl.Vector;

class Player extends Actor {
	public static inline var M_SPEED = 200;

	var playerImpactSound:FlxSound;
	var firePosition:FlxPoint;
	var fireNormal:FlxVector;
	var fireLine:FlxSprite;
	var firingLaser:SliceLaser;
	var actualLaser:FlxSprite;
	var cachedVertices:Vector<Float>;

	/**
	 * 90 Degree angle offset to account for the ship direction in 
	 * Aseprite.
	 */
	public static inline var ANGLE_OFFSET = 90;

	public function new(x:Float, y:Float, actorData:ActorData) {
		super(x, y, actorData);
		drag.y = drag.x = 350;
		firePosition = new FlxPoint(0, 0);
		fireNormal = new FlxVector(0, 0);
		playerImpactSound = FlxG.sound.load(AssetPaths.impact__wav);

		loadGraphic(AssetPaths.player_ship__png, false, 8, 8, true);
		createFireLine();
		createFireLaser();
	}

	function createFireLine() {
		fireLine = new FlxSprite(this.x, this.y);
		fireLine.makeGraphic(FlxG.width + 30, 1, 0x66ff004d);
		fireLine.origin.set(0, 0);
		FlxG.state.add(fireLine);
	}

	function createFireLaser() {
		firingLaser = new SliceLaser(new FlxRect(2, 2, 4, 4));
		firingLaser.height = 100;

		actualLaser = new FlxSprite(0, 0);
		actualLaser.makeGraphic(8, 8, KColor.RED);
		// firingLaser.stretchCenter = true;
		// firingLaser.origin.set(0, 0);
		FlxG.state.add(firingLaser);
		FlxG.state.add(actualLaser);
		cachedVertices = new Vector<Float>();
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
		fireLine.angle = fireNormal.degrees;
		fireLine.x = this.x + (this.width / 2);
		fireLine.y = this.y + (this.height / 2);
		firingLaser.x = this.x + (this.width / 2);
		firingLaser.y = this.y + (this.height / 2);

		if (cachedVertices.length == 0 && firingLaser.vertices != null
			&& firingLaser.vertices.length > 0) {
			cachedVertices = firingLaser.vertices.copy();
		}
		// Angle For the laser that the player will fire at the  enemies
		var angle = (fireNormal.degrees.degToRad()
			+ ANGLE_OFFSET.degToRad())
			+ 180.degToRad();
		for (index in 0...cachedVertices.length) {
			if ((index + 1) % 2 == 0) {
				firingLaser.vertices[index] = cachedVertices[index
					- 1] * Math.sin(angle)
					+ cachedVertices[index] * Math.cos(angle);
			} else {
				firingLaser.vertices[index] = cachedVertices[index] * Math.cos(angle)
					- cachedVertices[index + 1] * Math.sin(angle);
			}
		}

		this.angle = fireNormal.degrees + ANGLE_OFFSET;
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
			this.bound();
		}
	}

	override public function takeDamage(value:Int) {
		playerImpactSound.play();
		super.takeDamage(value);
	}
}