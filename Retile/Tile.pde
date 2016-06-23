
class Tile{

	private TileTransform transform;
	private float naturalHeading = 0;
	private boolean naturalHeadingAssigned = false;

	PVector pPosition = new PVector();

	public Tile(){
		transform = new TileTransform();
	}


	public void resetFromTileSetData(TileSetData data, int xIndex, int yIndex){
		transform.position.x = xIndex*data.tileWidth;
		transform.position.y = yIndex*data.tileHeight;
		resizeTile(data.tileWidth, data.tileHeight);
		setUVsFromCurrentPosition();
		reset();
	}

	private void reset(){
		transform.rotation = 0;
		naturalHeading = 0;
		naturalHeadingAssigned = false;
		pPosition.x = transform.position.x;
		pPosition.y = transform.position.y;
	}

	private void resizeTile(int w, int h){
		transform.size.x = w;
		transform.size.y = h;
	}

	private void setUVsFromCurrentPosition(){
		transform.uv.x = transform.position.x;
		transform.uv.y = transform.position.y;
	}

	// This is needed for nav-stokes, I don't know how else to do it!
	public PVector getPosition(){
		return transform.position;
	}

	public void rotateTowardsHeading(PVector velocity, float weight){
		weight = constrain(weight, 0, 1);
		transform.rotation = transform.rotation + (velocity.heading() - transform.rotation)*weight;
	}

	public void move(PVector velocity){
		pPosition.x = transform.position.x;
		pPosition.y = transform.position.y;
		transform.position.add(velocity);
	}

	public void rotate(float rotation){
		transform.rotation = (transform.rotation+rotation)%TWO_PI;
	}

	public float distanceFromPoint(float x, float y){
		return dist(transform.position.x, transform.position.y, x, y);
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
		displayStringsAsShapes(pg, 3, 1, 5);
		popTransformFromGraphics(pg);
		displayCorners(pg);
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

	private void displayCorners(PGraphics pg){

		float r = transform.size.x * ROOT_TWO * 0.5; // This is the hypot, as long as our tiles are square.
		

		PVector botLeftCorner = TileTransformTools.bottomLeftCorner(transform);
		PVector botRightCorner = TileTransformTools.bottomRightCorner(transform);
		PVector topLeftCorner = TileTransformTools.topLeftCorner(transform);
		PVector topRightCorner = TileTransformTools.topRightCorner(transform);
		pg.noStroke();
		pg.fill(150, 20, 20);
		pg.text("TR", topRightCorner.x, topRightCorner.y);
		pg.text("BR", botRightCorner.x, botRightCorner.y);
		pg.text("TL", topLeftCorner.x, topLeftCorner.y);
		pg.text("BL", botLeftCorner.x, botLeftCorner.y);

	}
//REFACTOR
	private void displayStringsAsShapes(PGraphics pg, int thickness, int interval, int length){

		// top row
		int count = 0;
		int step = interval + thickness;
		pg.noStroke();
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