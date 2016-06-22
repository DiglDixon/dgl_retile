
// pseudo-static
_Input Input = new _Input();
public class _Input{

	public PVector mouseVelocity = new PVector();
	public PVector mousePosition = new PVector();
	public float mouseX, mouseY, pMouseX, pMouseY;

	public boolean mouseDown = false;

	private int shiftDownCount = 0;
	public boolean reverseDown = false;

	public _Input(){
		registerMethod("draw", this);
	}

	public void draw(){

		this.mouseVelocity.x = SKETCH.mouseX - this.mouseX;
		this.mouseVelocity.y = SKETCH.mouseY - this.mouseY;

		this.pMouseX = this.mouseX;
		this.pMouseY = this.mouseY;
		this.mouseX = SKETCH.mouseX;
		this.mouseY = SKETCH.mouseY;
		mousePosition.x = this.mouseX;
		mousePosition.y = this.mouseY;
	}

	public void keyPressed(char key){
		switch(key){
			case CODED:
			switch(keyCode){
				case SHIFT:
				println("Shift down");
				shiftDownCount++;
				reverseDown = true;
				break;
			}
			break;
		}

	}
	public void keyReleased(char key){
		switch(key){
			case CODED:
			switch(keyCode){
				case SHIFT:
				shiftDownCount--;
				if(shiftDownCount==0){
					reverseDown = false;	
				}
				break;
			}
			break;
		}
	}

	public void mousePressed(){
		mouseDown = true;
	}
	public void mouseReleased(){
		mouseDown = false;
	}

}