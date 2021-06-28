package game.states;

import game.ui.TextButton;

class PauseSubState extends FlxSubState {
	public var pauseText:FlxText;

	var mouseCursor:FlxSprite;
	private var pauseExitSound:FlxSound;
	private var initialPosition:Float;
	private var timeCount:Float;

	public function new() {
		super(KColor.RICH_BLACK_FORGRA_LOW); // Lower Opacity RICH_Black
	}

	override public function create() {
		pauseExitSound = FlxG.sound.load(AssetPaths.pause_out__wav);
		FlxG.mouse.visible = true;
		pauseText = new FlxText(0, 0, -1, 'Pause', Globals.FONT_L);
		pauseText.screenCenter();
		pauseText.y -= 30;
		pauseText.scrollFactor.set(0, 0);
		initialPosition = pauseText.y;
		add(pauseText);
		var resumeButton = new TextButton(0, 0, 'Resume', Globals.FONT_N,
			resumeGame);
		resumeButton.screenCenter();
		resumeButton.y += 40;
		resumeButton.hoverColor = KColor.BURGUNDY;
		resumeButton.clickColor = KColor.BURGUNDY;
		var returnToTitleButton = new TextButton(0, 0, 'To Title',
			Globals.FONT_N, toTitle);
		returnToTitleButton.screenCenter();
		returnToTitleButton.y += 80;
		returnToTitleButton.hoverColor = KColor.BURGUNDY;
		returnToTitleButton.clickColor = KColor.BURGUNDY;
		add(resumeButton);
		add(returnToTitleButton);
		setupMouse();
		super.create();
	}

	function setupMouse() {
		mouseCursor = new FlxSprite(8, 8);
		mouseCursor.loadGraphic(AssetPaths.mouse_cursor__png, true, 8, 8, true);
		mouseCursor.animation.add('moving', [0], null, true);

		FlxG.mouse.visible = false;
		add(mouseCursor);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		updatePausePosition(elapsed);
	}

	public function updatePausePosition(elapsed:Float) {
		timeCount += elapsed;
		pauseText.y = initialPosition + (30 * Math.sin(timeCount));
		if (timeCount > 30) {
			timeCount = 0;
		}
	}

	public function resumeGame() {
		pauseExitSound.play();
		if (FlxG.sound.music != null) {
			FlxG.sound.music.resume();
		}
		close();
	}

	public function toTitle() {
		pauseExitSound.play();
		FlxG.camera.fade(KColor.BLACK, 1, false, () -> {
			close();

			FlxG.switchState(new TitleState());
		});
	}

	function updateMouse() {
		mouseCursor.scrollFactor.set(0, 0);
		var mousePosition = FlxG.mouse.getPosition();
		mouseCursor.setPosition(mousePosition.x, mousePosition.y);
	}
}