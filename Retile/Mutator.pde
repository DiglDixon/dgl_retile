
interface Mutator{
	public void mutate(Selection selection);
}

class NullMutator implements Mutator{
	public void mutate(Selection selection){
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

}

class RotationMutator implements Mutator{

	public RotationMutator(){

	}

	public void mutate(Selection selection){
		for(int k = 0; k<selection.contents.length; k++){
			// selection.contents[k].move(PVector.mult(Input.mouseVelocity, selection.weights[k]));
			selection.contents[k].rotate(0.1*selection.weights[k]);
		}
	}

}