

// Data structure
class TileTransform{
	public PVector position;
	public PVector size;
	public PVector uv;
	public float rotation = 0;
	public float scale = 1;

	public TileTransform(){
		this.position = new PVector();
		this.size = new PVector();
		this.uv = new PVector();
	}

	public TileTransform(float x, float y, float w, float h){
		this.position = new PVector(x, y);
		this.size = new PVector(w, h);
		this.uv = new PVector(x, y);
	}

}

public void addTileTransformVerticesToGraphics(TileTransform tt, PGraphics pg){
	
}