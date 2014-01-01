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
  //float cornerRadius = 5;
  //  boolean active = true;
  //  boolean used = false;
  int status = 1; 
  float transparency = 150;
  String openParenthesis = "";
  String closedParenthesis = "";
  String openBrackets = "";
  String closedBrackets = "";
  String comma = "";
  float transpSymbol = 0;
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
    fillColor[0] = 201;
    fillColor[1] = 102; 
    fillColor[2] = 10;
    fontColor[0] = 0; 
    fontColor[1] = 0; 
    fontColor[2] = 0;
    arraycopy(frameInactiveColor, 0, frameUsedColor, 0, frameInactiveColor.length );
    arraycopy(frameActiveColor, 0, frameColor, 0, frameInactiveColor.length );
    arraycopy(fillColor, 0, fillColor, 0, fillColor.length );
    arraycopy(fontColor, 0, fontColor, 0, fontColor.length );

    fontSize = fontSizeR;

    keyword = keyw;

    boxWidth = fontSizeR * 0.75 * keyword.length() + 20;
    boxHeight = fontSizeR * 1.5;
    positionH = positionHmov = posH;
    positionV = positionVmov = posV;
  }

  /* Draws box */
  void drawBox() {
    strokeWeight(2);
    stroke(frameColor[0], frameColor[1], frameColor[2]);    
    fill(fillColor[0], fillColor[1], fillColor[2], transparency);
    rect(positionHmov, positionVmov, boxWidth, boxHeight /*, cornerRadius*/);
    fill(fontColor[0], fontColor[1], fontColor[2], transparency);
    //    textSize(fontSize); // uncomment this for custom fontSize
    text(keyword, positionHmov, positionVmov + 2, boxWidth, boxHeight);

    // open parenthesis between command and items,
    fill(0, 0, 0, transpSymbol);
    text(openParenthesis, positionH+boxWidth, positionV + 2, punctuationGapLR, boxHeight);
    text(closedParenthesis, posHCounterSentence, positionV + 2, punctuationGapLR, boxHeight);
    text(openBrackets, positionH - punctuationGapLR, positionV + 2, punctuationGapLR, boxHeight);
    text(closedBrackets, positionH + boxWidth, positionV + 2, punctuationGapLR, boxHeight);
    text(comma, positionH - punctuationGapLR, positionV + 2, punctuationGapLR, boxHeight); 
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
      transpSymbol = 0;
    } 
    else {
      arraycopy(frameInactiveColor, 0, frameColor, 0, frameUsedColor.length);
      transparency = 150;
      transpSymbol = 0;
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
    if (status == 3 && abs(positionH - positionHmov) < boxHeight && abs(positionV - positionVmov) < boxWidth)
      transpSymbol = min(255, transpSymbol+10);
  }

  void setStatus(int stat) {
    status = stat;
    updateColors();
  }

  int getStatus() {
    return status;
  }

  String getKey() {
    return keyword;
  }
}

class BoxCommand extends Box {

  BoxCommand next = null;

  /* Constructor */
  BoxCommand(String keyw, float posH, float posV, float fontSizeR) {
    super(keyw, posH, posV, fontSizeR);
  }
}

class BoxItem extends Box {

  BoxItem next = null;

  /* Constructor */
  BoxItem(String keyw, float posH, float posV, float fontSizeR) {
    super(keyw, posH, posV, fontSizeR);
  }
}

class BoxOption extends Box {

  BoxOption next = null;

  /* Constructor */
  BoxOption(String keyw, float posH, float posV, float fontSizeR) {
    super(keyw, posH, posV, fontSizeR);
  }
}

