
class Tile{

	public PVector position; // this is only public for testing navier stokes
	public PVector size;
	private float rotation;
	private PImage tileImage;
	private boolean grabbed = false;
	private color[] edgeColoursTop;
	private color[] edgeColoursLeft;

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
		int samplePixelIndex;
		for(int k = 0; k<tileImage.width; k++){
			for(int j = 0; j<tileImage.height; j++){
				tileImage.pixels[k + tileImage.width*j] = baseImage.pixels[(x+k) + (y+j) * baseImage.width];
			}
		}
		tileImage.updatePixels();

		edgeColoursTop = new color[tileImage.width];
		edgeColoursLeft = new color[tileImage.height];
		for(int k = 0; k<tileImage.width; k++){
			edgeColoursTop[k] = baseImage.pixels[(x+k) + y*baseImage.width];
		}
		for(int j = 0; j<tileImage.height; j++){
			edgeColoursLeft[j] = baseImage.pixels[x + (y+j)*baseImage.width];
		}

	}

	public void move(PVector velocity){
		position.add(velocity);
	}

	public void rotate(float rotationAdd){
		rotation+=rotationAdd;
	}

	public void grab(){
		grabbed = true;
	}

	public void release(){
		grabbed = false;
	}

	public PVector centrePosition(){
		return PVector.add(position, PVector.mult(size, 0.5));
	}

	public boolean containsPoint(float x, float y){
		return (x > position.x && y > position.y && x<position.x+size.x && y<position.y+size.y);
	}

	public void display(PGraphics pg){
		pushTransformToGraphics(pg);
		displayTile(pg);
		displayStringsAtInterval(pg, 2);
		if(grabbed){
			displayGrabUI(pg);
		}
		popTransformFromGraphics(pg);
	}

	private void displayTile(PGraphics pg){
		pg.image(tileImage, -size.x*0.5, -size.y*0.5);
	}

	private void displayGrabUI(PGraphics pg){
		pg.noFill();
		pg.stroke(255, 50);
		pg.strokeWeight(1);
		pg.rect(-size.x*0.5, -size.y*0.5, size.x, size.y);
	}

	private void displayStringsAtInterval(PGraphics pg, int interval){
		for(int k = 0; k<edgeColoursTop.length; k+=interval){
			pg.stroke(edgeColoursTop[k]);
			pg.line(-size.x*0.5+k, -size.y*0.5, -size.x*0.5+k, -size.y*0.5 - 10);
		}
		for(int j = 0; j<edgeColoursLeft.length; j+=interval){
			pg.stroke(edgeColoursLeft[j]);
			pg.line(-size.x*0.5, -size.y*0.5+j, -size.x*0.5 - 10, -size.y*0.5+j);
		}
	}

	private void pushTransformToGraphics(PGraphics pg){
		pg.pushMatrix();
		pg.translate(position.x+size.x*0.5, position.y+size.y*0.5);
		pg.rotate(rotation);
	}

	private void popTransformFromGraphics(PGraphics pg){
		pg.popMatrix();
	}



}