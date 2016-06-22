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

int tileCountX, tileCountY;
int tileSize = 50;
int iterationSteps = 1;

Selection onscreenTiles = new EmptySelection();

PImage backgroundImage;
PGraphics canvas;

Selection cSelection = new EmptySelection();
Mutator cMutator = new PositionMutator();
NavierStokesMutator navierStokesMutator = new NavierStokesMutator();

TilePool tilePool;


PImage textureSource;

boolean displayGuides = true;


void setup(){
	size(1080, 1080, P3D);
	// noSmooth();
	intialiseProcessIteration(1);
	UI.initialise();
	tilePool = new TilePool(40, 40);
	canvas = createGraphics(width, height, P2D);
    backgroundImage = loadImage("monet.jpg");
    resetCanvas();
}

void draw(){
	cMutator.passiveUpdate();
	cMutator.mutate(cSelection);
	canvas.beginDraw();

	displayTiles(canvas);
	// displayTilesInIterationsToGraphics(onscreenTiles.contents, canvas);

	canvas.endDraw();

	image(canvas, 0, 0);

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
	canvas.background(150);
	canvas.endDraw();
    drawBackgroundImage();
    reTile(50, 50);
	canvas.beginDraw();
	canvas.background(150);
	canvas.endDraw();
}


void drawBackgroundImage(){
	canvas.beginDraw();
	canvas.pushMatrix();
	canvas.translate(width*0.5, height*0.5);
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
	for(int k=(frameCount%iterationSteps); k<onscreenTiles.contents.length; k+=iterationSteps){
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




