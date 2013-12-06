Q.scene('endGame', function(rating) {
	var rateTag = new XMLHttpRequest();

	rateTag.onreadystatechange = function() {
		if (rateTag.readyState == 4)
		{
			var getAvailProducts = new XMLHttpRequest();

			getAvailProducts.onreadystatechange = function() {
				if (getAvailProducts.readyState == 4)
				{
					if (getAvailProducts.responseText != "null")
					{
						var products = JSON.parse(getAvailProducts.responseText);
						for (var i = 0; i < products.length; i++)
						{
							var link = document.createElement("a");
							var productsDiv = document.getElementById("products");
							link.className = "product";
							link.href = products[i].url;
							link.setAttribute("target","_blank");
							link.innerHTML = '<img src="' + products[i].imageURL + '" alt="' + products[i].name + '" title="' + products[i].name + '"/>';

							productsDiv.appendChild(link);
						}


						var resetTags = new XMLHttpRequest();
						resetTags.onreadystatechange = function() {};
						resetTags.open("GET", "http://developersrift.projets-bx1.fr/api/resetUserTags", true);
						resetTags.send(null);
					}
					var getNewTag = new XMLHttpRequest();

					getNewTag.onreadystatechange = function() {
						if (getNewTag.readyState == 4)
						{
							Q.clearStages();
							window.levelGame++;
							if (window.levelGame > window.maxLevel)
								window.levelGame = 1;
							var response = JSON.parse(getNewTag.responseText);
							document.getElementById("title").innerHTML = response.name;
							document.getElementById("quintus_container").style.background = "#" + response.color;
							window.levelTag = response.name;
							Q.stageScene('level' + window.levelGame);
						}
					};
					getNewTag.open("GET", "http://developersrift.projets-bx1.fr/api/getNewTag", true);
					getNewTag.send(null);

				}
			};
			getAvailProducts.open("GET", "http://developersrift.projets-bx1.fr/api/getAvailProducts", true);
			getAvailProducts.send(null);
		}
	};
	rateTag.open("GET", "http://developersrift.projets-bx1.fr/api/rateTag?tag=" + window.levelTag + "&rating=" + window.rating, true);
	rateTag.send(null);

});

//load assets
Q.load("tiles.png, player.png, level1.tmx, level2.tmx, level3.tmx, level4.tmx, level5.tmx, level6.tmx, level7.tmx, level8.tmx, level9.tmx, level10.tmx, blackflaggreen.png, blackflagred.png, blackflaggrey.png, music.mp3, mario.mp3", function() {
	Q.sheet("tiles", "tiles.png", {
		tilew: 64,
		tileh: 64
	});
	var XHR = new XMLHttpRequest();

	XHR.onreadystatechange = function() {
		if (XHR.readyState == 4)
		{
			var response = JSON.parse(XHR.responseText);
			document.getElementById("title").innerHTML = response.name;
			document.getElementById("quintus_container").style.background = "#" + response.color;
			window.levelTag = response.name;
			Q.stageScene("level1");
		}
	};
	XHR.open("GET", "http://developersrift.projets-bx1.fr/api/getNewTag", true);
	XHR.send(null);
});