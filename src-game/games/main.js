window.levelGame = 1;
window.maxLevel = 9;
window.levelTag = "";
window.rating = 0;

var Q = Quintus().include("Sprites, Scenes, Input, 2D, Audio, Touch, UI, Audio").setup({
	width: 960,
	height: 640
}).controls().touch().enableSound();

Q.Sprite.extend("Player", {
	init: function(p) {
		this._super(p, {
			asset: "player.png",
			x: 96,
			y: 50,
			jumpSpeed: -800
		});
		this.add('2d, platformerControls');

		this.on("hit.sprite", function(collision)
		{
			if (collision.obj.isA("EndYes"))
			{
				window.rating = 1;
				Q.stageScene("endGame", 1, {label: "Vous avez dit oui ! :)"});
				this.destroy();
			}
			else if(collision.obj.isA("EndNo"))
			{
				window.rating = -1;
				Q.stageScene("endGame", -1, {label: "Vous avez dit non ! :'("});
				this.destroy();
			}
			else if(collision.obj.isA("End"))
			{
				window.rating = 0;
				Q.stageScene("endGame", 0, {label: "Vous passez… -_-"});
				this.destroy();
			}
		});
	}
});

Q.Sprite.extend("EndYes", {
	init: function(p) {
		this._super(p, {asset: "blackflaggreen.png"});
	}
});

Q.Sprite.extend("EndNo", {
	init: function(p) {
		this._super(p, {asset: "blackflagred.png"});
	}
});

Q.Sprite.extend("End", {
	init: function(p) {
		this._super(p, {asset: "blackflaggrey.png"});
	}
});