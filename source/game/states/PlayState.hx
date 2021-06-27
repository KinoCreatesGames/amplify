package game.states;

import flixel.math.FlxVector;
import flixel.effects.particles.FlxEmitter;
import flixel.math.FlxVelocity;
import game.ui.HUD;
import flixel.util.FlxSignal;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState {
	public var gameTime:Float;
	public var currentScore:Float;

	var mouseCursor:FlxSprite;

	/**
	 * Offset to apply due to the nature of angle sprites drawn. 
	 */
	public static inline var ANGLE_OFFSET = 90;

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
	var completeLevel:Bool;
	var gameOver:Bool;
	var starEmitter:FlxEmitter;

	override public function create() {
		super.create();
		spawnTimer = 0;
		accumulatedTime = 0;
		createCenterPoint();
		createParticles();
		createPlayer();
		createEnemies();
		createHUD();
		createSignals();
		setupMouse();
		// Set current Background
		bgColor = 0xFF1D2B53;
	}

	function setupMouse() {
		mouseCursor = new FlxSprite(8, 8);
		mouseCursor.loadGraphic(AssetPaths.mouse_cursor__png, false, 8, 8,
			true);
		mouseCursor.animation.add('moving', [0], null, true);
		FlxG.mouse.visible = false;
		add(mouseCursor);
	}

	function createCenterPoint() {
		centerPoint = new FlxSprite(0, 0);
		centerPoint.screenCenter();
		centerPoint.makeGraphic(8, 8, KColor.TRANSPARENT);
		add(centerPoint);
	}

	function createParticles() {
		starEmitter = new FlxEmitter(centerPoint.x, centerPoint.y, 5000);
		starEmitter.makeParticles(2, 2, KColor.WHITE, 5000);
		// starEmitter.launchMode = FlxEmitterMode.CIRCLE;
		starEmitter.color.set(0xFFFAFAFA, KColor.WHITE);
		starEmitter.height = 16;
		starEmitter.width = 16;
		starEmitter.angle.set(0, 360);
		starEmitter.velocity.set(50, 50, 50, 50, 150);
		// starEmitter.speed.set(150);
		starEmitter.start(false, 0.025, 0);
		starEmitter.x -= starEmitter.width / 2;
		starEmitter.y -= starEmitter.height / 2;
		add(starEmitter);
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
		updateMouse();
		updateGameState(elapsed);
		updateSpawnEnemy(elapsed);
		updateCollisions(elapsed);
		updateGameTime(elapsed);
	}

	function updateMouse() {
		mouseCursor.scrollFactor.set(0, 0);
		var mousePosition = FlxG.mouse.getPosition();
		mouseCursor.setPosition(mousePosition.x, mousePosition.y);
	}

	function updateGameState(elapsed:Float) {
		if (player.health <= 0 || player.alive == false) {
			gameOver = true;
		}
		// User can retry
		if (gameOver) {
			openSubState(new GameOverSubState());
		}
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
			var acclNorm = new FlxVector(enemy.acceleration.x,
				enemy.acceleration.y).normalize();
			enemyGrp.add(enemy);
			enemy.angle = acclNorm.degrees + ANGLE_OFFSET;
			spawnTimer = 0;
		} else {
			spawnTimer += elapsed;
		}
	}

	function updateCollisions(elapsed:Float) {
		FlxG.overlap(player, enemyGrp, playerTouchEnemy);
	}

	function updateGameTime(elapsed:Float) {
		gameTime += elapsed;
		timeSignal.dispatch(gameTime);
	}

	function playerTouchEnemy(player:Player, enemy:Enemy) {
		FlxG.camera.shake(0.05, 0.05);
		player.takeDamage(1);
		enemy.kill();
	}

	function playerLaserOverlapEnemy(player:Player, enemy:Enemy) {
		if (enemy.alive == false) {
			scoreSignal.dispatch(enemy.points);
		}
	}
}