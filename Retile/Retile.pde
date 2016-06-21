/* 

- drawing strings, maybe just to proximate, too
- drawing curvy strings...
- static strings look great! Some great results with rotation
- Navier Stokes could be insane, esp at low tile sizes. Will probs replace radial selection

Using shader's, I believe it's entirely reasonable to be able to fill all spaces between tiles.

- a shader would help our efficiency massively.
	- images readfrom the same buffer, just with different texture coordinates

- We can also draw strings from the shader too.

- Adding "drip" weight to tile-dense areas

! Need to be conscious of being able to scale up images 

- Definitely need a pause function

- Try differing width / height
- Try randomising!

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

PShader tileShader;

PImage textureSource;

boolean displayGuides = true;


void setup(){
	size(1080, 1080, P2D);
	tileShader = loadShader("shaders/tileshader_frag.glsl", "shaders/tileshader_vert.glsl");
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
	// canvas.fill(0, 1);
	// canvas.noStroke();
	// canvas.rect(0, 0, canvas.width, canvas.height);

	displayTiles(canvas);

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
}


void drawBackgroundImage(){
	canvas.beginDraw();
	canvas.pushMatrix();
	canvas.translate(width*0.5, height*0.5);
	canvas.image(backgroundImage, -backgroundImage.width*0.5, -backgroundImage.height*0.5);
	canvas.popMatrix();
	canvas.endDraw();
}

void reloadTextureSource(){
	textureSource = canvas.get();
	// tileShader.set("texture", textureSource);
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


void displayTiles(PGraphics pg){
	canvas.shader(tileShader);
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
        case BACKSPACE:
	        resetCanvas();
	        break;
    	case ' ':
	    	reTile();
	    	break;
    	case '`':
	    	displayGuides = !displayGuides;
	    	break;
    	case 'r':
    		cMutator = new RotationMutator();
	    	break;
    	case 'v':
    		cMutator = new PositionMutator();
    		break;
    	case 'n':
    		cMutator = navierStokesMutator;
    		break;
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

