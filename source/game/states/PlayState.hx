package game.states;

import game.ui.HUD;
import flixel.util.FlxSignal;
import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState {
	public var gameTime:Float;
	public var currentScore:Float;

	var hud:HUD;
	var scoreSignal:FlxTypedSignal<Int -> Void>;
	var timeSignal:FlxTypedSignal<Float -> Void>;
	var player:Player;
	var enemyGrp:FlxTypedGroup<Enemy>;

	override public function create() {
		super.create();
		add(new FlxText("Hello World", 32).screenCenter());
		createPlayer();
		createEnemies();
		createHUD();
		createSignals();
	}

	function createPlayer() {
		player = new Player(32, 32, null);
		add(player);
	}

	function createEnemies() {
		enemyGrp = new FlxTypedGroup<Enemy>();
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
		updateCollisions(elapsed);
		updateGameTime(elapsed);
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