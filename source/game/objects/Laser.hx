package game.objects;

import flixel.math.FlxRect;
import flixel.addons.display.FlxSliceSprite;

class Laser extends FlxSliceSprite {
	public static inline var BEAM_SIZE:Float = 8.0;

	public function new(sliceRec:FlxRect) {
		super(AssetPaths.laser_beam__png, sliceRect, BEAM_SIZE, BEAM_SIZE);
	}
}