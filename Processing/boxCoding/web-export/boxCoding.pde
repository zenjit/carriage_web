/**
 Box-coding
 
 Rafael Redondo Tejedor CC - 12.2013
 */
import java.util.List;

/* General settings */
int screenWidth = 320, screenHeight = 220;
float boxHorizontalGap = 10, boxVerticalGap = 10;
float marginLeftRight = 10, marginTop = 10;

/* Some counters */
float positionHorizontalCounter;
float positionVerticalCounter;
float positionHorizontalCounterSentence;
float positionVerticalCounterSentence;

/* Boxes  */
String[] words = {
  "play", "repeat", "random", "all songs", "1", "2", "3", "4", "5", "volume", "shuffle"
}; 
Box[] boxes = new Box[words.length];
Box bHead = null;

List<String> sentence;

/* Boxes colors */
int[] frameColor = new int[3];
int[] fillColor = new int[3];

/* Fonts */
int[] fontColor = new int[3];
float fontSizeReference = 15;

void setup() {
  frameRate(30);
  size(320, 220);
  //  colorMode(RGB,1); // color nomenclature: RGB, HSV,...
  textSize(fontSizeReference);
  textAlign(CENTER);

  /* Color setup */
  // There must be a better way to set this
  frameColor[0] = 211; 
  frameColor[1] = 152; 
  frameColor[2] = 10;
  fillColor[0] = 201; 
  fillColor[1] = 102; 
  fillColor[2] = 10;
  fontColor[0] = 190; 
  fontColor[1] = 190; 
  fontColor[2] = 190;

  /* Creates a few boxes at the corner*/
  for (int w = 0; w < words.length; w++) {
    boxes[w] = new Box(words[w], 0, 0, fontSizeReference, frameColor, fillColor, fontColor);
  }

  /* Reallocate boxes from the corner */
  reallocateBoxes();
}

void draw() {
  /* mouse event */
  if (mousePressed) {
    for (Box b: boxes) {
      if (mouseX > b.positionHmov && mouseX < b.positionHmov + b.boxWidth &&
        mouseY > b.positionVmov && mouseY < b.positionVmov + b.boxHeight) {
        if (b.clickedStatus()) {
          insertBox(b);
        } 
        else {
          removeBox(b);
        }
        reallocateBoxes();
      }
    }
  }

  /* moves boxes */
  for (Box b: boxes) {
    b.move();
  }

  /* draws everything */
  background(0, 0, 0, 1.0);
  fill(240);
  noStroke();
  rect(marginLeftRight/2, screenHeight/2, width-marginLeftRight, screenHeight/2-marginTop, 5);
  for (Box b: boxes) {
    b.display();
  }
}

void reallocateBoxes() {
  positionHorizontalCounter = marginLeftRight;
  positionVerticalCounter = marginTop;

  for (Box b: boxes) {
    if (!b.active) {
      if (positionHorizontalCounter + b.boxWidth > width - marginLeftRight) {
        positionHorizontalCounter = marginLeftRight;
        positionVerticalCounter += b.boxHeight + boxVerticalGap;
      }
      b.reallocate(positionHorizontalCounter, positionVerticalCounter);
      positionHorizontalCounter += b.boxWidth + boxHorizontalGap;
    }
  }

  positionHorizontalCounterSentence = marginLeftRight;
  positionVerticalCounterSentence = screenHeight/2 + marginTop;
  Box bPointer = bHead;
  sentence = new ArrayList<String>();
  while (bPointer != null) {
    sentence.add(bPointer.keyword);
    if (positionHorizontalCounterSentence + bPointer.boxWidth > width - marginLeftRight) {
      positionHorizontalCounterSentence = marginLeftRight;
      positionVerticalCounterSentence += bPointer.boxHeight + boxVerticalGap;
    }
    bPointer.reallocate(positionHorizontalCounterSentence, positionVerticalCounterSentence);
    positionHorizontalCounterSentence += bPointer.boxWidth + boxHorizontalGap;
    bPointer = bPointer.next;
  }
  print("Sentence: ");
  for (String z : sentence)
    print(z + ' ');
  println();
}

void insertBox(Box aBox) {
  if (bHead == null) {
    bHead = aBox;
  } 
  else {
    Box bPointer = bHead; 
    while (bPointer.next != null)
    {
      bPointer = bPointer.next;
    }
    bPointer.next = aBox;
  }
}

void removeBox(Box aBox) {
  Box aPointer;
  if (aBox.equals(bHead)) {
    aPointer = bHead;
    bHead = bHead.next;
    aPointer.next = null;
  }
  else {
    Box bPointer = bHead;
    while (!aBox.equals (bPointer.next)) {
      bPointer = bPointer.next;
    }
    aPointer = bPointer.next;
    bPointer.next = bPointer.next.next;
    aPointer.next = null;
  }
}

List<String> giveMeMySentence() {
  return sentence;
}
class Box {
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
  Box next = null;
  String[] blockedWords;
  boolean blockedStatus = false;


  /* Constructor */
  Box(String keyw, float posH, float posV, float fontSizeR, 
  int[] frameC, int[] fillC, int[] fontC) {
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

  /* Draws box */
  void display() {
    strokeWeight(2);
    stroke(frameColor[0], frameColor[1], frameColor[2]);
    fill(fillColor[0], fillColor[1], fillColor[2], transparency);
    rect(positionHmov, positionVmov, boxWidth, boxHeight, cornerRadius);
    fill(fontColor[0], fontColor[1], fontColor[2], transparency);
    //    textSize(fontSize); // uncomment this for custom fontSize
    text(keyword, positionHmov, positionVmov+4, boxWidth, boxHeight);
//    text("(", positionHmov+20, positionVmov+4, boxWidth, boxHeight);
  }

  /* Changues absolute box location */
  void reallocate(float posH, float posV) {
    positionH = posH;
    positionV = posV;
  }

  /* Changes box status and appearance */
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

  /* Relative box movements */
  void move() {
    positionHmov += 0.1*(positionH - positionHmov);
    positionVmov += 0.1*(positionV - positionVmov);
  }
}


