package game.states;

import flixel.math.FlxVelocity;
import game.ui.HUD;
import flixel.util.FlxSignal;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState {
	public var gameTime:Float;
	public var currentScore:Float;

	public static inline var ENEMY_SPAWN_TIME:Float = 1.5;
	public static inline var ENEMY_SPEED:Float = 50;

	var hud:HUD;
	var scoreSignal:FlxTypedSignal<Int -> Void>;
	var timeSignal:FlxTypedSignal<Float -> Void>;
	var player:Player;
	var enemyGrp:FlxTypedGroup<Enemy>;
	var spawnTimer:Float;
	var accumulatedTime:Float;
	var centerPoint:FlxSprite;
	var spawnPoint:FlxSprite;

	override public function create() {
		super.create();
		spawnTimer = 0;
		accumulatedTime = 0;
		add(new FlxText("Hello World", 32).screenCenter());
		createCenterPoint();
		createPlayer();
		createEnemies();
		createHUD();
		createSignals();
	}

	function createCenterPoint() {
		centerPoint = new FlxSprite(0, 0);
		centerPoint.screenCenter();
		centerPoint.makeGraphic(8, 8, KColor.TRANSPARENT);
		add(centerPoint);
	}

	function createPlayer() {
		player = new Player(32, 32, null);
		add(player);
	}

	function createEnemies() {
		enemyGrp = new FlxTypedGroup<Enemy>(300);
		add(enemyGrp);
	}

	function createHUD() {
		hud = new HUD(0, 0);
		add(hud);
	}

	function createSignals() {
		scoreSignal = new FlxTypedSignal<Int -> Void>();
		timeSignal = new FlxTypedSignal<Float -> Void>();
		// Update HUD on Score Update
		scoreSignal.add((scoreValue) -> {
			hud.updateScore(scoreValue);
		});

		// Game Time Update
		timeSignal.add((timeStamp) -> {
			hud.updateTime(timeStamp);
		});
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updateSpawnEnemy(elapsed);
		updateCollisions(elapsed);
		updateGameTime(elapsed);
	}

	function updateSpawnEnemy(elapsed:Float) {
		var radius = 310;
		accumulatedTime += elapsed;
		if (spawnTimer > ENEMY_SPAWN_TIME) {
			var x = (centerPoint.x) + (radius * Math.cos(accumulatedTime));
			var y = (centerPoint.y) + (radius * Math.sin(accumulatedTime));
			var enemy = new Cruud(x, y, null);
			FlxVelocity.accelerateTowardsObject(enemy, player, ENEMY_SPEED,
				100);
			enemyGrp.add(enemy);
			spawnTimer = 0;
		} else {
			spawnTimer += elapsed;
		}
	}

	function updateCollisions(elapsed:Float) {
		FlxG.overlap(player, enemyGrp);
	}

	function updateGameTime(elapsed:Float) {
		gameTime += elapsed;
		timeSignal.dispatch(gameTime);
	}

	function playerTouchEnemy(player:Player, enemy:Enemy) {
		player.takeDamage(1);
		enemy.kill();
	}

	function playerLaserOverlapEnemy(player:Player, enemy:Enemy) {
		if (enemy.alive == false) {
			scoreSignal.dispatch(enemy.points);
		}
	}
}