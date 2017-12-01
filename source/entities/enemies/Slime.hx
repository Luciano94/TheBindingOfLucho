package entities.enemies;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.addons.effects.FlxTrail;
import flixel.FlxG;
import flixel.FlxObject;

/**
 * ...
 * @author Amaka
 */
 
class Slime extends Enemy 
{

	private var timeToStand:Int;
	private var timeToCatch: Int;
	private var trail:FlxTrail;
	private var speed: Int;
	
	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.Slime__png, true, 64, 64);
		animation.add("idle", [0, 1, 0], 1, true);
		animation.add("attack", [2], true);
		scale.set(0.5, 0.5);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		speed = Reg.slimeSpeed;
		timeToCatch = Reg.timeToCatch;
		timeToStand = Reg.timeToStand;
		trail = new FlxTrail(this);
		FlxG.state.add(trail);
		Reg.slimeCatch = true;
				trace(x, y, ID);	
	}
	
	override public function destroy():Void 
	{
		trail.destroy();
		FlxG.sound.play(AssetPaths.SlimeImpact__ogg);
		super.destroy();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (isOnScreen())
		{	
			super.update(elapsed);
			if (Reg.slimeCatch)
				slimeCatch();
			if (Reg.slimeStand)
				slimeStand();
		}
	}
	
	override public function getDamage(carga:Int):Void 
	{
		super.getDamage(carga);
		FlxG.sound.play(AssetPaths.SlimeImpact__ogg);
	}
	
	private function slimeStand():Void
	{
		if (timeToStand > 0)
		{
			animation.play("idle");
			timeToStand--;
			velocity.set(0, 0);
		}
		else
		{
			timeToStand = Reg.timeToStand;
			Reg.slimeStand = false;
			Reg.slimeCatch = true;
		}
	}
	
	private function slimeCatch():Void
	{
		if (FlxG.overlap(this, Reg.playerReference))
		{
			timeToCatch = Reg.timeToCatch;
			Reg.slimeStand = true;
			Reg.slimeCatch = false;
		}
		else	
		if (timeToCatch > 0)
		{
			animation.play("attack");
			timeToCatch--;
			if ((x > Reg.playerReference.x - 1) ||(x > Reg.playerReference.x + 1))
			{
				facing = FlxObject.LEFT;
				velocity.x = -speed;
			}
			else
			{
				facing = FlxObject.RIGHT;
				velocity.x = speed;
			}
			if ((y > Reg.playerReference.y+1) || (y > Reg.playerReference.y-1))
				velocity.y = -speed;
			else
				velocity.y = speed;
		}
		else
		{
			timeToCatch = Reg.timeToCatch;
			Reg.slimeStand = true;
			Reg.slimeCatch = false;
		}
	}
}