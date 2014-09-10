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
  int status = 1; 
  float fillTransparency = 150;
  float fontTransparency = 255;
  String openParenthesis = "";
  String closedParenthesis = "";
  String openBrackets = "";
  String closedBrackets = "";
  String comma = "";
  float transpSymbol = 0;
  boolean isAtBottom = false;
  Box next = null;

  /* Constructor */
  Box(String keyw, float posH, float posV, float fontSizeR) {
    /* Color setup */
    // There must be a better way to set this

    frameUsedColor[0] = 118; 
    frameUsedColor[1] = 118; 
    frameUsedColor[2] = 118;
    frameColor[0] = 0; 
    frameColor[1] = 255; 
    frameColor[2] = 0;
    fillColor[0] = 0;
    fillColor[1] = 0; 
    fillColor[2] = 0;
    fontColor[0] = 255; 
    fontColor[1] = 255; 
    fontColor[2] = 255;
    fontSize = fontSizeR;

    keyword = keyw;

    boxWidth = fontSizeR * 0.65 * keyword.length() + delta;
    boxHeight = fontSizeR * 1.5;
    positionH = positionHmov = posH;
    positionV = positionVmov = posV;
  }

  /* Draws box */
  void drawBox() {
    /* Drawing boxes */
    strokeWeight(2);
    // Box Frame Color
    stroke(frameColor[0], frameColor[1], frameColor[2], fontTransparency);
    // Box Fill Color
    fill(fillColor[0], fillColor[1], fillColor[2], fillTransparency);
    rect(positionHmov, positionVmov-delta/2, boxWidth, boxHeight /*, cornerRadius*/);
    // Font Color
    fill(fontColor[0], fontColor[1], fontColor[2], fontTransparency);
    textFont(font, fontSizeRef);
    text(keyword, positionHmov, positionVmov + 8 -delta/2, boxWidth, boxHeight);
  }

  void drawPunctuation() {
    /* Drawing punctuation marks */
    fill(0, 0, 0, transpSymbol);
    text(openParenthesis, positionH+boxWidth, positionV +4, punctuationGapLR, boxHeight);
    // Only for the closed parenthesis, posHClosedParenthesis custom variable is used, see BoxHandler.pde
    text(closedParenthesis, posHClosedParenthesis, posVClosedParenthesis +4, punctuationGapLR, boxHeight);
    text(openBrackets, positionH - punctuationGapLR, positionV +4 , punctuationGapLR, boxHeight);
    text(closedBrackets, positionH + boxWidth, positionV +4, punctuationGapLR, boxHeight);
    text(comma, positionH - punctuationGapLR, positionV +5, punctuationGapLR, boxHeight);
    fill(0, 0, 0, 255*sin(frameCounter));
    text("▒", posHPrompt + punctuationGapLR - delta/2, posVPrompt +4, punctuationGapLR, boxHeight);
  }

  void reallocate(float posH, float posV) {
    positionH = posH;
    positionV = posV;
  }

  void updateColors() {
    // Used
    if (status == 3 && isAtBottom) {
      frameColor[0] = 0;
      frameColor[1] = 0; 
      frameColor[2] = 0;
      fontColor[0] = 0;
      fontColor[1] = 0;
      fontColor[2] = 0;
      fillTransparency = 0;
      fontTransparency = 255;
    } 
    // Available
    else if (status == 1) {
      frameColor[0] = 0; 
      frameColor[1] = 255; 
      frameColor[2] = 0;
      fontColor[0] = 255;
      fontColor[1] = 255;
      fontColor[2] = 255;
      fillTransparency = 255;
      fontTransparency = 255;
      transpSymbol = 0;
    } 
    // Unavailable
    else {
      frameColor[0] = 255; 
      frameColor[1] = 255; 
      frameColor[2] = 255;
      fontColor[0] = 255;
      fontColor[1] = 255;
      fontColor[2] = 255;
      fillTransparency = 150;
      fontTransparency = 150;
      //transpSymbol = 150;
    }
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
    if (status == 3 && abs(positionH - positionHmov) < boxHeight && abs(positionV - positionVmov) < 5) {
      transpSymbol = min(255, transpSymbol+5);
      fillTransparency = min(255, fillTransparency+1);
      //fontTransparency = max(0, fontTransparency+5);
      isAtBottom = true;
      updateColors();
    }
  }

  void setStatus(int stat) {
    status = stat;
    if (status!=3) {
      isAtBottom = false;
    }
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

