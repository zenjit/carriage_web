class Box {

  int[] frameColor = new int[3];
  int[] frameInactiveColor = new int[3];
  int[] frameActiveColor = new int[3];
  int[] frameUsedColor = new int[3];
  int[] fillColor = new int[3];
  int[] fontColor = new int[3];
  float fontSize;
  String keyword;
  float boxWidth, boxHeight;
  float positionH, positionV; 
  float positionHmov, positionVmov;
  float cornerRadius = 5; 
  //  boolean active = true;
  //  boolean used = false;
  int status = 1; 
  float transparency = 150;
  Box next = null;

  /* Constructor */
  Box(String keyw, float posH, float posV, float fontSizeR) {
    /* Color setup */
    // There must be a better way to set this

    frameInactiveColor[0] = 118; 
    frameInactiveColor[1] = 118; 
    frameInactiveColor[2] = 118;
    frameActiveColor[0] = 0; 
    frameActiveColor[1] = 255; 
    frameActiveColor[2] = 0;
    arraycopy(frameInactiveColor, 0, frameUsedColor, 0, frameInactiveColor.length );
    arraycopy(frameActiveColor, 0, frameColor, 0, frameInactiveColor.length );
    //    frameUsedColor[0] = 118; 
    //    frameUsedColor[1] = 118; 
    //    frameUsedColor[2] = 118;
    //    frameColor = frameActiveColor;
    fillColor[0] = 201;
    fillColor[1] = 102; 
    fillColor[2] = 10;
    fontColor[0] = 0; 
    fontColor[1] = 0; 
    fontColor[2] = 0;

    fontSize = fontSizeR;

    keyword = keyw;

    boxWidth = fontSizeR * 0.5 * keyword.length() + 20;
    boxHeight = fontSizeR * 1.5;
    positionH = positionHmov = posH;
    positionV = positionVmov = posV;
  }

  /* Draws box */
  void drawBox() {
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

  void updateColors() {
    if (status == 3) {
      arraycopy(frameUsedColor, 0, frameColor, 0, frameUsedColor.length);
      transparency = 255;
    } 
    else if (status == 1) {
      arraycopy(frameActiveColor, 0, frameColor, 0, frameUsedColor.length);
      transparency = 150;
    } 
    else {
      arraycopy(frameInactiveColor, 0, frameColor, 0, frameUsedColor.length);
      transparency = 150;
    }
    //    active = !active;
    //    if (!active)
    //      used = !used;
  }

  boolean isClicked () {
    if (  mouseX > positionHmov && mouseX < positionHmov + boxWidth &&
      mouseY > positionVmov && mouseY < positionVmov + boxHeight ) {
      
        updateColors();
        
        float time = millis();
      while (millis ()-time < 200) {
      }

      return true;
    }
    else return false;
  }

  void move() {
    positionHmov += 0.1*(positionH - positionHmov);
    positionVmov += 0.1*(positionV - positionVmov);
  }

  void setStatus(int stat) {
    status = stat;
    updateColors();
  }
  int getStatus() {
    return status;
  }


  //  void setActive() {
  //    
  //    active = true;
  //  }
  //  void setInActive() {
  //    active = false;
  //    used = false;
  //  }
  //  boolean isActive() {
  //    return active;
  //  }
  //
  //  boolean isUsed() {
  //    return used;
  //  }
  //  void setUsed() {
  //    used = true;
  //  }
  //  void setUnUsed() {
  //    used = false;
  //  }

  //  void setUnused() {
  //    used = false;
  //  }

  String getKey() {
    return keyword;
  }
}

