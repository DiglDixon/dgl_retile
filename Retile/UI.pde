
//pseudo-static
_UI UI = new _UI();
public class _UI{
	public PGraphics ui;
	
	public _UI(){
	}

	void initialise(){
		ui = createGraphics(width, height, P2D);
	}

	void display(){
		ui.beginDraw();
		ui.clear();
		ui.fill(50);
		ui.noStroke();
		ui.rect(0, 0, 200, 50);
		ui.fill(255);
		ui.text("active tiles: "+onscreenTiles.contents.length, 20, 10);
		ui.text("fps: "+frameRate, 20, 35);
		ui.endDraw();
		image(ui, 0, 0);
	}
}