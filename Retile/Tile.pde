
class Tile{

	public TileTransform transform; // public to quickly draw strings

	public Tile(){
		transform = new EmptyTileTransform();
	}

	public void resetFromTileSetData(TileSetData data, int xIndex, int yIndex){
		transform.initialiseDimensions(xIndex*data.tileWidth, yIndex*data.tileHeight, data.tileWidth, data.tileHeight);
	}

	// This is needed for nav-stokes, I don't know how else to do it!
	public PVector getPosition(){
		return transform.getCentrePosition();
	}

	public void rotateTowardsHeading(PVector velocity, float weight){
		weight = constrain(weight, 0, 1);
		transform.rotateBy((velocity.heading() - transform.rotation)*weight);
	}

	public void move(PVector velocity){
		transform.moveBy(velocity);
	}

	public void rotate(float rotation){
		transform.rotateBy(rotation);
	}

	public float distanceFromPoint(float x, float y){
		PVector centrePosition = transform.getCentrePosition();
		return dist(centrePosition.x, centrePosition.y, x, y);
	}

	public boolean containsPoint(float x, float y){
		PVector centrePosition = transform.getCentrePosition();
		return (x > centrePosition.x && y > centrePosition.y && x<centrePosition.x+transform.size.x && y<centrePosition.y+transform.size.y);
	}

	private void displayTileAsShape(PGraphics pg){
		pg.noStroke();
		pg.noFill();
		pg.beginShape();
		pg.texture(textureSource);
		transform.drawVerticesToGraphics(pg);
		pg.endShape();
	}

	public void displayCentredBoundingRect(PGraphics pg){
		pg.noFill();
		pg.stroke(255, 50);
		pg.beginShape();
		transform.drawVerticesToGraphics(pg);
		pg.endShape();
	}

}