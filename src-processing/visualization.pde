
var canvas = document.getElementById("myCanvas");
var width = canvas.offsetWidth;
var height = canvas.offsetHeight;

// Setup the Processing Canvas
void setup()
{
	size(width, height);
	frameRate(15);
}

// Main draw loop
void draw()
{
	// Fill canvas grey
	background(100);

	fill(0, 121, 184);
	stroke(255);
	strokeWeight(10);
}

