

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

class TileTransformSide{
	public PVector cornerOne;
	public PVector cornerTwo;
	public TileTransformSide(TileTransform tt){
		cornerOne = TileTransformTools.topLeftCorner(tt);
		cornerTwo = TileTransformTools.topLeftCorner(tt);
	}
	public TileTransformSide(PVector c1, PVector c2){
		cornerOne = c1;
		cornerTwo = c2;
	}
}

class TileTransformLeftSide extends TileTransformSide{
	public TileTransformLeftSide(TileTransform tt){
		super(TileTransformTools.topLeftCorner(tt), TileTransformTools.bottomLeftCorner(tt));
	}
}
class TileTransformRightSide extends TileTransformSide{
	public TileTransformRightSide(TileTransform tt){
		super(TileTransformTools.topRightCorner(tt), TileTransformTools.bottomRightCorner(tt));
	}
}
class TileTransformTopSide extends TileTransformSide{
	public TileTransformTopSide(TileTransform tt){
		super(TileTransformTools.topLeftCorner(tt), TileTransformTools.topRightCorner(tt));
	}
}
class TileTransformBottomSide extends TileTransformSide{
	public TileTransformBottomSide(TileTransform tt){
		super(TileTransformTools.bottomLeftCorner(tt), TileTransformTools.bottomRightCorner(tt));
	}
}

// pseudo-static
_TileTransformTools TileTransformTools = new _TileTransformTools();
class _TileTransformTools{
	public _TileTransformTools(){

	}

	public PVector topLeftCorner(TileTransform tt){
		float r = tt.size.x * 0.5 * ROOT_TWO;
		PVector centre = PVector.add(tt.position, PVector.mult(tt.size, 0.5));
		return new PVector(centre.x+cos(tt.rotation + PI*-0.75)*r, centre.y+sin(tt.rotation + PI*-0.75)*r);
	}
	public PVector topRightCorner(TileTransform tt){
		float r = tt.size.x * 0.5 * ROOT_TWO;
		PVector centre = PVector.add(tt.position, PVector.mult(tt.size, 0.5));
		return new PVector(centre.x+cos(tt.rotation + PI*-0.25)*r, centre.y+sin(tt.rotation + PI*-0.25)*r);

	}
	public PVector bottomLeftCorner(TileTransform tt){
		float r = tt.size.x * 0.5 * ROOT_TWO;
		PVector centre = PVector.add(tt.position, PVector.mult(tt.size, 0.5));
		return new PVector(centre.x+cos(tt.rotation + PI*0.75)*r, centre.y+sin(tt.rotation + PI*0.75)*r);

	}
	public PVector bottomRightCorner(TileTransform tt){
		float r = tt.size.x * 0.5 * ROOT_TWO;
		PVector centre = PVector.add(tt.position, PVector.mult(tt.size, 0.5));
		return new PVector(centre.x+cos(tt.rotation + PI*0.25)*r, centre.y+sin(tt.rotation + PI*0.25)*r);

	}
}

