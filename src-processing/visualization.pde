
var fps = 30;
var canvas = document.getElementById("myCanvas");
var width = canvas.offsetWidth;
var height = canvas.offsetHeight;
var tagSize = Math.min(width, height) * 0.5;
var productSize = Math.min(width, height) * 0.015;
var productInnerStroke = productSize * 0.05;
var productInnerSize = productSize * 0.5;
var productLinkSize = productSize;
var tagAlpha = 150;
var backgroundColor = color(255, 255, 255);
var productColor = color(0);
var linkColor = color(50);
var zoom = 1.0;
var centerX = width * 0.5;
var centerY = height * 0.5;
var maxDistance = tagSize * 0.2;
var url = "http://developersrift.projets-bx1.fr/api/getTags";

function getTags()
{
	var XHR = new XMLHttpRequest();
	XHR.onreadystatechange = function()
	{
		if (XHR.readyState == 4)
		{
			
			var tags = XHR.responseText;
			console.log(JSON.parse(tags));
		}		
	};

	XHR.open("GET", url, true);
	XHR.send(null);
}

getTags();


var db = { "tags" : [
					{ "name" : "red", "color" : [112, 0, 0]},
					{ "name" : "green", "color" : [0, 112, 0]},
					{ "name" : "blue", "color" : [0, 0, 112]}
					],
		"products" : [
					{ "name" : "ipod", "tags" : [ {"name" : "red", "score" : 1.0},
													{"name" : "green", "score" : 0.5},
													{ "name" : "blue", "score" : 0.1}]},
					{ "name" : "xbox", "tags" : [ {"name" : "red", "score" : 0.1},
													{"name" : "green", "score" : 0.2},
													{ "name" : "blue", "score" : 0.7}]}, 
					]
		};

// Setup the Processing Canvas
void setup()
{
	size(width, height);
	frameRate(fps);	
}

// Main draw loop
void draw()
{
	// Fill canvas grey
	background(backgroundColor);

	fill(0, 121, 184);
	noStroke();
	
	for (var i = 0; i < db.tags.length; i++)
	{
		var x = tagX(i);
		var y = tagY(i);
		var color = db.tags[i].color;
		fill(color[0], color[1], color[2], tagAlpha);
		ellipse(x, y, tagSize * zoom, tagSize * zoom);
	}
	
	var productsX = new Array();
	var productsY = new Array();
	
	for (var i = 0; i < db.products.length; i++)
	{
		var x = productX(db.products[i]);
		var y = productY(db.products[i]);
		productsX[i] = x;
		productsY[i] = y;
		
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
	}
	
	for (var i = 0; i < db.products.length; i++)
	{
		var x = productsX[i];
		var y = productsY[i];
		noStroke();
		fill(productColor);
		ellipse(x, y, productSize * zoom, productSize * zoom);
		//stroke(255);
		//fill(255);
		//strokeWeight(productInnerStroke * zoom);
		//ellipse(x, y, productInnerSize * zoom, productInnerSize * zoom);
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
	var rotation  = Math.PI * 2 / db.tags.length;
	var rotationOffset = Math.PI * 0.5;
	return centerX + tagSize * zoom * 0.4 * Math.cos(rotation * i + rotationOffset);
}

function tagY(i)
{
	var rotation  = Math.PI * 2 / db.tags.length;
	var rotationOffset = Math.PI * 1.5;
	return centerY + tagSize * zoom * 0.4 * Math.sin(rotation * i + rotationOffset);
}

function productX(product)
{
	var weights = weightSum(product);
	
	var x = 0;
	
	for (var i = 0; i < product.tags.length; i++)
	{
		tagIndex = tagToIndex(product.tags[i].name);
		x += tagX(tagIndex) * product.tags[i].score;
	}
	
	return x / weights;
}

function productY(product)
{
	var weights = weightSum(product);
	
	var y = 0;
	
	for (var i = 0; i < product.tags.length; i++)
	{
		tagIndex = tagToIndex(product.tags[i].name);
		y += tagY(tagIndex) * product.tags[i].score;
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

function tagToIndex(tagName)
{
	for (var i = 0; i < db.tags.length; i++)
	{
		if (db.tags[i].name == tagName)
			return i;
	}
	
	return 0;
}

function weightSum(product)
{
	var weightSum = 0;
	for (var i = 0; i < product.tags.length; i++)
	{
		weightSum += product.tags[i].score;	
	}
	
	return weightSum;
}

