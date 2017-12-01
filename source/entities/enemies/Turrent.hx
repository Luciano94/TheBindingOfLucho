package entities.enemies;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
/**
 * ...
 * @author Amaka
 */
class Turrent extends Enemy 
{
	
	private var Bullet:TurrentBullet;
	public var bulletAlive:Bool;
	private var bullets:FlxTypedGroup<TurrentBullet>;

	public function new(?X:Float=0, ?Y:Float=0, _bullets:FlxTypedGroup<TurrentBullet>) 
	{
		super(X, Y);
		life = Reg.enemyTurretLife;
		bulletAlive = false;
		bullets = _bullets;
		loadGraphic(AssetPaths.Turrent__png, false, 64, 64);
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (isOnScreen())
		{
			super.update(elapsed);
			if (!bulletAlive)
				shot();
		}
	}
	
	override public function destroy():Void 
	{
		FlxG.sound.play(AssetPaths.hit__ogg);
		super.destroy();
	}
	
	override public function getDamage(carga:Int):Void 
	{
		FlxG.sound.play(AssetPaths.hit__ogg);
		super.getDamage(carga);
	}
	
	private function shot():Void
	{
		bulletAlive = true;
		Bullet = new TurrentBullet(x + (width / 2) , y + (height / 2), this);
		bullets.add(Bullet); 
	}
	
}