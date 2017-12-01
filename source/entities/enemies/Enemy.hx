package entities.enemies;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.FlxG;

/**
 * ...
 * @author Amaka
 */
class Enemy extends FlxSprite 
{

	private var life:Int;
	private var particles: FlxEmitter;
	
	public function new(?X:Float=0, ?Y:Float=0, ?SimpleGraphic:FlxGraphicAsset) 
	{
		super(X, Y, SimpleGraphic);
		makeGraphic(32, 32, FlxColor.BLUE);
		life = Reg.enemyBasicLife;
	}
	
	override public function update(elapsed:Float):Void 
	{
			super.update(elapsed);
	}
	
	public function getDamage(carga:Int):Void
	{
		if(carga > 66)
			life -= 3;
		else if (carga > 33)
			life -= 2;
			else
				life--;
		if(life < 0)
			destroy();
	}
	
}