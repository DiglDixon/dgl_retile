
class TileSetData{
	public int tilesX;
	public int tilesY;
	public int tileWidth;
	public int tileHeight;
	public TileSetData(){
	}
}


class TilePool{

	private Tile[] tiles = new Tile[0];
	private int maxWidth = width;
	private int maxHeight = height;
	private int minTileSizeX;
	private int minTileSizeY;
	private int maxTilesX = 1;
	private int maxTilesY = 1;

	public TilePool(int minSizeX, int minSizeY){
		setMinTileDimensions(minSizeX, minSizeY);
	}

	private void setMinTileDimensions(int x, int y){
		minTileSizeX = x;
		minTileSizeY = y;
		recalculateMaxScreenDimensions();
	}

	private void recalculateMaxScreenDimensions(){
		maxTilesX = maxWidth / minTileSizeX;
		maxTilesY = maxHeight / minTileSizeY;
		if(maxTilesX*maxTilesY > tiles.length){
			println("New resolution parameters require a larger TilePool array - renewing...");
			renewTilesArray();
		}
	}

	private void renewTilesArray(){
		tiles = new Tile[maxTilesX*maxTilesY];
		for(int k = 0; k<tiles.length; k++){
			tiles[k] = new Tile();
		}
		println("Renewed tiles array with a length: "+tiles.length);
	}

	private void setMaxScreenDimensions(int x, int y){
		maxWidth = x;
		maxHeight = y;
		recalculateMaxScreenDimensions();
	}

	public Selection produceTileGridOfSizeFromImage(int sizeX, int sizeY, PImage baseImage){
		// baseImage.loadPixels();

		if(sizeX < minTileSizeX || sizeY > minTileSizeY){
			setMinTileDimensions(sizeX, sizeY);
		}

		int tilesX = floor(maxWidth/sizeX);
		int tilesY = floor(maxHeight/sizeY);


		TileSetData newSetData = new TileSetData();
		newSetData.tilesX = tilesX;
		newSetData.tilesY = tilesY;
		newSetData.tileWidth = sizeX;
		newSetData.tileHeight = sizeY;

		Tile[] activeTiles = new Tile[tilesX * tilesY];

		Tile iTile;
		for(int k = 0; k<tilesX; k++){
			for(int j = 0; j<tilesY; j++){
				iTile = tiles[k+j*tilesX];
				iTile.resetFromTileSetData(newSetData, k, j);
				// iTile.loadImageFromBaseImage(baseImage);
				activeTiles[k+j*tilesX] = iTile;
			}
		}

		for(int k = tilesX; k<maxTilesX; k++){
			for(int j = tilesY; j<maxTilesY; j++){
				// deactivate
			}
		}

		return new WeightlessSelection(activeTiles, tilesX, tilesY);

	}


}