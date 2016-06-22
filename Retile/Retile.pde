/* 

- drawing strings, maybe just to proximate, too
- drawing curvy strings...

- Adding "drip" weight to tile-dense areas

! Need to be conscious of being able to scale up images 

- Definitely need a pause function

- Try differing width / height
- Try randomising!

- Either rotateTowardsHeading or angularVelocity...
	latter will need updates.

- rings are prett cool :)

- stroke the strings!!

- multiple canvases for drawing at intervals

*/

PApplet SKETCH = this;

int tileSize = 50;
color backgroundColour = color(255);

Selection onscreenTiles = new EmptySelection();

PImage backgroundImage;
PGraphics canvas;

PGraphics exportCanvas;

Selection cSelection = new EmptySelection();
NavierStokesMutator navierStokesMutator = new NavierStokesMutator();
Mutator cMutator = navierStokesMutator;

TilePool tilePool;


PImage textureSource;

boolean displayGuides = false;

int composingWidth = 775;
int composingHeight = 1100;


void setup(){
	size(775, 1100, OPENGL);
	// noSmooth(); // This is required when we want to compile multiple canvases.
	// intialiseProcessIteration(1);
	UI.initialise();
	tilePool = new TilePool(tileSize, tileSize);
	canvas = createGraphics(width, height, OPENGL);
	exportCanvas = createGraphics(width*5, height*5, OPENGL);
    backgroundImage = loadImage("images/monet.jpg");
    resetCanvas();
    resetExportCanvasBackground();
}

void draw(){
	cMutator.passiveUpdate();
	cMutator.mutate(cSelection);
	canvas.beginDraw();
	displayTiles(canvas);
	// displayTilesInIterationsToGraphics(onscreenTiles.contents, canvas);
	canvas.endDraw();
	exportCanvas.beginDraw();
	exportCanvas.pushMatrix();
	exportCanvas.scale(exportCanvas.width / canvas.width);
	displayTiles(exportCanvas);
	exportCanvas.popMatrix();
	exportCanvas.endDraw();

	image(canvas, 0, 0);

	// image(exportCanvas, 500, 0);

	if(displayGuides){
		UI.ui.beginDraw();
		cMutator.display(cSelection, UI.ui);
		UI.ui.endDraw();
		image(UI.ui, 0, 0);
	}

	UI.display();

}

void resetCanvas(){
	canvas.beginDraw();
	canvas.background(backgroundColour);
	canvas.endDraw();
    drawBackgroundImage();
    reTile();
	canvas.beginDraw();
	canvas.background(backgroundColour);
	canvas.endDraw();
}

void resetExportCanvasBackground(){
	exportCanvas.beginDraw();
	exportCanvas.background(backgroundColour);
	exportCanvas.endDraw();
}

void exportImage(){
	print("Exporting image... ");
	String outputName = nf(month(), 2)+"-"+nf(day(), 2)+"-"+nf(minute(), 2)+" "+millis()+".tiff";
	exportCanvas.save("./outputs/"+outputName);
	println("Done! "+outputName);
}

void drawBackgroundImage(){
	canvas.beginDraw();
	canvas.pushMatrix();
	canvas.translate(composingWidth*0.5, composingHeight*0.5);
	canvas.image(backgroundImage, -backgroundImage.width*0.5, -backgroundImage.height*0.5);
	canvas.popMatrix();
	canvas.endDraw();
}

void reTile(){
	reTile(tileSize, tileSize);
}

void reTile(int sizeX, int sizeY){
	// PImage imageToTileFrom = canvas.get();
	reloadTextureSource();
	onscreenTiles = tilePool.produceTileGridOfSizeFromImage(sizeX, sizeY, textureSource);
	SelectionBuilder.setSampleSelection(onscreenTiles);
}

void reloadTextureSource(){
	textureSource = canvas.get();
}


void displayTiles(PGraphics pg){
	for(int k = 0; k<onscreenTiles.contents.length; k++){
		onscreenTiles.contents[k].display(pg);
	}
	canvas.resetShader();
}


void mousePressed(){
	Input.mousePressed();
	refreshRadialSelection();
}

void mouseDragged(){
	refreshRadialSelection();
}

void refreshRadialSelection(){
	cSelection = SelectionBuilder.selectRadial(mouseX, mouseY, 150);
}

void mouseReleased(){
	Input.mouseReleased();
	cSelection = new EmptySelection();
}




