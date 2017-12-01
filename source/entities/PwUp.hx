package entities;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author Amaka
 */
class PwUp extends FlxSprite 
{

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.PwUp__png, false, 31, 31);
	}
	
	override public function update(elapsed:Float):Void 
	{
		angle++;
		super.update(elapsed);
	}
}