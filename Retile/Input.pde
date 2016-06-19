
// pseudo-static
_Input Input = new _Input();
public class _Input{

	public PVector mouseVelocity = new PVector();
	public PVector mousePosition = new PVector();
	public float mouseX;
	public float mouseY;

	public boolean mouseDown = false;

	public _Input(){
		registerMethod("draw", this);
	}

	public void draw(){

		this.mouseVelocity.x = SKETCH.mouseX - this.mouseX;
		this.mouseVelocity.y = SKETCH.mouseY - this.mouseY;

		this.mouseX = SKETCH.mouseX;
		this.mouseY = SKETCH.mouseY;
		mousePosition.x = this.mouseX;
		mousePosition.y = this.mouseY;
	}

	public void keyPressed(char key){

	}
	public void keyReleased(char key){

	}
	public void mousePressed(){
		mouseDown = true;
	}
	public void mouseReleased(){
		mouseDown = false;
	}

}