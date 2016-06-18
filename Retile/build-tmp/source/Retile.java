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
ArrayList grabbedTiles;
int tileSize = 50;

PImage backgroundImage;
PGraphics canvas;
PGraphics ui;

public void setup(){
	
	canvas = createGraphics(width, height);
	ui = createGraphics(width, height);
    backgroundImage = loadImage("monet.jpg");
    grabbedTiles = new ArrayList<Tile>();
    drawBackgroundImage();
    reTile();
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
	int divX = floor(width / size);
	int divY = floor(height / size);
	tiles = new Tile[divX*divY];
	int x;
	int y;
	for(int k = 0; k<divX; k++){
		for(int j = 0; j<divY; j++){
			x = k * size;
			y = j * size;
			tiles[k+j*divX] = new Tile(x, y, canvas.get(x, y, size, size));
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
	grabTiles(mousePosition, 300);
}

public void mouseReleased(){
	releaseTiles();
}

public void grabTiles(PVector position, float range){
	PVector tileCentre;
	for(int k = 0; k<tiles.length; k++){
		tileCentre = tiles[k].centrePosition();
		if(position.dist(tileCentre) < range){
			grabbedTiles.add(tiles[k]);
			tiles[k].grab();
		}
	}
	println("Tile grab completed, size: "+grabbedTiles.size());
}

public void releaseTiles(){
	Tile t;
	for(int k =0 ; k<grabbedTiles.size();k++){
		t = (Tile) grabbedTiles.get(k);
		t.release();
	}
	grabbedTiles.clear();
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
