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

	override public function create() {
		super.create();
		add(new FlxText("Hello World", 32).screenCenter());
		add(new Player(32, 32, null));
		createHUD();
		createSignals();
	}

	function createHUD() {
		hud = new HUD(0, 0);
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
		updateGameTime(elapsed);
	}

	function updateGameTime(elapsed:Float) {
		gameTime += elapsed;
		timeSignal.dispatch(gameTime);
	}

	function playerLaserOverlapEnemy(player:Player, enemy:Enemy) {
		if (enemy.alive == false) {
			scoreSignal.dispatch(enemy.points);
		}
	}
}