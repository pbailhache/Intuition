Q.scene('endGame', function(stage) {
	var box = stage.insert(new Q.UI.Container({
		x: Q.width / 2, y: Q.height / 2, fill: "rgba(0,0,0,0.5)"
	}));

	var button = box.insert(new Q.UI.Button({x: 0, y: 0, fill: "#CCCCCC",
		label: "Aller au niveau suivant"}))
	var label = box.insert(new Q.UI.Text({x: 10, y: -10 - button.p.h,
		label: stage.options.label}));
	button.on("click", function() {
		Q.clearStages();
		window.levelGame++;
		Q.stageScene('level'+window.levelGame);
	});
	box.fit(20);
});

//load assets
Q.load("tiles.png, player.png, level1.tmx, level2.tmx, level3.tmx, level4.tmx, level5.tmx, level6.tmx, blackflaggreen.png, blackflagred.png, blackflaggrey.png", function() {
	Q.sheet("tiles", "tiles.png", {
		tilew: 64,
		tileh: 64
	});
	Q.stageScene("level6");
});