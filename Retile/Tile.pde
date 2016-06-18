

class Tile{

	private PVector position;
	private PVector size;
	private float rotation;
	private PImage tileImage;
	private boolean grabbed = false;

	public Tile(float x, float y, PImage img){
		tileImage = img;
		position = new PVector(x, y);
		size = new PVector(img.width, img.height);
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

	public void display(PGraphics pg){
		pg.pushMatrix();
		pg.translate(position.x+size.x*0.5, position.y+size.y*0.5);
		pg.rotate(rotation);
		pg.image(tileImage, -size.x*0.5, -size.y*0.5);
		if(grabbed){
			pg.noFill();
			pg.stroke(255, 0, 0);
			pg.strokeWeight(3);
			pg.rect(-size.x*0.5, -size.y*0.5, size.x, size.y);
		}
		pg.popMatrix();

	}



}