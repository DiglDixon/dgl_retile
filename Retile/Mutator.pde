
interface Mutator{
	public void mutate(Selection selection);
	public void passiveUpdate();
	public void display(Selection selection, PGraphics pg);
}

//

public void displaySelectedWithWeights(Selection selection, PGraphics pg){
	pg.stroke(255, 50);
	pg.noFill();
	for(int k = 0; k<selection.contents.length; k++){
		pg.strokeWeight(selection.weights[k]*4);
		selection.contents[k].displayBoundingRect(pg);
	}
}

//

class NullMutator implements Mutator{
	public void mutate(Selection selection){
		// Nothing
	}
	public void passiveUpdate(){
		// Nothing
	}
	public void display(Selection selection, PGraphics pg){
		// Nothing
	}
}

class PositionMutator implements Mutator{

	public PositionMutator(){

	}

	public void mutate(Selection selection){
		for(int k = 0; k<selection.contents.length; k++){
			// selection.contents[k].move(PVector.mult(Input.mouseVelocity, selection.weights[k]));
			selection.contents[k].move(PVector.mult(Input.mouseVelocity, selection.weights[k]));
		}
	}

	public void passiveUpdate(){}

	public void display(Selection selection, PGraphics pg){
		displaySelectedWithWeights(selection, pg);
	}

}

class RotationMutator implements Mutator{

	public RotationMutator(){

	}

	public void mutate(Selection selection){
		for(int k = 0; k<selection.contents.length; k++){
			// selection.contents[k].move(PVector.mult(Input.mouseVelocity, selection.weights[k]));
			selection.contents[k].rotate(0.07*Time.deltaTime()*selection.weights[k]);
		}
	}

	public void passiveUpdate(){}

	public void display(Selection selection, PGraphics pg){
		displaySelectedWithWeights(selection, pg);
	}

}