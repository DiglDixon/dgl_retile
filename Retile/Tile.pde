
class Tile{

	private TileTransform transform;

	public Tile(){
		transform = new TileTransform();
	}

	public void resetFromTileSetData(TileSetData data, int xIndex, int yIndex){
		transform.position.x = xIndex*data.tileWidth;
		transform.position.y = yIndex*data.tileHeight;
		resizeTile(data.tileWidth, data.tileHeight);
		transform.rotation = 0;
		setUVsFromCurrentPosition();
	}

	private void resizeTile(int w, int h){
		transform.size.x = w;
		transform.size.y = h;
	}

	private void setUVsFromCurrentPosition(){
		transform.uv.x = transform.position.x;
		transform.uv.y = transform.position.y;
	}

	public PVector getPosition(){
		return transform.position;
	}

	public void move(PVector velocity){
		transform.position.add(velocity);
	}

	public void rotate(float rotation){
		transform.rotation += rotation;
	}

	public PVector centrePosition(){
		return PVector.add(transform.position, PVector.mult(transform.size, 0.5));
	}

	public boolean containsPoint(float x, float y){
		return (x > transform.position.x && y > transform.position.y && x<transform.position.x+transform.size.x && y<transform.position.y+transform.size.y);
	}
//REFACTOR
	public void displayCentredBoundingRect(PGraphics pg){
		pg.rect(-transform.size.x*0.5, -transform.size.y*0.5, transform.size.x, transform.size.y);
	}

	public void display(PGraphics pg){
		pushTransformToGraphics(pg);
		displayTileAsShape(pg);
		displayStringsAsShapes(pg, 2, 2, 5);
		popTransformFromGraphics(pg);
	}
//REFACTOR
	private void displayTileAsShape(PGraphics pg){
		pg.noStroke();
		pg.noFill();
		pg.beginShape();
		pg.texture(textureSource);
		pg.vertex(-transform.size.x*0.5, -transform.size.y*0.5, transform.uv.x, transform.uv.y);
		pg.vertex(transform.size.x*0.5, -transform.size.y*0.5, transform.uv.x+transform.size.x, transform.uv.y);
		pg.vertex(transform.size.x*0.5, transform.size.y*0.5, transform.uv.x+transform.size.x, transform.uv.y+transform.size.y);
		pg.vertex(-transform.size.x*0.5, transform.size.y*0.5, transform.uv.x, transform.uv.y+transform.size.y);
		pg.endShape();
	}
//REFACTOR
	private void displayStringsAsShapes(PGraphics pg, int thickness, int interval, int length){

		// top row
		int count = 0;
		int step = interval + thickness;
		for(int k = 0; k<(transform.size.x-step); k+=step){
			pg.beginShape();
			pg.texture(textureSource);
			pg.vertex(-transform.size.x*0.5 + step*count, -transform.size.y*0.5, transform.uv.x + step*count, transform.uv.y); // edge left

			pg.vertex(-transform.size.x*0.5 + step*count, -transform.size.y*0.5 - length, transform.uv.x + step*count, transform.uv.y); // extrude left
			pg.vertex(-transform.size.x*0.5 + step*count + thickness, -transform.size.y*0.5 - length, transform.uv.x + step*count + thickness, transform.uv.y); // extrude right

			pg.vertex(-transform.size.x*0.5 + step*count + thickness, -transform.size.y*0.5, transform.uv.x + step*count + thickness, transform.uv.y); // edge right
			pg.endShape();

			count++;
		}

	}
//REFACTOR
	private void pushTransformToGraphics(PGraphics pg){
		pg.pushMatrix();
		pg.translate(transform.position.x+transform.size.x*0.5, transform.position.y+transform.size.y*0.5);
		pg.rotate(transform.rotation);
	}

	private void popTransformFromGraphics(PGraphics pg){
		pg.popMatrix();
	}

}