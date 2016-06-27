
// Nav Stokes stuff


class NavierStokesMutator implements Mutator{

    NavierStokesSolver fluidSolver = new NavierStokesSolver();
    float visc = 0.0108f; // 0.0008 default
    float diff = 0.25f; // 0.25 default
    float velocityScale = 16; // 16 default
    float vScale;
    float limitVelocity = 200;

    public NavierStokesMutator(){

    }

    public void mutate(Selection selection){
        if(Input.mouseDown){
            handleMouseMotion();
        }
    }

    public void passiveUpdate(){

        double dt = .016666667;//1 / frameRate;
        fluidSolver.tick(dt, visc, diff);

        vScale = velocityScale * 1;//60/frameRate;

        int n = NavierStokesSolver.N;
        float cellHeight = height / n;
        float cellWidth = width / n;

        Tile t;
        PVector pos;
        PVector velocity;
        for(int k = 0; k<onscreenTiles.contents.length; k++){

            t = onscreenTiles.contents[k];
            pos = t.getPosition();
            pos.x = constrain(pos.x, 0, width);
            pos.y = constrain(pos.y, 0, height);

            int cellX = floor(pos.x / cellWidth);
            int cellY = floor(pos.y / cellHeight);
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

            velocity = new PVector(dx * vScale, dy * vScale);
            t.rotateTowardsHeading(velocity, velocity.mag()/100 );
            t.move(velocity);
        }
    }

    public void display(Selection selection, PGraphics pg){
        pg.stroke(64, 50);
        paintGrid(pg);
        paintMotionVector(pg);
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

    private void paintMotionVector(PGraphics pg) {
        float scale = vScale * 2;
        int n = NavierStokesSolver.N;
        float cellHeight = height / n;
        float cellWidth = width / n;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                float x = cellWidth / 2 + cellWidth * i;
                float y = cellHeight / 2 + cellHeight * j;
                if(fluidSolver.isDeadCell(i, j)){
                    pg.fill(150, 100, 100, 100);
                    pg.noStroke();
                    pg.rect(x-cellWidth*0.5, y-cellHeight*0.5, cellWidth, cellHeight);
                }else{
                    pg.stroke(150);
                    pg.noFill();
                    float dx = (float) fluidSolver.getDx(i, j);
                    float dy = (float) fluidSolver.getDy(i, j);
                    dx *= scale;
                    dy *= scale;

                    pg.line(x, y, x + dx, y + dy);
                }
            }
        }
    }

    private void paintGrid(PGraphics pg) {
        int n = NavierStokesSolver.N;
        float cellHeight = height / n;
        float cellWidth = width / n;
        for (int i = 1; i < n; i++) {
            pg.line(0, cellHeight * i, width, cellHeight * i);
            pg.line(cellWidth * i, 0, cellWidth * i, height);
        }
    }
}




