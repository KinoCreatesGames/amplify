package game.objects;

import flixel.math.FlxRect;
import flixel.addons.display.FlxSliceSprite;

class SliceLaser extends FlxSliceSprite {
	public function new(rect:FlxRect) {
		super(AssetPaths.laser_beam__png, rect, 8, 8);
	}
}