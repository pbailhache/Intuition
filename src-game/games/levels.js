/**********************     Level 1      **************************/
Q.scene("level1", function(stage) {
	var background = new Q.TileLayer({
		dataAsset: 'level1.tmx',
		layerIndex: 0,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64,
		type: Q.SPRITE_NONE
	});
	stage.insert(background);
	stage.collisionLayer(new Q.TileLayer({
		dataAsset: 'level1.tmx',
		layerIndex: 1,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64
	}));

	var player = stage.insert(new Q.Player());
	stage.insert(new Q.EndYes({x: 2432, y: 96}));
	stage.insert(new Q.EndNo({x: 1760, y: 864}));
	stage.insert(new Q.End({x: 96, y: 1184}));
	stage.add("viewport").follow(player, {
		x: true,
		y: true
	}, {
		minX: 0,
		maxX: background.p.w,
		minY: 0,
		maxY: background.p.h
	});
});

/**********************     Level 2      **************************/
Q.scene("level2", function(stage) {
	var background = new Q.TileLayer({
		dataAsset: 'level2.tmx',
		layerIndex: 0,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64,
		type: Q.SPRITE_NONE
	});
	stage.insert(background);
	stage.collisionLayer(new Q.TileLayer({
		dataAsset: 'level2.tmx',
		layerIndex: 1,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64
	}));

	var player = stage.insert(new Q.Player());
	stage.insert(new Q.EndYes({x: 2432, y: 96}));
	stage.insert(new Q.EndNo({x: 1760, y: 864}));
	stage.insert(new Q.End({x: 96, y: 1184}));
	stage.add("viewport").follow(player, {
		x: true,
		y: true
	}, {
		minX: 0,
		maxX: background.p.w,
		minY: 0,
		maxY: background.p.h
	});
});