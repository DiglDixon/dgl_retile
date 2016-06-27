

PGraphics[] iterationCanvases;

void intialiseProcessIteration(int maxProcesses){
	iterationCanvases = new PGraphics[maxProcesses];
	for(int k = 0; k<iterationCanvases.length; k++){
		iterationCanvases[k] = createGraphics(width, height, P2D);
		iterationCanvases[k].beginDraw();
		iterationCanvases[k].background(255);
		iterationCanvases[k].clear();
		iterationCanvases[k].endDraw();
	}
}

void displayTilesInIterationsToGraphics(Tile[] tiles, PGraphics pg){
	int iterations = iterationCanvases.length;
	int cIteration = (frameCount%iterations);

	iterationCanvases[cIteration].beginDraw();
	iterationCanvases[cIteration].clear();
	for(int k = cIteration; k<tiles.length; k+=iterations){
		// tiles[k].display(iterationCanvases[cIteration]);
	}
	iterationCanvases[cIteration].endDraw();

	for(int k = 0; k<iterations; k++){
		pg.image(iterationCanvases[k], 0, 0);
	}
}

