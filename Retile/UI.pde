
//pseudo-static
_UI UI = new _UI();
public class _UI{
	PGraphics ui;
	
	public _UI(){
	}

	void initialise(){
		ui = createGraphics(width, height, P2D);
	}

	void display(){
		ui.beginDraw();
		ui.clear();
		ui.text("fps: "+frameRate, 50, 50);
		ui.endDraw();
		image(ui, 0, 0);
	}
}