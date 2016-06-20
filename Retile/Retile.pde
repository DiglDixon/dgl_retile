/* 

- drawing strings, maybe just to proximate, too
- drawing curvy strings...
- static strings look great! Some great results with rotation
- Navier Stokes could be insane, esp at low tile sizes. Will probs replace radial selection

- a shader would help our efficiency massively.
	- images readfrom the same buffer, just with different texture coordinates

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

TilePool tilePool;


void setup(){
	size(1080, 1080, P2D);
	UI.initialise();
	tilePool = new TilePool(10, 10);
	canvas = createGraphics(width, height, P2D);
    backgroundImage = loadImage("monet.jpg");
    drawBackgroundImage();
    reTile(200, 200);
}

void drawBackgroundImage(){
	canvas.beginDraw();
	canvas.image(backgroundImage, 0, 0);
	canvas.endDraw();
}

void reTile(){
	reTile(tileSize, tileSize);
}

void reTile(int sizeX, int sizeY){
	PImage imageToTileFrom = canvas.get();
	onscreenTiles = tilePool.produceTileGridOfSizeFromImage(sizeX, sizeY, imageToTileFrom);
	SelectionBuilder.setSampleSelection(onscreenTiles);
}


void draw(){

	cMutator.mutate(cSelection);

	canvas.beginDraw();
	// canvas.background(0);

	for(int k = (frameCount%iterationSteps); k<onscreenTiles.contents.length; k+=iterationSteps){
		onscreenTiles.contents[k].display(canvas);
	}

	canvas.endDraw();
	image(canvas, 0, 0);
	UI.display();
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
	cSelection = SelectionBuilder.selectRadial(mouseX, mouseY, 150);
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
    	case ' ':
    	reTile();
    	break;
    	case 'r':
    		cMutator = new RotationMutator();
    	break;
    	case 'v':
    		cMutator = new PositionMutator();
        default:
        //unknown key
        break;
    }
}

void numberKeyPressed(int n){
	if(n>0){
		tileSize = n*10;
		if(tileSize <= 20){
			iterationSteps = 1;
		}else{
			iterationSteps = 1;
		}
		println("Changed tile size: "+tileSize);
	}
}


//