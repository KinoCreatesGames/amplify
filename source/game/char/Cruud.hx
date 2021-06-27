package game.char;

class Cruud extends Enemy {
	public function new(x:Float, y:Float, monsterData:MonsterData) {
		super(x, y, null, monsterData);
		loadGraphic(AssetPaths.enemy_ship__png, false, 8, 8, true);
	}
}