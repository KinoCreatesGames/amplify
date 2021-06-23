package game.char;

class Cruud extends Enemy {
	public function new(x:Float, y:Float, monsterData:MonsterData) {
		super(x, y, null, monsterData);
		makeGraphic(8, 8, KColor.RED);
	}
}