
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
		return PVector.add(position, PVector.mult(size, 0.5));
	}

	public boolean containsPoint(float x, float y){
		return (x > position.x && y > position.y && x<position.x+size.x && y<position.y+size.y);
	}

	public void display(PGraphics pg){
		pg.pushMatrix();
		pg.translate(position.x+size.x*0.5, position.y+size.y*0.5);
		pg.rotate(rotation);
		pg.image(tileImage, -size.x*0.5, -size.y*0.5);
		if(grabbed){
			pg.noFill();
			pg.stroke(255, 20);
			pg.strokeWeight(1);
			pg.rect(-size.x*0.5, -size.y*0.5, size.x, size.y);
		}
		pg.popMatrix();
	}



}