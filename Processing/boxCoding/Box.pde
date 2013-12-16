class Box {

  int[] frameColor = new int[3];
  int[] frameAColor = new int[3];
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
  boolean available = true;
  boolean used = false;
  BoxCommand next = null;
  
  /* Constructor */
  //Box(String keyw, float posH, float posV, float fontSizeR, int[] frameC, int[] fillC, int[] fontC);
  
  void Box(String keyw, float posH, float posV, float fontSizeR, int[] frameC, int[] frameA, int[] fillC, int[] fontC){
    keyword = keyw;
    boxWidth = fontSizeR * 0.5 * keyword.length() + 20;
    boxHeight = fontSizeR * 1.5;
    positionH = positionHmov = posH;
    positionV = positionVmov = posV;
    fontSize = fontSizeR;
    frameColor = frameC;
    frameAColor = frameA;
    fillColor = fillC;
    fontColor = fontC;
  }

  /* Draws box */
  void drawBoxes(){};

  /* Changues absolute box location */
  void reallocate(float posH, float posV){};

  /* Changes box status and appearance */
  boolean clickedStatus(){return true;};

  /* Relative box movements */
  void move(){};
}
