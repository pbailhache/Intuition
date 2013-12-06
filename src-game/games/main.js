window.levelGame = 1;

var Q = Quintus().include("Sprites, Scenes, Input, 2D, Touch, UI").setup({
	width: 960,
	height: 640
}).controls().touch();

Q.Sprite.extend("Player", {
	init: function(p) {
		this._super(p, {
			asset: "player.png",
			x: 110,
			y: 50,
			jumpSpeed: -380
		});
		this.add('2d, platformerControls');

		this.on("hit.sprite", function(collision)
		{
			if (collision.obj.isA("EndYes"))
			{
				Q.stageScene("endGame", window.levelGame, {label: "Vous avez dit oui ! :)"});
				this.destroy();
			}
			else if(collision.obj.isA("EndNo"))
			{
				Q.stageScene("endGame", window.levelGame, {label: "Vous avez dit non ! :'("});
				this.destroy();
			}
			else if(collision.obj.isA("End"))
			{
				Q.stageScene("endGame", window.levelGame, {label: "Vous passez… -_-"});
				this.destroy();
			}
		});
	}
});

Q.Sprite.extend("EndYes", {
	init: function(p) {
		this._super(p, {asset: "player.png"});
	}
});

Q.Sprite.extend("EndNo", {
	init: function(p) {
		this._super(p, {asset: "player.png"});
	}
});

Q.Sprite.extend("End", {
	init: function(p) {
		this._super(p, {asset: "player.png"});
	}
});