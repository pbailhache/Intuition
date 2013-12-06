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

/**********************     Level 3      **************************/
Q.scene("level3", function(stage) {
	var background = new Q.TileLayer({
		dataAsset: 'level3.tmx',
		layerIndex: 0,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64,
		type: Q.SPRITE_NONE
	});
	stage.insert(background);
	stage.collisionLayer(new Q.TileLayer({
		dataAsset: 'level3.tmx',
		layerIndex: 1,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64
	}));

	var player = stage.insert(new Q.Player());
	stage.insert(new Q.EndYes({x: 2400, y: 96}));
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


/**********************     Level 4      **************************/
Q.scene("level4", function(stage) {
	var background = new Q.TileLayer({
		dataAsset: 'level4.tmx',
		layerIndex: 0,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64,
		type: Q.SPRITE_NONE
	});
	stage.insert(background);
	stage.collisionLayer(new Q.TileLayer({
		dataAsset: 'level4.tmx',
		layerIndex: 1,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64
	}));

	var player = stage.insert(new Q.Player());
	stage.insert(new Q.EndYes({x: 2400, y: 96}));
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


/**********************     Level 5      **************************/
Q.scene("level5", function(stage) {
	var background = new Q.TileLayer({
		dataAsset: 'level5.tmx',
		layerIndex: 0,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64,
		type: Q.SPRITE_NONE
	});
	stage.insert(background);
	stage.collisionLayer(new Q.TileLayer({
		dataAsset: 'level5.tmx',
		layerIndex: 1,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64
	}));

	var player = stage.insert(new Q.Player());
	stage.insert(new Q.EndYes({x: 2400, y: 160}));
	stage.insert(new Q.EndNo({x: 1952, y: 864}));
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


/**********************     Level 6      **************************/
Q.scene("level6", function(stage) {
	var background = new Q.TileLayer({
		dataAsset: 'level6.tmx',
		layerIndex: 0,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64,
		type: Q.SPRITE_NONE
	});
	stage.insert(background);
	stage.collisionLayer(new Q.TileLayer({
		dataAsset: 'level6.tmx',
		layerIndex: 1,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64
	}));

	var player = stage.insert(new Q.Player());
	stage.insert(new Q.EndYes({x: 2400, y: 96}));
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