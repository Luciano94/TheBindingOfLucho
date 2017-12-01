package;
import entities.Player;
import entities.Weapon;
import entities.enemies.TurrentBullet;

/**
 * ...
 * @author ...
 */
class Reg 
{
	
	//Pause
	public static var pause:Bool = false;
	
	//Player
	public static var playerSpeed:Int = 150;
	public static var playerReference:Player;
	public static var playerShields:Int = 3;
	
	//weapon
	public static var weaponReference:Weapon;
	public static var weaponRange:Int = 50;
	public static var weaponAlive:Bool = false;
	public static var weaponMAxPower:Bool = false;
	public static var weaponSpeed:Int = 200;
	public static var weaponPower:Int = 100;
	
	//enemy Basic
	public static var enemyBasicLife:Int = 3;
	
	//slime
	public static var timeToStand:Int = 100;
	public static var timeToCatch:Int = 300;
	public static var slimeStand:Bool = false;
	public static var slimeCatch:Bool = false;
	public static var slimeHit: Bool = true;
	public static var slimeSpeed:Int = 50;
	
	//Turrent
	public static var enemyTurretLife: Int = 2;
	public static var bulletReference:TurrentBullet;
	public static var bulletTime: Int = 50;
	public static var bulletSpeed:Int = 150;
	
	//Armored
	public static var enemyArmoredLife: Int = 6;
	
	//Boss
	public static var bossLife:Int = 30;
	public static var bossSpeed:Int = 100;
	public static var bossSpeedBoost:Int = 200;
	public static var bossFight:Bool = false;
}