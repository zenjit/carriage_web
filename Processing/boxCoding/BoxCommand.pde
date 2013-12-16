class BoxCommand implements Box {
  int[] frameColor = new int[3];
  int[] fillColor = new int[3];
  int[] fontColor = new int[3];
  float fontSize;
  String keyword;
  float boxWidth, boxHeight;
  float positionH, positionV; 
  float positionHmov, positionVmov;
  float cornerRadius = 5; 
  boolean active = false;
  float transparency = 150;
  String[] blockedWords;
  boolean blockedStatus = false;
  boolean available;
  BoxCommand next = null;
  
    /* Constructor */
//  Box(String keyw, float posH, float posV, float fontSizeR, 
//  int[] frameC, int[] fillC, int[] fontC);

  BoxCommand(String keyw, float posH, float posV, float fontSizeR, int[] frameC, int[] fillC, int[] fontC){
    keyword = keyw;
    boxWidth = fontSizeR * 0.5 * keyword.length() + 20;
    boxHeight = fontSizeR * 1.5;
    positionH = positionHmov = posH;
    positionV = positionVmov = posV;
    fontSize = fontSizeR;
    frameColor = frameC;
    fillColor = fillC;
    fontColor = fontC;
  }

  void drawBoxes(){
    strokeWeight(2);
    stroke(frameColor[0], frameColor[1], frameColor[2]);
    
    fill(fillColor[0], fillColor[1], fillColor[2], transparency);
    rect(positionHmov, positionVmov, boxWidth, boxHeight, cornerRadius);
    fill(fontColor[0], fontColor[1], fontColor[2], transparency);
    //    textSize(fontSize); // uncomment this for custom fontSize
    text(keyword, positionHmov, positionVmov+4, boxWidth, boxHeight);
//    text("(", positionHmov+20, positionVmov+4, boxWidth, boxHeight);  
  }
  
  void reallocate(float posH, float posV) {
    positionH = posH;
    positionV = posV;
  }

  boolean clickedStatus() {
    active = !active;
    if (active)
      transparency = 255;
    else transparency = 150;

    float time = millis();
    while (millis()-time < 200) {
    }
    return active;
  }
  
  void setAvailable(boolean set) {
    available = set;
  
  }
  
  void setUnavailable(boolean set) {
    available = set;
  
  }
  
  boolean getAvailable() {
    return available;
  
  }
  
  void move() {
    positionHmov += 0.1*(positionH - positionHmov);
    positionVmov += 0.1*(positionV - positionVmov);
  }

}
