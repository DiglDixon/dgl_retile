import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Retile extends PApplet {

/* 
Pre-loaded high res images.
No need for controls, just go keys.

*/

PApplet SKETCH = this;

int tileCountX, tileCountY;
int tileSize = 50;

Selection onscreenTiles = new EmptySelection();

PImage backgroundImage;
PGraphics canvas;

Selection cSelection = new EmptySelection();
Mutator cMutator = new PositionMutator();

TilePool tilePool;


public void setup(){
	
	UI.initialise();
	tilePool = new TilePool(10, 10);
	canvas = createGraphics(width, height, P2D);
    backgroundImage = loadImage("monet.jpg");
    drawBackgroundImage();
    reTile(200, 200);
}

public void drawBackgroundImage(){
	canvas.beginDraw();
	canvas.image(backgroundImage, 0, 0);
	canvas.endDraw();
}

public void reTile(){
	reTile(tileSize, tileSize);
}

public void reTile(int sizeX, int sizeY){
	PImage imageToTileFrom = canvas.get();
	onscreenTiles = tilePool.produceTileGridOfSizeFromImage(sizeX, sizeY, imageToTileFrom);
	SelectionBuilder.setSampleSelection(onscreenTiles);
}


public void draw(){

	cMutator.mutate(cSelection);

	canvas.beginDraw();
	canvas.background(0);

	for(int k = 0; k<onscreenTiles.contents.length;k++){
		onscreenTiles.contents[k].display(canvas);
	}

	canvas.endDraw();
	image(canvas, 0, 0);
	UI.display();
}


public void mousePressed(){
	Input.mousePressed();
	refreshRadialSelection();
}

public void mouseDragged(){
	refreshRadialSelection();
}

public void refreshRadialSelection(){
	releaseSelection(cSelection);
	cSelection = SelectionBuilder.selectRadial(mouseX, mouseY, 150);
	grabSelection(cSelection);
}

public void mouseReleased(){
	Input.mouseReleased();
	releaseSelection(cSelection);
	cSelection = new EmptySelection();
}


public void grabSelection(Selection selection){
	for(int k = 0; k<selection.contents.length; k++){
		selection.contents[k].grab();
	}
}

public void releaseSelection(Selection selection){
	for(int k = 0; k<selection.contents.length; k++){
		selection.contents[k].release();
	}
}


public void keyPressed() {
    switch(key) {
    	case ' ':
    	reTile();
    	break;
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        numberKeyPressed(Integer.parseInt(key+""));
        break;
        default:
        //unknown key
        break;
    }
}

public void numberKeyPressed(int n){
	if(n>0){
		tileSize = n*10;
		println("Changed tile size: "+tileSize);
	}
}


//

// pseudo-static
_Input Input = new _Input();
public class _Input{

	public PVector mouseVelocity = new PVector();
	public PVector mousePosition = new PVector();
	public float mouseX;
	public float mouseY;

	public boolean mouseDown = false;

	public _Input(){
		registerMethod("draw", this);
	}

	public void draw(){

		this.mouseVelocity.x = SKETCH.mouseX - this.mouseX;
		this.mouseVelocity.y = SKETCH.mouseY - this.mouseY;

		this.mouseX = SKETCH.mouseX;
		this.mouseY = SKETCH.mouseY;
		mousePosition.x = this.mouseX;
		mousePosition.y = this.mouseY;
	}

	public void keyPressed(char key){

	}
	public void keyReleased(char key){

	}
	public void mousePressed(){
		mouseDown = true;
	}
	public void mouseReleased(){
		mouseDown = false;
	}

}

interface Mutator{
	public void mutate(Selection selection);
}

class NullMutator implements Mutator{
	public void mutate(Selection selection){
		// Nothing
	}
}

class PositionMutator implements Mutator{

	public PositionMutator(){

	}

	public void mutate(Selection selection){
		for(int k = 0; k<selection.contents.length; k++){
			// selection.contents[k].move(PVector.mult(Input.mouseVelocity, selection.weights[k]));
			selection.contents[k].move(PVector.mult(Input.mouseVelocity, selection.weights[k]));
		}
	}

}

// data structure
class Selection{
	public Tile[] contents;
	public float[] weights;
	public int arrayWidth;
	public int arrayHeight;

	public Selection(Tile[] contents, float[] weights, int w, int h){
		this.contents = contents;
		this.weights = weights;
		this.arrayWidth = w;
		this.arrayHeight = h;
	}
}

class WeightlessSelection extends Selection{
	public WeightlessSelection(Tile[] contents, int w, int h){
		super(contents, new float[contents.length], w, h);
		for(int k = 0; k<weights.length; k++){
			weights[k] = 1;
		}
	}

}

class EmptySelection extends Selection{
	public EmptySelection(){
		super(new Tile[0], new float[0], 0, 0);
	}
}

// pseudo-static
_SelectionBuilder SelectionBuilder = new _SelectionBuilder();
class _SelectionBuilder{

	Selection sampleSelection;

	public _SelectionBuilder(){
		setSampleSelection(new EmptySelection());
	}

	public void setSampleSelection(Selection newSampleSelection){
		sampleSelection = newSampleSelection;
	}

	public Selection selectSingleTile(float x, float y){
		Tile[] hitTile = new Tile[1];
		for(int k = 0; k<sampleSelection.contents.length;k++){
			if(sampleSelection.contents[k].containsPoint(x, y)){
				hitTile[0] = sampleSelection.contents[k];
				return new WeightlessSelection(hitTile, sampleSelection.arrayWidth, sampleSelection.arrayHeight);
			}
		}
		return new EmptySelection();
	}

	public Selection selectRadial(float x, float y, float radius){
		float inv_radius = 1/radius;

		float[] weights = new float[sampleSelection.contents.length];
		int[] hitIndices = new int[sampleSelection.contents.length];
		int hitCount = 0;
		PVector tileCentrePosition;
		float distance;
		for(int k = 0; k<sampleSelection.contents.length; k++){
			tileCentrePosition = sampleSelection.contents[k].centrePosition();
			distance = dist(tileCentrePosition.x, tileCentrePosition.y, x, y);
			if(distance < radius){
				hitIndices[hitCount] = k;
				weights[hitCount] = (radius-distance) * inv_radius;
				hitCount++;
			}
		}
		Tile[] hitTiles = new Tile[hitCount];
		for(int k = 0; k < hitCount; k++){
			hitTiles[k] = sampleSelection.contents[hitIndices[k]];
		}
		return new Selection(hitTiles, weights, sampleSelection.arrayWidth, sampleSelection.arrayHeight);
	}

}

class Tile{

	private PVector position;
	private PVector size;
	private float rotation;
	private PImage tileImage;
	private boolean grabbed = false;

	public Tile(){
		position = new PVector();
		size = new PVector();
		tileImage = createImage(1, 1, ARGB);
	}

	// This is headed for deppn
	public Tile(float x, float y, PImage img){
		tileImage = img;
		position = new PVector(x, y);
		size = new PVector(img.width, img.height);
	}

	public void setParametersFromTileSetData(TileSetData data, int xIndex, int yIndex){
		position.x = xIndex*data.tileWidth;
		position.y = yIndex*data.tileHeight;
		resizeTile(data.tileWidth, data.tileHeight);
	}

	private void resizeTile(int w, int h){
		size.x = w;
		size.y = h;
		tileImage.resize(w, h);
	}

	// This requires pixels to already be loaded in baseImage - how can we make this clearer?
	public void loadImageFromBaseImage(PImage baseImage){
		tileImage.loadPixels();
		int x = floor(position.x);
		int y = floor(position.y);
		for(int k = 0; k<tileImage.width; k++){
			for(int j = 0; j<tileImage.height; j++){
				tileImage.pixels[k + tileImage.width*j] = baseImage.pixels[(x+k)+(y+j)*baseImage.width];
			}
		}
		tileImage.updatePixels();
	}

	public void move(PVector velocity){
		position.add(velocity);
	}

	public void grab(){
		grabbed = true;
	}

	public void release(){
		grabbed = false;
	}

	public PVector centrePosition(){
		return PVector.add(position, PVector.mult(size, 0.5f));
	}

	public boolean containsPoint(float x, float y){
		return (x > position.x && y > position.y && x<position.x+size.x && y<position.y+size.y);
	}

	public void display(PGraphics pg){
		pg.pushMatrix();
		pg.translate(position.x+size.x*0.5f, position.y+size.y*0.5f);
		pg.rotate(rotation);
		pg.image(tileImage, -size.x*0.5f, -size.y*0.5f);
		if(grabbed){
			pg.noFill();
			pg.stroke(255, 20);
			pg.strokeWeight(1);
			pg.rect(-size.x*0.5f, -size.y*0.5f, size.x, size.y);
		}
		pg.popMatrix();
	}



}

class TileSetData{
	public int tilesX;
	public int tilesY;
	public int tileWidth;
	public int tileHeight;
	public TileSetData(){
	}
}


class TilePool{

	private Tile[] tiles = new Tile[0];
	private int maxWidth = width;
	private int maxHeight = height;
	private int minTileSizeX;
	private int minTileSizeY;
	private int maxTilesX = 1;
	private int maxTilesY = 1;

	public TilePool(int minSizeX, int minSizeY){
		setMinTileDimensions(minSizeX, minSizeY);
	}

	private void setMinTileDimensions(int x, int y){
		minTileSizeX = x;
		minTileSizeY = y;
		recalculateMaxScreenDimensions();
	}

	private void recalculateMaxScreenDimensions(){
		maxTilesX = maxWidth / minTileSizeX;
		maxTilesY = maxHeight / minTileSizeY;
		if(maxTilesX*maxTilesY > tiles.length){
			println("New resolution parameters require a larger TilePool array - renewing...");
			renewTilesArray();
		}
	}

	private void renewTilesArray(){
		tiles = new Tile[maxTilesX*maxTilesY];
		for(int k = 0; k<tiles.length; k++){
			tiles[k] = new Tile();
		}
		println("Renewed tiles array with a length: "+tiles.length);
	}

	private void setMaxScreenDimensions(int x, int y){
		maxWidth = x;
		maxHeight = y;
		recalculateMaxScreenDimensions();
	}

	public Selection produceTileGridOfSizeFromImage(int sizeX, int sizeY, PImage baseImage){
		baseImage.loadPixels();

		int tilesX = floor(maxWidth/sizeX);
		int tilesY = floor(maxHeight/sizeY);

		TileSetData newSetData = new TileSetData();
		newSetData.tilesX = tilesX;
		newSetData.tilesY = tilesY;
		newSetData.tileWidth = sizeX;
		newSetData.tileHeight = sizeY;

		Tile[] activeTiles = new Tile[tilesX * tilesY];

		Tile iTile;
		for(int k = 0; k<tilesX; k++){
			for(int j = 0; j<tilesY; j++){
				iTile = tiles[k+j*tilesX];
				iTile.setParametersFromTileSetData(newSetData, k, j);
				iTile.loadImageFromBaseImage(baseImage);
				activeTiles[k+j*tilesX] = iTile;
			}
		}

		for(int k = tilesX; k<maxTilesX; k++){
			for(int j = tilesY; j<maxTilesY; j++){
				// deactivate
			}
		}

		return new WeightlessSelection(activeTiles, tilesX, tilesY);

	}


}

//pseudo-static
_UI UI = new _UI();
public class _UI{
	PGraphics ui;
	
	public _UI(){
	}

	public void initialise(){
		ui = createGraphics(width, height, P2D);
	}

	public void display(){
		ui.beginDraw();
		ui.clear();
		ui.text("fps: "+frameRate, 50, 50);
		ui.endDraw();
		image(ui, 0, 0);
	}
}
    public void settings() { 	size(1080, 1080, P2D); }
    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[] { "Retile" };
        if (passedArgs != null) {
          PApplet.main(concat(appletArgs, passedArgs));
        } else {
          PApplet.main(appletArgs);
        }
    }
}
