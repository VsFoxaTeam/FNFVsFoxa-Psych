package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
//taken from Kade's OutdatedSubState
class ThanksState extends MusicBeatState
{
	private var colorShitters:Array<String> = [
		'#314d7f',
		'#4e7093',
		'#70526e',
		'#594465'
	];
	private var colorRotation:Int = 1;

	override function create()
	{
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		var theLogoThing:FlxSprite = new FlxSprite(FlxG.width, 0).loadGraphic(Paths.image('logo'));
		theLogoThing.scale.y = 0.3;
		theLogoThing.scale.x = 0.3;
		theLogoThing.x -= theLogoThing.frameHeight;
		theLogoThing.y -= 180;
		theLogoThing.alpha = 0.8;
		theLogoThing.antialiasing = ClientPrefs.globalAntialiasing;
		add(theLogoThing);

		var txt:FlxText = new FlxText(0, 0, FlxG.width,
			"Thanks for playing Vs. Foxa 3.0!\nYou are on a Dev Build.\nIf you were given this by someone who isn't a dev,\nplease contact one of the devs. "
			+ "\n\nPress Enter to continue.",
			32);

		txt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.fromRGB(200, 200, 200), CENTER);
		txt.borderColor = FlxColor.BLACK;
		txt.borderSize = 2.3;
		txt.borderStyle = FlxTextBorderStyle.OUTLINE;
		txt.screenCenter();
		add(txt);

		FlxTween.color(bg, 2, bg.color, FlxColor.fromString(colorShitters[colorRotation]));
		FlxTween.angle(theLogoThing, theLogoThing.angle, -10, 2, {ease: FlxEase.quartInOut});

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			FlxTween.color(bg, 2, bg.color, FlxColor.fromString(colorShitters[colorRotation]));
			if(colorRotation < (colorShitters.length - 1)) colorRotation++;
			else colorRotation = 0;
		}, 0);

		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			if(theLogoThing.angle == -10) FlxTween.angle(theLogoThing, theLogoThing.angle, 10, 2, {ease: FlxEase.quartInOut});
			else FlxTween.angle(theLogoThing, theLogoThing.angle, -10, 2, {ease: FlxEase.quartInOut});
		}, 0);

		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			if(theLogoThing.alpha == 0.8) FlxTween.tween(theLogoThing, {alpha: 1}, 0.8, {ease: FlxEase.quartInOut});
			else FlxTween.tween(theLogoThing, {alpha: 0.8}, 0.8, {ease: FlxEase.quartInOut});
		}, 0);

        super.create();
	}

	override function update(elapsed:Float)
	{
        if (controls.ACCEPT || controls.BACK) FlxG.switchState(new MainMenuState());

		super.update(elapsed);
	}
}