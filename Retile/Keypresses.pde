
void keyPressed() {
    switch(key) {
        case '!':
        numberKeyPressed(1);
        break;
        case '@':
        numberKeyPressed(2);
        break;
        case '#':
        numberKeyPressed(3);
        break;
        case '$':
        numberKeyPressed(4);
        break;
        case '%':
        numberKeyPressed(5);
        break;
        case '^':
        numberKeyPressed(6);
        break;
        case '&':
        numberKeyPressed(7);
        break;
        case '*':
        numberKeyPressed(8);
        break;
        case '(':
        numberKeyPressed(9);
        break;
        case ')':
        numberKeyPressed(0);
        break;
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        numberKeyPressed(Integer.parseInt(key+""));
        break;
        case ENTER:
            exportImage();
        break;
        case BACKSPACE:
	        resetCanvas();
	        break;
    	case ' ':
	    	reTile();
	    	break;
    	case '`':
	    	displayGuides = !displayGuides;
	    	break;
    	case 'r':
    		cMutator = new RotationMutator();
	    	break;
    	case 'v':
    		cMutator = new PositionMutator();
    		break;
    	case 'n':
    		cMutator = navierStokesMutator;
    		break;
        default:
        //unknown key
        break;
    }
    Input.keyPressed(key);
}

void keyReleased(){
	Input.keyReleased(key);
}

void numberKeyPressed(int n){
	if(Input.reverseDown){
		intialiseProcessIteration(n);
		println("Changed processIterations: "+n);
		return;
	}

	if(n>0){
		tileSize = n*10;
		println("Changed tile size: "+tileSize);
	}
}