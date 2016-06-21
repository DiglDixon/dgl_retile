_Time Time = new _Time();


public class _Time{

	int previousFrameMillis = 0;
	float deltaTime;
	float deltaMillis;

	float estimatedFrameRate = 60;
	float definedFrameRate = 1000/estimatedFrameRate;
	float inverse_definedFrameRate = 1/definedFrameRate;

	// This is a way of getting frame rate based on millis() over a time
	// Often more useful that rather than proc's 1-frame frameRate call.
	float generalFramerateReportInterval = 1000;
	float inverse_generalFramerateReportInterval = 1.0/generalFramerateReportInterval;
	int lastGeneralFramerateReportTime = 0;
	int framesSinceLastGeneralFrameReport = 0;
	float generalFrameRate = 0;

	public _Time(){
		SKETCH.registerMethod("draw", this);
	}

	public void draw(){
		//
		int millis = millis();
		deltaTime = (millis-previousFrameMillis)*inverse_definedFrameRate;
		deltaMillis = millis-previousFrameMillis;
		previousFrameMillis = millis;
	  	//
	  	updateGeneralFrameRate();
	}

	private void updateGeneralFrameRate(){
		framesSinceLastGeneralFrameReport++;
		int millis = millis();
	    if (millis - lastGeneralFramerateReportTime > generalFramerateReportInterval) {
	    	generalFrameRate = (millis-lastGeneralFramerateReportTime) * inverse_generalFramerateReportInterval * inverse_definedFrameRate * 1000;
			framesSinceLastGeneralFrameReport = 0;
		    lastGeneralFramerateReportTime = millis;
		}
	}

	public float generalFrameRate(){
		return generalFrameRate;
	}

	public float deltaTime(){
		return deltaTime;
	}

	public float deltaMillis(){
		return deltaMillis;
	}




}