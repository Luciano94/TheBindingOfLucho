package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import flixel.ui.FlxBar;

/**
 * ...
 * @author ...
 */
class Weapon extends FlxSprite 
{

	private var range:Int;
	private var direction: Int;
	private var speed: Int;
	private var carga:Int;
	
	public function new(?X:Float=0, ?Y:Float=0, _direction:Int, _carga:Int) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.espada__png);
		range = 0;
		direction = _direction;
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		speed = Reg.weaponSpeed;
		Reg.weaponAlive = true;
		Reg.weaponReference = this;
		FlxG.state.add(this);
		if (direction == 1)
			angle -= 90;
		if (direction == 3)
			angle += 90;
		
		if (Reg.weaponMAxPower)
		{
			Reg.weaponMAxPower = false;
			FlxFlicker.flicker(this, 0, 0.04, true, true);
		}
		FlxG.sound.play(AssetPaths.ShotSword__ogg);
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (range < Reg.weaponRange)
		{
			range++;
			switch (direction) 
			{
				case 1:
					velocity.y = -speed;
				case 2:
					velocity.x = -speed;
					facing = FlxObject.LEFT;
				case 3:
					velocity.y = speed;
				case 4:
					velocity.x = speed;
					facing = FlxObject.RIGHT;
			}
		}
		else
		{
			Reg.weaponAlive = false;
			destroy();
		}
	}
	
	public function getCarga():Int
	{
		return carga;
	}
}