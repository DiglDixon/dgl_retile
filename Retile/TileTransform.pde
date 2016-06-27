
// No longer a data set. This is now used to organise 
class TileTransform{
	private PVector size = new PVector(); // Get rid of this? Shift into TileVertexQuad?
	private float rotation = 0; // Trying to move away from this too
	public TileVertexQuad vertexSet; // Making it public for a quick way to draw strings

	public TileTransform(float x, float y, float w, float h){
		initialiseDimensions(x, y, w, h);
	}

	public void initialiseDimensions(float x, float y, float w, float h){
		resizeTo(w, h);
		resetRotation();
		vertexSet = new TileVertexQuad(x, y, w, h);
	}

	public void moveBy(PVector amount){
		for(int k = 0; k<vertexSet.vertices.length; k++){
			vertexSet.vertices[k].position.add(amount);
		}
	}

	public void moveTo(float x, float y){
		moveTo(new PVector(x, y));
	}

	public void moveTo(PVector pos){
		PVector diff = PVector.sub(pos, getCentrePosition());
		for(int k = 0; k<vertexSet.vertices.length; k++){
			vertexSet.vertices[k].position.add(diff);
		}
	}

	public void rotateBy(float amount){
		rotation+=amount;
		applyRotation();
	}

	private void resetRotation(){
		rotation = 0;
	}

	public void resizeTo(float w, float h){
		size.x = w;
		size.y = w; // We only support squares at the moment
	}

	public void drawVerticesToGraphics(PGraphics pg){
		TileVertex tv;
		for(int k = 0; k<vertexSet.vertices.length; k++){
			tv = vertexSet.vertices[k];
			pg.vertex(tv.position.x, tv.position.y, tv.uv.x, tv.uv.y);
		}
	}

	private void applyRotation(){
		PVector centre = getCentrePosition();
		PVector leftToRight = new PVector(cos(rotation + PI*-0.75), sin(rotation + PI*-0.75));
		PVector rightToLeft = new PVector(cos(rotation + PI*-0.25), sin(rotation + PI*-0.25));

		float r = size.x * 0.5 * ROOT_TWO;

		vertexSet.topLeft.position = PVector.add(centre, PVector.mult(leftToRight, r));
		vertexSet.bottomRight.position = PVector.add(centre, PVector.mult(leftToRight, -r));

		vertexSet.topRight.position = PVector.add(centre, PVector.mult(rightToLeft, r));
		vertexSet.bottomLeft.position = PVector.add(centre, PVector.mult(rightToLeft, -r));
	}

	public PVector getCentrePosition(){
		return PVector.mult(PVector.add(vertexSet.topLeft.position, vertexSet.bottomRight.position), 0.5);
	}

}

class EmptyTileTransform extends TileTransform{
	public EmptyTileTransform(){
		super(0, 0, 1, 1);
	}
}

class TileVertex{
	public PVector uv;
	public PVector position; // vertex local positions
	public TileVertex(float x, float y, float u, float v){
		position = new PVector(x, y);
		uv = new PVector(u, v);
	}
	public TileVertex(float x, float y){
		position = new PVector(x, y);
		uv = new PVector(x, y); // default uvs to match position
	}
}

class TileVertexSet{
	public TileVertex[] vertices;
	public TileVertexSet(TileVertex[] vertices){
		this.vertices = vertices;
	}
	public TileVertexSet(){
		// enabling empty super constructors.
	}
}

class TileVertexQuad extends TileVertexSet{
	public TileVertex topLeft;
	public TileVertex topRight;
	public TileVertex bottomLeft;
	public TileVertex bottomRight;
	public TileTransformEdge leftEdge;
	public TileTransformEdge topEdge;
	public TileTransformEdge rightEdge;
	public TileTransformEdge bottomEdge;

	public TileVertexQuad(float x, float y, float w, float h){
		this.topLeft = new TileVertex(x, y);
		this.topRight = new TileVertex(x+w, y);
		this.bottomRight = new TileVertex(x+w, y+h);
		this.bottomLeft = new TileVertex(x, y+h);

		this.vertices = new TileVertex[4];
		this.vertices[0] = topLeft;
		this.vertices[1] = topRight;
		this.vertices[2] = bottomRight;
		this.vertices[3] = bottomLeft;

		this.leftEdge = new TileTransformEdge(bottomLeft, topLeft);
		this.topEdge = new TileTransformEdge(topLeft, topRight);
		this.rightEdge = new TileTransformEdge(topRight, bottomRight);
		this.bottomEdge = new TileTransformEdge(bottomRight, bottomLeft);
	}
}

class TileTransformEdge extends TileVertexSet{
	public float length;
	public TileTransformEdge(TileVertex v1, TileVertex v2){
		super(new TileVertex[]{v1, v2});
		sortLength();
	}
	public TileTransformEdge(TileVertex[] vertices){
		super(vertices);
		sortLength();
	}
	private void sortLength(){
		float l = 0;
		for(int k = 1; k<this.vertices.length; k++){
			l += PVector.dist(vertices[k-1].position, vertices[k].position);
		}
		this.length = l;
	}
}
// pseudo-static
_TileTransformTools TileTransformTools = new _TileTransformTools();
class _TileTransformTools{
	public _TileTransformTools(){

	}

	public TileVertex getVertexValuesAlongEdge(TileTransformEdge edge, float position){
		PVector pos = PVector.add(PVector.sub(edge.vertices[1].position, edge.vertices[0].position).setMag(position * edge.length), edge.vertices[0].position);
		PVector uv = PVector.add(PVector.sub(edge.vertices[1].uv, edge.vertices[0].uv).setMag(position * edge.length), edge.vertices[0].uv);
		return new TileVertex(pos.x, pos.y, uv.x, uv.y);
	}

	public PVector getPointAlongEdge(TileTransformEdge edge, float position){
		return PVector.add(PVector.sub(edge.vertices[1].position, edge.vertices[0].position).setMag(position * edge.length), edge.vertices[0].position);
	}
}

