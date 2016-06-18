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

Tile[] tiles;
int tileCountX, tileCountY;
ArrayList grabbedTiles;
int tileSize = 50;

PImage backgroundImage;
PGraphics canvas;
PGraphics ui;

SelectionBuilder allSelect;

public void setup(){
	
	canvas = createGraphics(width, height);
	ui = createGraphics(width, height);
    backgroundImage = loadImage("monet.jpg");
    grabbedTiles = new ArrayList<Tile>();
    drawBackgroundImage();
    reTile();
    float[] weight = {1.0f};
    allSelect = new SelectionBuilder(new Selection(tiles, weight, tileCountX, tileCountY));
}

public void drawBackgroundImage(){
	canvas.beginDraw();
	canvas.image(backgroundImage, 0, 0);
	canvas.endDraw();
}


public void draw(){
	canvas.beginDraw();
	canvas.background(0);
	for(int k = 0; k<tiles.length;k++){
		tiles[k].display(canvas);
	}
	canvas.endDraw();
	image(canvas, 0, 0);
	displayUI();
}

public void reTile(){
	reTile(tileSize);
}

public void reTile(int size){
	tileCountX = floor(width / size);
	tileCountY = floor(height / size);
	tiles = new Tile[tileCountX*tileCountY];
	int x;
	int y;
	for(int k = 0; k<tileCountX; k++){
		for(int j = 0; j<tileCountY; j++){
			x = k * size;
			y = j * size;
			tiles[k+j*tileCountX] = new Tile(x, y, canvas.get(x, y, size, size));
		}
	}
}

public void displayUI(){
	ui.beginDraw();
	ui.clear();
	ui.text("fps: "+frameRate, 50, 50);
	ui.endDraw();
	image(ui, 0, 0);
}

public void mousePressed(){
	PVector mousePosition = new PVector(mouseX, mouseY);
	Selection selection = allSelect.selectRadial(mouseX, mouseY, 150);
	grabSelction(selection);
}

public void grabSelction(Selection selection){
	for(int k = 0; k<selection.contents.length; k++){
		selection.contents[k].grab();
	}
}

public void releaseSelection(Selection selection){
	for(int k = 0; k<selection.contents.length; k++){
		selection.contents[k].release();
	}
}

public void mouseReleased(){
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

class EmptySelection extends Selection{
	public EmptySelection(){
		super(new Tile[0], new float[0], 0, 0);
	}
}



class SelectionBuilder{

	Selection sampleSelection;

	public SelectionBuilder(Selection defaultSampleSelection){
		setSampleSelection(defaultSampleSelection);
	}

	public void setSampleSelection(Selection newSampleSelection){
		sampleSelection = newSampleSelection;
	}

	public Selection selectSingleTile(float x, float y){
		Tile[] hitTile = new Tile[1];
		float[] weight = {1.0f};
		for(int k = 0; k<sampleSelection.contents.length;k++){
			if(sampleSelection.contents[k].containsPoint(x, y)){
				hitTile[0] = sampleSelection.contents[k];
				return new Selection(hitTile, weight, sampleSelection.arrayWidth, sampleSelection.arrayHeight);
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
			distance = dist(x, y, tileCentrePosition.x, tileCentrePosition.y);
			if(distance < radius){
				hitIndices[hitCount] = k;
				weights[hitCount] = distance * inv_radius;
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

	public Tile(float x, float y, PImage img){
		tileImage = img;
		position = new PVector(x, y);
		size = new PVector(img.width, img.height);
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
			pg.stroke(255, 0, 0);
			pg.strokeWeight(3);
			pg.rect(-size.x*0.5f, -size.y*0.5f, size.x, size.y);
		}
		pg.popMatrix();
	}



}


class Manipulator{

	public Manipulator(){

	}

	public void rotateSelection(Selection sel){
		
	}

	

}
    public void settings() { 	size(1080, 1080); }
    static public void main(String[] passedArgs) {
        String[] appletArgs = new String[] { "Retile" };
        if (passedArgs != null) {
          PApplet.main(concat(appletArgs, passedArgs));
        } else {
          PApplet.main(appletArgs);
        }
    }
}
