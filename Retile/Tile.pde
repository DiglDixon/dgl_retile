
class Tile{

	private PVector position;
	private PVector size;
	private PVector uvCoordinates;
	private float rotation;
	private PImage tileImage;
	private color[] edgeColoursTop;
	private color[] edgeColoursLeft;

	public Tile(){
		position = new PVector();
		size = new PVector();
		tileImage = createImage(1, 1, ARGB);
	}

	public void resetFromTileSetData(TileSetData data, int xIndex, int yIndex){
		position.x = xIndex*data.tileWidth;
		position.y = yIndex*data.tileHeight;
		resizeTile(data.tileWidth, data.tileHeight);
		rotation = 0;
		setUVsFromCurrentPosition();
	}

	private void resizeTile(int w, int h){
		size.x = w;
		size.y = h;
		tileImage.resize(w, h);
	}

	private void setUVsFromCurrentPosition(){
		uvCoordinates = new PVector(position.x, position.y);
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

	public PVector getPosition(){
		return position;
	}

	public void move(PVector velocity){
		position.add(velocity);
	}

	public void rotate(float rotationAdd){
		rotation+=rotationAdd;
	}

	public PVector centrePosition(){
		return PVector.add(position, PVector.mult(size, 0.5));
	}

	public boolean containsPoint(float x, float y){
		return (x > position.x && y > position.y && x<position.x+size.x && y<position.y+size.y);
	}
	
	public void displayBoundingRect(PGraphics pg){
		pg.rect(-size.x*0.5, -size.y*0.5, size.x, size.y);
	}

	public void display(PGraphics pg){
		pushTransformToGraphics(pg);
		displayTileAsShape(pg);
		displayStringsAsShapes(pg, 2, 2, 5);
		// displayStringsAtInterval(pg, 2);
		popTransformFromGraphics(pg);
	}

	private void displayTileAsShape(PGraphics pg){
		pg.noStroke();
		pg.noFill();
		pg.beginShape();
		pg.texture(textureSource);
		addTopLeftVertex(pg);
		addTopRightVertex(pg);
		addBottomLeftVertex(pg);
		addBottomRightVertex(pg);
		pg.endShape();
	}

	private void addTopLeftVertex(PGraphics pg){
		pg.vertex(-size.x*0.5, -size.y*0.5, uvCoordinates.x, uvCoordinates.y);
	}
	private void addTopRightVertex(PGraphics pg){
		pg.vertex(size.x*0.5, -size.y*0.5, uvCoordinates.x+size.x, uvCoordinates.y);
	}
	private void addBottomLeftVertex(PGraphics pg){
		pg.vertex(size.x*0.5, size.y*0.5, uvCoordinates.x+size.x, uvCoordinates.y+size.y);
	}
	private void addBottomRightVertex(PGraphics pg){
		pg.vertex(-size.x*0.5, size.y*0.5, uvCoordinates.x, uvCoordinates.y+size.y);
	}

	private void displayStringsAsShapes(PGraphics pg, int thickness, int interval, int length){

		// top row
		int count = 0;
		int step = interval + thickness;
		for(int k = 0; k<(size.x-step); k+=step){
			pg.beginShape();
			pg.texture(textureSource);
			pg.vertex(-size.x*0.5 + step*count, -size.y*0.5, uvCoordinates.x + step*count, uvCoordinates.y); // edge left

			pg.vertex(-size.x*0.5 + step*count, -size.y*0.5 - length, uvCoordinates.x + step*count, uvCoordinates.y); // extrude left
			pg.vertex(-size.x*0.5 + step*count + thickness, -size.y*0.5 - length, uvCoordinates.x + step*count + thickness, uvCoordinates.y); // extrude right

			pg.vertex(-size.x*0.5 + step*count + thickness, -size.y*0.5, uvCoordinates.x + step*count + thickness, uvCoordinates.y); // edge right
			pg.endShape();

			count++;
		}

	}

	// Looking to dep this in favour of something more efficient
	private void displayTile(PGraphics pg){
		pg.image(tileImage, -size.x*0.5, -size.y*0.5);
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