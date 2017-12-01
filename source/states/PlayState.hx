package states;

import entities.enemies.Boss;
import entities.BossFight;
import entities.Player;
import entities.Weapon;
import entities.enemies.Turrent;
import entities.enemies.TurrentBullet;
import flixel.ui.FlxBar;
import flixel.util.typeLimit.OneOfThree;
import states.DeathState;
import states.PauseState;
import entities.PwUp;
import entities.enemies.Enemy;
import entities.enemies.Slime;
import flixel.FlxBasic.FlxType;
import flixel.effects.FlxFlicker;
import flixel.FlxCamera;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTileblock;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxG;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var player:Player;
	private var loader:FlxOgmoLoader;
	private var tilemap:FlxTilemap;
	private var enemy: Enemy;
	private var enemies:FlxTypedGroup<Enemy>;
	private var turr:Turrent;
	private var turrents:FlxTypedGroup<Turrent>;
	private var turrentsBull:FlxTypedGroup<TurrentBullet>;
	private var pwUP:PwUp;
	private var pwUps:FlxTypedGroup<PwUp>;
	private var boss:Boss;
	private var bossBar:FlxBar;
	private var bossf:BossFight;
	
	override public function create():Void
	{
		super.create();
		FlxG.sound.playMusic(AssetPaths.Musica__ogg, true);
		/*--init--*/
		//map
		FlxG.worldBounds.set(0, 0, 9000, 5000);
		FlxG.mouse.visible = false;
		tilemapSetUp();
		
		//player
		player = new Player();
		
		//enemies
		enemies = new FlxTypedGroup<Enemy>();
		turrentsBull = new FlxTypedGroup<TurrentBullet>();
		turrents = new FlxTypedGroup<Turrent>();
		//pwUps
		pwUps = new FlxTypedGroup<PwUp>();
		
		//camera
		camera.follow(player, FlxCameraFollowStyle.LOCKON);
		loader.loadEntities(entityCreator, "Entities");
		bossBar = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, FlxG.width, 30, boss, "life", 0, Reg.bossLife, true);
		bossBar.visible = false;
		//add
		add(bossBar);
		add(player);
		add(enemies);
		add(turrents);
		add(turrentsBull);
		add(pwUps);
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.pressed.X){
			camera.zoom = 0.4;
		}
		else camera.zoom = 1;
		if (FlxG.keys.pressed.P)
		{
			Reg.pause = true;
			openSubState(new PauseState());
		}
		if (!Reg.pause)
		{
			super.update(elapsed);
			FlxG.collide(player, tilemap);
			FlxG.collide(enemies, tilemap);
			FlxG.collide(turrents, tilemap);
			FlxG.collide(boss, tilemap);
			
			/*Boss figth*/
			bossBar.setPosition(camera.scroll.x,camera.scroll.y+ FlxG.height - 35);
			if (Reg.bossFight)
			{
				camera.follow(bossf, FlxCameraFollowStyle.NO_DEAD_ZONE);
				bossBar.visible = true;
			}
			
			/*--COLISIONES--*/
			//arma - enemigos
			if (Reg.weaponAlive)
			{
				FlxG.overlap(Reg.weaponReference, turrents, colWeaponTurrents);
				FlxG.overlap(Reg.weaponReference, enemies, colWeaponEnemies);
				FlxG.overlap(Reg.weaponReference, boss, colWeaponBoss);
			}
			
			//player - enemigos
			FlxG.overlap(player, enemies, colPlayerEnemies);
			FlxG.overlap(player, turrentsBull, colPlayerBullet);
			FlxG.overlap(player, boss, colPlayerBoss);
			FlxG.overlap(player, turrents, colPlayerTurrents);
			
			//player - pwUps
			FlxG.overlap(player, pwUps, colPlayerPwUps);
		}
	}
	
	private function tilemapSetUp():Void
	{
		loader = new FlxOgmoLoader(AssetPaths.Level1__oel);
		tilemap = loader.loadTilemap(AssetPaths.tileset_590x700__png, 64, 64, "Tiles");
		for (i in 0...10)
			tilemap.setTileProperties(i, FlxObject.ANY);
		tilemap.setTileProperties(11, FlxObject.NONE);
		add(tilemap);
	}
	
	private function entityCreator(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));

		switch (entityName)
		{
			case "Player":
				player.setPosition(x, y);
			case "Enemy1":
				enemy = new Slime(x, y);
				enemies.add(enemy);
			case "Enemy2":
				turr = new Turrent(x, y, turrentsBull);
				turrents.add(turr);
			case "PwUp":
				pwUP = new PwUp(x, y);
				pwUps.add(pwUP);
			case "Enemy3":
				boss = new Boss(x, y);
				bossf = new BossFight(x,y);
				add(boss);
				add(bossf);
		}
	}
	
	/*COLISIONES*/
	
	private function colWeaponBoss(w:Weapon, b:Boss):Void
	{
		b.getDamage();
		Reg.weaponAlive = false;
		w.destroy();
	}
	
	private function colPlayerBoss(p: Player, b:Boss):Void
	{
		if (p.getShields() == -1)
			openSubState(new DeathState());
		p.getDamage();
	}
	
	private function colPlayerTurrents(p:Player, t:Turrent):Void
	{
		if (p.getShields() == -1)
			openSubState(new DeathState());
		p.getDamage();
	}
	
	private function colWeaponEnemies(w:Weapon, e:Enemy):Void
	{
		if (FlxFlicker.isFlickering(w))
			e.destroy();
		else
		{
			e.getDamage(w.getCarga());
			Reg.weaponAlive = false;
			w.destroy();
		}
	}
	
	private function colWeaponTurrents(w:Weapon, e:Turrent):Void
	{
		if (FlxFlicker.isFlickering(w))
			e.destroy();
		else
		{
			e.getDamage(w.getCarga());
			Reg.weaponAlive = false;
			w.destroy();
		}
	}
	private function colPlayerEnemies(p:Player, e:Enemy):Void
	{
		if (p.getShields() == -1)
			openSubState(new DeathState());
		p.getDamage();
	}
	
	private function colPlayerBullet(p:Player, b:TurrentBullet):Void
	{
		if (p.getShields() == -1)
			openSubState(new DeathState());
		p.getDamage();
	}
	
	private function colPlayerPwUps(p:Player, pw:PwUp):Void
	{
		FlxG.sound.play(AssetPaths.shield__ogg);
		pw.destroy();
		p.pickShield();
	}
}