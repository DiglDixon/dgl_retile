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


*/

PApplet SKETCH = this;

float ROOT_TWO = 1.41421356;

int tileSize = 50;
int gridSizeX;
int gridSizeY;
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

int composingWidth = 636;
int composingHeight = 900;


void setup(){
	size(636, 900, OPENGL);
	// noSmooth(); // This is required when we want to compile multiple canvases.
	// intialiseProcessIteration(1);
	UI.initialise();
	tilePool = new TilePool(tileSize, tileSize);
	canvas = createGraphics(width, height, OPENGL);
	exportCanvas = createGraphics(width*5, height*5, OPENGL);
    backgroundImage = loadImage("images/mona.jpg");
    resetCanvas();
    resetExportCanvasBackground();
}

void draw(){
	cMutator.passiveUpdate();
	cMutator.mutate(cSelection);
	canvas.beginDraw();
	drawComposition(canvas);
	canvas.endDraw();
	exportCanvas.beginDraw();
	exportCanvas.pushMatrix();
	exportCanvas.scale(exportCanvas.width / canvas.width);
	drawComposition(exportCanvas);
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
	resetExportCanvasBackground();
}

void resetExportCanvasBackground(){
	exportCanvas.beginDraw();
	exportCanvas.background(backgroundColour);
	exportCanvas.endDraw();
}

void exportImage(){
	print("Exporting image... ");
	String outputName = nf(month(), 2)+"-"+nf(day(), 2)+"-"+nf(hour(), 2)+"-"+nf(minute(), 2)+" "+millis()+".tiff";
	exportCanvas.save("./outputs/"+outputName);
	println("Done! "+outputName);
}

void drawBackgroundImage(){
	canvas.beginDraw();
	canvas.pushMatrix();
	canvas.translate(composingWidth*0.5, composingHeight*0.5);
	canvas.scale(0.8);
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

void drawComposition(PGraphics pg){
	// pg.background(255);
	float thickness = 0.1;
	float interval = 0.05;
	// displayStringsUp(pg, thickness, interval);
	displayStringsAcross(pg, thickness, interval);
	// displayTiles(pg);
	// displayTilesInIterationsToGraphics(onscreenTiles.contents, pg);
}

void displayTiles(PGraphics pg){
	Tile t;
	for(int k = 0; k<onscreenTiles.contents.length; k++){
		t = onscreenTiles.contents[k];
		t.displayTileAsShape(pg);
	}
}
void displayStringsUp(PGraphics pg, float thickness, float interval){
	Tile t;
	Tile pTile;
	for(int k = 1; k<onscreenTiles.arrayWidth; k++){
		for(int j = 0; j<onscreenTiles.arrayHeight; j++){
			pTile = onscreenTiles.contents[(k-1)+j*onscreenTiles.arrayWidth];
			t = onscreenTiles.contents[k+j*onscreenTiles.arrayWidth];	
			drawStringsBetweenEdges(pg, pTile.transform.vertexSet.rightEdge, t.transform.vertexSet.leftEdge, thickness, interval);
		}
	}
}

void displayStringsAcross(PGraphics pg, float thickness, float interval){
	Tile t;
	Tile pTile;
	for(int k = 0; k<onscreenTiles.arrayWidth; k++){
		for(int j = 1; j<onscreenTiles.arrayHeight; j++){
			pTile = onscreenTiles.contents[k+(j-1)*onscreenTiles.arrayWidth];
			t = onscreenTiles.contents[k+j*onscreenTiles.arrayWidth];	
			drawStringsBetweenEdges(pg, pTile.transform.vertexSet.bottomEdge, t.transform.vertexSet.topEdge, thickness, interval);
		}
	}
}

void drawStringsBetweenEdges(PGraphics pg, TileTransformEdge edgeFrom, TileTransformEdge edgeTo, float thickness, float interval){
	float step = thickness+interval;
	TileVertex tv;
	// pg.stroke(0);
	pg.noStroke();
	for(float k = interval; k<(1-step); k+=step){
		pg.beginShape();
		pg.texture(textureSource);
		tv = TileTransformTools.getVertexValuesAlongEdge(edgeFrom, k);
		pg.vertex(tv.position.x, tv.position.y, tv.uv.x, tv.uv.y);
		tv = TileTransformTools.getVertexValuesAlongEdge(edgeFrom, k+thickness);
		pg.vertex(tv.position.x, tv.position.y, tv.uv.x, tv.uv.y);
		tv = TileTransformTools.getVertexValuesAlongEdge(edgeTo, (1-k));
		pg.vertex(tv.position.x, tv.position.y, tv.uv.x, tv.uv.y);
		tv = TileTransformTools.getVertexValuesAlongEdge(edgeTo, (1-k+thickness));
		pg.vertex(tv.position.x, tv.position.y, tv.uv.x, tv.uv.y);
		pg.endShape();
	}
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




