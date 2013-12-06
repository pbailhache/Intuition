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


/**********************     Level 7      **************************/
Q.scene("level7", function(stage) {
	var background = new Q.TileLayer({
		dataAsset: 'level7.tmx',
		layerIndex: 0,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64,
		type: Q.SPRITE_NONE
	});
	stage.insert(background);
	stage.collisionLayer(new Q.TileLayer({
		dataAsset: 'level7.tmx',
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


/**********************     Level 8      **************************/
Q.scene("level8", function(stage) {
	var background = new Q.TileLayer({
		dataAsset: 'level8.tmx',
		layerIndex: 0,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64,
		type: Q.SPRITE_NONE
	});
	stage.insert(background);
	stage.collisionLayer(new Q.TileLayer({
		dataAsset: 'level8.tmx',
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

/**********************     Level 9      **************************/
Q.scene("level9", function(stage) {
	var background = new Q.TileLayer({
		dataAsset: 'level9.tmx',
		layerIndex: 0,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64,
		type: Q.SPRITE_NONE
	});
	stage.insert(background);
	stage.collisionLayer(new Q.TileLayer({
		dataAsset: 'level9.tmx',
		layerIndex: 1,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64
	}));

	var player = stage.insert(new Q.Player({jumpSpeed:-735}));
	stage.insert(new Q.EndYes({x: 12000, y: 480}));
	stage.insert(new Q.EndYes({x: 12192, y: 352}));
	stage.insert(new Q.EndYes({x: 12192, y: 352}));
	stage.insert(new Q.EndYes({x: 12384, y: 224}));
	stage.insert(new Q.EndYes({x: 12576, y: 352}));
	stage.insert(new Q.EndNo({x: 11744, y: 544}));
	stage.insert(new Q.End({x: 32, y: 544}));
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


/**********************     Level 10      **************************/
Q.scene("level10", function(stage) {
	var background = new Q.TileLayer({
		dataAsset: 'level10.tmx',
		layerIndex: 0,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64,
		type: Q.SPRITE_NONE
	});
	stage.insert(background);
	stage.collisionLayer(new Q.TileLayer({
		dataAsset: 'level10.tmx',
		layerIndex: 1,
		sheet: 'tiles',
		tileW: 64,
		tileH: 64
	}));

	var player = stage.insert(new Q.Player({jumpSpeed:-2000}));
	stage.insert(new Q.EndYes({x: 608, y: 544}));
	stage.insert(new Q.EndNo({x: 2016, y: 800}));
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