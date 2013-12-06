
var fps = 30;
var canvas = document.getElementById("myCanvas");
var width = canvas.offsetWidth;
var height = canvas.offsetHeight;
var tagSize = Math.min(width, height) * 0.5;
var productSize = Math.min(width, height) * 0.01;
var productInnerStroke = productSize * 0.05;
var productInnerSize = productSize * 0.5;
var productLinkSize = productSize;
var tagAlpha = 255;
var backgroundColor = color(255, 255, 255);
var productColor = color(0);
var linkColor = color(50);
var zoom = 1.0;
var centerX = width * 0.5;
var centerY = height * 0.5;
var maxDistance = tagSize * 0.2;
var tags = [];
var products = [];
var productTags = [];
var maxProductDistance = 1;
var selectedProduct = -1;

getTags();
getProducts();

void setup()
{
	size(width, height);
	frameRate(fps);	
}

void draw()
{
	background(backgroundColor);
	noStroke();
	
	var tagsX = new Array();
	var tagsY = new Array();
	for (var i = 0; i < tags.length; i++)
	{
		var x = tagX(i);
		var y = tagY(i);
		tagsX[tags[i].id] = x;
		tagsY[tags[i].id] = y;
		var c = "0xFF" + tags[i].color;
		fill(c, tagAlpha);
		ellipse(x, y, productSize * zoom, productSize * zoom);
		if (x < centerX)
		{
			textAlign(RIGHT);
			x -= productSize * zoom;
		}
		else
		{
			textAlign(LEFT);
			x += productSize * zoom;
		}
		text(tags[i].name, x, y);
	}
	
	var productsX = new Array();
	var productsY = new Array();
	var selectedFound = false;
	
	for (var i = 0; i < products.length; i++)
	{
		var x = productX(products[i]);
		var y = productY(products[i]);
		var d = distance(centerX, centerY, x, y) / zoom;
		if (d > maxProductDistance)
		{
			maxProductDistance = d;
		}
		
		var scale = tagSize / maxProductDistance * 0.35;
		productsX[i] = centerX + scale * (x - centerX);
		productsY[i] = centerY + scale * (y - centerY);
		
		if (selectedFound == false && distance(mouseX, mouseY, productsX[i], productsY[i]) < productSize)
		{
			selectedProduct = i;
			selectedFound = true;
			var productId = products[i].id;
			for (var k = 0; k < productTags[productId].length; k++)
			{
				var tagId = productTags[productId][k].tag;
				var c = "0xFF" + tags[tagIdToIndex(tagId)].color;
				stroke(c, tagAlpha);
				var weight = productTags[productId][k].score * productSize;
				strokeWeight(weight); 
				
				line(productsX[i], productsY[i], tagsX[tagId], tagsY[tagId]);
			}
		}
		
		/*
		for (var j = 0; j < i; j++)
		{
			var s = similarity(x, y, productsX[j], productsY[j], zoom);
			if (s > 0)
			{
				stroke(linkColor);
				strokeWeight(productLinkSize * s * zoom);
				line(x, y, productsX[j], productsY[j]);
			}
		}
		*/
	}
	
	if (selectedFound == false)
	{
		selectedProduct = -1;
	}
	
	for (var i = 0; i < products.length; i++)
	{
		noStroke();
		fill(productColor);
		var x = productsX[i];
		var y = productsY[i];
		if (i == selectedProduct)
		{
			fill(0);
			textAlign(CENTER);
			textSize(18);
			text(products[i].name, width / 2, height - 30);
		}
		ellipse(x, y, productSize, productSize);
	}
}

void mouseDragged()
{
	var dx = mouseX - pmouseX;
	var dy = mouseY - pmouseY;
	
	centerX += dx;
	centerY += dy;
}

void mouseScrolled()
{
	if (mouseScroll > 0)
	{
		zoom *= 1.05;
	}
	else
	{
		zoom *= 0.95;
	}
}

function tagX(i)
{
	var rotation  = Math.PI * 2 / tags.length;
	var rotationOffset = Math.PI * 0.5;
	return centerX + tagSize * zoom * 0.4 * Math.cos(rotation * i + rotationOffset);
}

function tagY(i)
{
	var rotation  = Math.PI * 2 / tags.length;
	var rotationOffset = Math.PI * 1.5;
	return centerY + tagSize * zoom * 0.4 * Math.sin(rotation * i + rotationOffset);
}

function productX(product)
{
	if (productTags[product.id].length == 0)
		return centerX;
	
	var weights = weightSum(product.id);
	
	var x = 0;
	
	for (var i = 0; i < productTags[product.id].length; i++)
	{
		tagIndex = tagIdToIndex(productTags[product.id][i].tag);
		x += tagX(tagIndex) * productTags[product.id][i].score;
	}
	
	return x / weights;
}

function productY(product)
{
	if (productTags[product.id].length == 0)
		return centerY;
	
	var weights = weightSum(product.id);
	
	var y = 0;
	
	for (var i = 0; i < productTags[product.id].length; i++)
	{
		tagIndex = tagIdToIndex(productTags[product.id][i].tag);
		y += tagY(tagIndex) * productTags[product.id][i].score;
	}
	
	return y / weights;
}

function similarity(ax, ay, bx, by, zoom)
{
	var d = distance(ax, ay, bx, by);
	if (d == 0)
		return 1.0;
	if (d / zoom > maxDistance)
		return 0;
	console.log(d / zoom);
	return Math.max(0.1, 1 / distance(ax, ay, bx, by));
}

function distance(ax, ay, bx, by)
{
	var dx = ax - bx;
	var dy = ay - by;
	return Math.sqrt(dx * dx + dy * dy);
}

function tagIdToIndex(tagId)
{
	for (var i = 0; i < tags.length; i++)
	{
		if (tags[i].id == tagId)
			return i;
	}
	
	return 0;
}

function weightSum(productId)
{
	var weightSum = 0;
	for (var i = 0; i < productTags[productId].length; i++)
	{
		weightSum += productTags[productId][i].score;	
	}
	
	return weightSum;
}

function getTags()
{
	var url = "http://developersrift.projets-bx1.fr/api/getTags";
	var XHR = new XMLHttpRequest();
	XHR.onreadystatechange = function()
	{
		if (XHR.readyState == 4)
		{
			tags = JSON.parse(XHR.responseText);
		}		
	};

	XHR.open("GET", url, true);
	XHR.send(null);
}

function getProducts()
{
	var url = "http://developersrift.projets-bx1.fr/api/getProducts";
	var XHR = new XMLHttpRequest();
	XHR.onreadystatechange = function()
	{
		if (XHR.readyState == 4)
		{
			products = JSON.parse(XHR.responseText);
			for (int i = 0; i < products.length; i++)
			{
				productTags[products[i].id] = [];
				getProductTags(products[i].id);
			}
		}		
	};

	XHR.open("GET", url, true);
	XHR.send(null);
}

function getProductTags(id)
{
	var url = "http://developersrift.projets-bx1.fr/api/getProductTagsByProduct?id=" + id;
	var XHR = new XMLHttpRequest();
	XHR.onreadystatechange = function()
	{
		if (XHR.readyState == 4)
		{	
			var res = XHR.responseText;
			productTags[id] = JSON.parse(res);
		}		
	};

	XHR.open("GET", url, true);
	XHR.send(null);
}

