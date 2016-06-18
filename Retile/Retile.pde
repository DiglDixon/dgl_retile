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

void setup(){
	size(1080, 1080);
	canvas = createGraphics(width, height);
	ui = createGraphics(width, height);
    backgroundImage = loadImage("monet.jpg");
    grabbedTiles = new ArrayList<Tile>();
    drawBackgroundImage();
    reTile();
}

void drawBackgroundImage(){
	canvas.beginDraw();
	canvas.image(backgroundImage, 0, 0);
	canvas.endDraw();
}


void draw(){
	canvas.beginDraw();
	canvas.background(0);
	for(int k = 0; k<tiles.length;k++){
		tiles[k].display(canvas);
	}
	canvas.endDraw();
	image(canvas, 0, 0);
	displayUI();
}

void reTile(){
	reTile(tileSize);
}

void reTile(int size){
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

void displayUI(){
	ui.beginDraw();
	ui.clear();
	ui.text("fps: "+frameRate, 50, 50);
	ui.endDraw();
	image(ui, 0, 0);
}

void mousePressed(){
	PVector mousePosition = new PVector(mouseX, mouseY);
	grabTiles(mousePosition, 300);
}

void mouseReleased(){
	releaseTiles();
}

void grabTiles(PVector position, float range){
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

void releaseTiles(){
	Tile t;
	for(int k =0 ; k<grabbedTiles.size();k++){
		t = (Tile) grabbedTiles.get(k);
		t.release();
	}
	grabbedTiles.clear();
}

void keyPressed() {
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

void numberKeyPressed(int n){
	if(n>0){
		tileSize = n*10;
		println("Changed tile size: "+tileSize);
	}
}


//