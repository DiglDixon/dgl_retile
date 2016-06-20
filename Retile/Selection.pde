
// data structure
class Selection{
	public Tile[] contents;
	public float[] weights;
	public int arrayWidth;
	public int arrayHeight;

	public Selection(Tile[] contents, float[] weights, int w, int h){
		this.contents = contents;
		this.weights = weights;
		this.arrayWidth = w;
		this.arrayHeight = h;
	}
}

class WeightlessSelection extends Selection{
	public WeightlessSelection(Tile[] contents, int w, int h){
		super(contents, new float[contents.length], w, h);
		for(int k = 0; k<weights.length; k++){
			weights[k] = 1;
		}
	}

}

class EmptySelection extends Selection{
	public EmptySelection(){
		super(new Tile[0], new float[0], 0, 0);
	}
}

// pseudo-static
_SelectionBuilder SelectionBuilder = new _SelectionBuilder();
class _SelectionBuilder{

	Selection sampleSelection;

	public _SelectionBuilder(){
		setSampleSelection(new EmptySelection());
	}

	public void setSampleSelection(Selection newSampleSelection){
		sampleSelection = newSampleSelection;
	}

	public Selection selectSingleTile(float x, float y){
		Tile[] hitTile = new Tile[1];
		for(int k = 0; k<sampleSelection.contents.length;k++){
			if(sampleSelection.contents[k].containsPoint(x, y)){
				hitTile[0] = sampleSelection.contents[k];
				return new WeightlessSelection(hitTile, sampleSelection.arrayWidth, sampleSelection.arrayHeight);
			}
		}
		return new EmptySelection();
	}

	public Selection selectRadial(float x, float y, float radius){
		float inv_radius = 1/radius;

		float[] weights = new float[sampleSelection.contents.length];
		int[] hitIndices = new int[sampleSelection.contents.length];
		int hitCount = 0;
		PVector tileCentrePosition;
		float distance;
		for(int k = 0; k<sampleSelection.contents.length; k++){
			tileCentrePosition = sampleSelection.contents[k].centrePosition();
			distance = dist(tileCentrePosition.x, tileCentrePosition.y, x, y);
			if(distance < radius){
				hitIndices[hitCount] = k;
				weights[hitCount] = (radius-distance) * inv_radius;
				hitCount++;
			}
		}
		Tile[] hitTiles = new Tile[hitCount];
		for(int k = 0; k < hitCount; k++){
			hitTiles[k] = sampleSelection.contents[hitIndices[k]];
		}
		return new Selection(hitTiles, weights, sampleSelection.arrayWidth, sampleSelection.arrayHeight);
	}

}