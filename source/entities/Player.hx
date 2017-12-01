package entities;

import flixel.addons.util.FlxFSM;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxObject;
import entities.Weapon;
import flixel.ui.FlxBar;
import flixel.text.FlxText;
import states.DeathState;
import flixel.effects.FlxFlicker;

/**
 * ...
 * @author Amaka
 */

class Player extends FlxSprite 
{
	
	private var speed:Int;
	private var fsm:FlxFSM<Player>;
	private var weaponBar:FlxBar;
	private var shields:Int;
	private var txtShields: FlxText;
	public var carga:Int;
	public var weapon: Weapon;

	public function new(?X:Float=0, ?Y:Float=0) 
	{
		//init
		super(X, Y);
		Reg.playerReference = this;
		speed = Reg.playerSpeed;
		carga = 0;
		shields = 0;
		weaponBar = new FlxBar(0, 0,FlxBarFillDirection.LEFT_TO_RIGHT, 200, 20,this , "carga", 0, Reg.weaponPower, true);
		FlxG.state.add(weaponBar);
		txtShields = new FlxText(10 + weaponBar.width,0, 0, "Shields: " + shields, 12, true);
		FlxG.state.add(txtShields);
		//graphics
		loadGraphic(AssetPaths.Player__png, true, 127, 127);
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);
		width = 64;
		centerOffsets();
		
		//Animations
		animation.add("idle", [0, 1], 2, true);
		animation.add("run", [2, 3, 4, 5, 6, 7, 8, 9, 10], 12, true);
		animation.add("rundown", [23, 24, 23, 25], 12, true);
		animation.add("runUp", [26, 27, 26, 28], 12, true);
		animation.add("attack", [14, 15, 16, 17], 30, false);
		
		//FSM
		fsm = new FlxFSM<Player>(this);
		fsm.transitions
			.add(Idle, Attack, Conditions.attack)
			.add(Attack, Idle, Conditions.pacifism)
			.start(Idle);
	}
	
	override public function update(elapsed:Float):Void 
	{
		fsm.update(elapsed);
		super.update(elapsed);
		updateCarga();
		updateHUD();
		if (Reg.bossFight)
			checkBoundaries();
	}
	
	private function updateCarga():Void
	{
		if (carga == Reg.weaponPower)
		{
			carga = Reg.weaponPower;
			Reg.weaponMAxPower = true;
		}
	}
	
	private function updateHUD():Void
	{
		weaponBar.setPosition(FlxG.camera.scroll.x + 5, FlxG.camera.scroll.y + 5);
		txtShields.setPosition(FlxG.camera.scroll.x + weaponBar.width + txtShields.width + 250, FlxG.camera.scroll.y + 5);
		txtShields.text = "Shields: " + shields;
	}
	
	override public function destroy():Void 
	{
		weaponBar.destroy();
		txtShields.destroy();
		fsm.destroy();
		fsm = null;
		super.destroy();
	}
	
	public function getDamage():Void
	{
		FlxG.sound.play(AssetPaths.damaged__ogg);
		if (shields > -1 && !FlxFlicker.isFlickering(this))
		{
			FlxFlicker.flicker(this, 3, 0.05, true);
			FlxG.camera.shake(0.005);
			shields --;
		}
		else if(shields == -1)
		{
			destroy();
		}
	}
	
	public function pickShield():Void
	{
		shields ++;
	}
	
	public function getShields():Int
	{
		return shields;
	}
	
	private function checkBoundaries():Void
	{
		if (x > camera.scroll.x + FlxG.width - width)
			x = camera.scroll.x + FlxG.width - width;
		if (x < camera.scroll.x)
			x = camera.scroll.x;
		if (y > camera.scroll.y + FlxG.height - height)
			y = camera.scroll.y + FlxG.height - height;
		if (y < camera.scroll.y)
			y = camera.scroll.y;
	}
}

class Conditions
{
	public static function attack(Owner:Player):Bool
	{
		return ((FlxG.keys.anyPressed([W, A, S, D])) && (!Reg.weaponAlive));
	}
	
	public static function pacifism(Owner:Player):Bool
	{
		return Reg.weaponAlive;
	}
}

class Attack extends FlxFSMState<Player>
{
	
	override public function update(elapsed:Float, owner:Player, fsm:FlxFSM<Player>):Void 
	{
		owner.velocity.set(0, 0);
		owner.animation.play("idle");
		if (FlxG.keys.pressed.W && !Reg.weaponAlive)
			owner.carga++;
		else
		{
			if (FlxG.keys.justReleased.W && !Reg.weaponAlive)
			{
				owner.weapon = new Weapon(owner.x + (owner.width / 2), owner.y + (owner.height / 2), 1, owner.carga);
				owner.carga = 0;
			}
		}
		if (FlxG.keys.pressed.A && !Reg.weaponAlive)
			owner.carga++;
		else
		{
			if (FlxG.keys.justReleased.A && !Reg.weaponAlive)
			{
				owner.weapon = new Weapon(owner.x + (owner.width / 2), owner.y + (owner.height / 2), 2, owner.carga);
				owner.carga = 0;
			}
		}
		if (FlxG.keys.pressed.S && !Reg.weaponAlive)
			owner.carga++;
		else
		{
			if (FlxG.keys.justReleased.S && !Reg.weaponAlive)
			{
				owner.weapon = new Weapon(owner.x + (owner.width / 2), owner.y + (owner.height / 2), 3, owner.carga);
				owner.carga = 0;
			}
		}
		if (FlxG.keys.pressed.D && !Reg.weaponAlive)
			owner.carga++;
		else
		{
			if (FlxG.keys.justReleased.D && !Reg.weaponAlive)
			{
				owner.weapon = new Weapon(owner.x + (owner.width / 2), owner.y + (owner.height / 2), 4, owner.carga);
				owner.carga = 0;
			}
		}
		owner.velocity.set(0, 0);
		if (FlxG.keys.pressed.UP)
		{
			owner.animation.play("runUp");
			owner.velocity.y = -Reg.playerSpeed;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			owner.animation.play("rundown");
			owner.velocity.y = Reg.playerSpeed;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			owner.animation.play("run");
			owner.facing = FlxObject.RIGHT;
			owner.velocity.x = Reg.playerSpeed;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			owner.animation.play("run");
			owner.facing = FlxObject.LEFT;
			owner.velocity.x = -Reg.playerSpeed;
		}
		if (!FlxG.keys.anyPressed([UP, DOWN, RIGHT, LEFT]))
			owner.animation.play("idle");
	}
}

class Idle extends FlxFSMState<Player>
{
	
	override public function update(elapsed:Float, owner:Player, fsm:FlxFSM<Player>):Void 
	{
		owner.velocity.set(0, 0);
		if (FlxG.keys.pressed.UP)
		{
			owner.animation.play("runUp");
			owner.velocity.y = -Reg.playerSpeed;
		}
		if (FlxG.keys.pressed.DOWN)
		{
			owner.animation.play("rundown");
			owner.velocity.y = Reg.playerSpeed;
		}
		if (FlxG.keys.pressed.RIGHT)
		{
			owner.animation.play("run");
			owner.facing = FlxObject.RIGHT;
			owner.velocity.x = Reg.playerSpeed;
		}
		if (FlxG.keys.pressed.LEFT)
		{
			owner.animation.play("run");
			owner.facing = FlxObject.LEFT;
			owner.velocity.x = -Reg.playerSpeed;
		}
		if (!FlxG.keys.anyPressed([UP, DOWN, RIGHT, LEFT]))
			owner.animation.play("idle");
	}
}