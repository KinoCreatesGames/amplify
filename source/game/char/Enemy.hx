package game.char;

import flixel.math.FlxVelocity;

class Enemy extends game.char.Actor {
	public var walkPath:Array<FlxPoint>;
	public var points:Int;

	var enemyImpactSound:FlxSound;

	public function new(x:Float, y:Float, path:Array<FlxPoint>,
			monsterData:MonsterData) {
		super(x, y, monsterData);
		if (path != null) {
			walkPath = path;
		}
		if (monsterData != null) {
			points = monsterData.points;
		}
		enemyImpactSound = FlxG.sound.load(AssetPaths.enemy_impact__wav);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateMovement(elapsed);
	}

	public function updateMovement(elapsed:Float) {}

	override public function takeDamage(value:Int) {
		enemyImpactSound.play();
		super.takeDamage(value);
	}
}