
// Nav Stokes stuff
NavierStokesSolver fluidSolver = new NavierStokesSolver();
float visc = 0.0108f; // 0.0008 default
float diff = 0.25f; // 0.25 default
float velocityScale = 16; // 16 default
float limitVelocity = 200;
float vScale;

void updateNavierStokes(){
    handleMouseMotion();

    double dt = 1 / frameRate;
    fluidSolver.tick(dt, visc, diff);

    vScale = velocityScale * 60/frameRate;
    applyNavierStokesMovement();
}

void displayNavierStokes(){
	stroke(64, 50);
    paintGrid();
    stroke(255, 30);
    strokeWeight(2);
    paintMotionVector((float) vScale * 2);
}

void applyNavierStokesMovement(){
    int n = NavierStokesSolver.N;
    float cellHeight = height / n;
    float cellWidth = width / n;

    Tile t;
    PVector pos;
    // PVector size;
    for(int k = 0; k<onscreenTiles.contents.length; k++){

    	t = onscreenTiles.contents[k];
        pos = t.getPosition();

    	int cellX = floor(pos.x / cellWidth);
        int cellY = floor(pos.y / cellHeight);
        cellX = constrain(cellX, 0, width-1);
        cellY = constrain(cellY ,0, height-1);
        float dx = (float) fluidSolver.getDx(cellX, cellY);
        float dy = (float) fluidSolver.getDy(cellX, cellY);

        // Position relative to the centre of its cell
        float lX = pos.x - cellX * cellWidth - cellWidth / 2;
        float lY = pos.y - cellY * cellHeight - cellHeight / 2;

        int v, h, vf, hf;

        if (lX > 0) {
            v = Math.min(n, cellX + 1);
            vf = 1;
        } else {
            v = Math.min(n, cellX - 1);
            vf = -1;
        }

        if (lY > 0) {
            h = Math.min(n, cellY + 1);
            hf = 1;
        } else {
            h = Math.min(n, cellY - 1);
            hf = -1;
        }

        float dxv = (float) fluidSolver.getDx(v, cellY);
        float dxh = (float) fluidSolver.getDx(cellX, h);
        float dxvh = (float) fluidSolver.getDx(v, h);

        float dyv = (float) fluidSolver.getDy(v, cellY);
        float dyh = (float) fluidSolver.getDy(cellX, h);
        float dyvh = (float) fluidSolver.getDy(v, h);

        dx = lerp(lerp(dx, dxv, hf * lY / cellWidth), lerp(dxh, dxvh, hf * lY / cellWidth), vf * lX / cellHeight);

        dy = lerp(lerp(dy, dyv, hf * lY / cellWidth), lerp(dyh, dyvh, hf * lY / cellWidth), vf * lX / cellHeight);

        t.move(new PVector(dx * vScale, dy * vScale));
    }
}


private void handleMouseMotion() {

    int n = NavierStokesSolver.N;
    float cellHeight = height / n;
    float cellWidth = width / n;

    double mouseDx = Input.mouseVelocity.x;
    double mouseDy = Input.mouseVelocity.y;
    int cellX = floor(max(1, Input.mouseX) / cellWidth);
    int cellY = floor(max(1, Input.mouseY) / cellHeight);

    mouseDx = (abs((float) mouseDx) > limitVelocity) ? Math.signum(mouseDx) * limitVelocity : mouseDx;
    mouseDy = (abs((float) mouseDy) > limitVelocity) ? Math.signum(mouseDy) * limitVelocity : mouseDy;

    fluidSolver.applyForce(cellX, cellY, mouseDx, mouseDy);
}

private void paintMotionVector(float scale) {
    int n = NavierStokesSolver.N;
    float cellHeight = height / n;
    float cellWidth = width / n;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            float dx = (float) fluidSolver.getDx(i, j);
            float dy = (float) fluidSolver.getDy(i, j);
            float x = cellWidth / 2 + cellWidth * i;
            float y = cellHeight / 2 + cellHeight * j;
            dx *= scale;
            dy *= scale;

            line(x, y, x + dx, y + dy);
        }
    }
}

private void paintGrid() {
    int n = NavierStokesSolver.N;
    float cellHeight = height / n;
    float cellWidth = width / n;
    for (int i = 1; i < n; i++) {
        line(0, cellHeight * i, width, cellHeight * i);
        line(cellWidth * i, 0, cellWidth * i, height);
    }
}
