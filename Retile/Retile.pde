/* 
Pre-loaded high res images.
No need for controls, just go keys.

*/

PApplet SKETCH = this;
Tile[] tiles;
int tileCountX, tileCountY;
ArrayList grabbedTiles;
int tileSize = 50;

PImage backgroundImage;
PGraphics canvas;

SelectionBuilder allSelect;

Selection cSelection = new EmptySelection();
Mutator cMutator = new PositionMutator();

void setup(){
	size(1080, 1080, P2D);
	UI.initialise();
	canvas = createGraphics(width, height, P2D);
    backgroundImage = loadImage("monet.jpg");
    grabbedTiles = new ArrayList<Tile>();
    drawBackgroundImage();
    reTile();
    float[] weight = {1.0};
    allSelect = new SelectionBuilder(new Selection(tiles, weight, tileCountX, tileCountY));
}

void drawBackgroundImage(){
	canvas.beginDraw();
	canvas.image(backgroundImage, 0, 0);
	canvas.endDraw();
}


void draw(){

	cMutator.mutate(cSelection);

	canvas.beginDraw();
	canvas.background(0);
	displayTiles(canvas);
	canvas.endDraw();
	image(canvas, 0, 0);
	UI.display();
}

void reTile(){
	reTile(tileSize);
}

void reTile(int size){
	println("Re-tiling...");
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

void displayTiles(PGraphics pg){
	for(int k = 0; k<tiles.length;k++){
		tiles[k].display(pg);
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
	releaseSelection(cSelection);
	cSelection = allSelect.selectRadial(mouseX, mouseY, 150);
	grabSelection(cSelection);
}

void mouseReleased(){
	Input.mouseReleased();
	releaseSelection(cSelection);
	cSelection = new EmptySelection();
}


void grabSelection(Selection selection){
	for(int k = 0; k<selection.contents.length; k++){
		selection.contents[k].grab();
	}
}

void releaseSelection(Selection selection){
	for(int k = 0; k<selection.contents.length; k++){
		selection.contents[k].release();
	}
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