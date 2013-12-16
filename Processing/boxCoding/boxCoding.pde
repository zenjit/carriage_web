/**
 Box-coding
 
 Rafael Redondo Tejedor CC - 12.2013
 Zenjiskan - 12.2013
 */
import java.util.List;

/* General page settings */
int screenWidth = 600, screenHeight = 400;

/* Boxes colors */
int[] frameColor = new int[3];
int[] activeFrameColor = new int[3];
int[] fillColor = new int[3];

/* Fonts */
int[] fontColor = new int[3];
float fontSizeRef = 15;

/* Boxes general settings */
float boxHorizontalGap = 10, boxVerticalGap = 10;
float delta = 10;
float marginLeftRightC = 10, marginTopC = delta;
float marginLeftRightI = 10, marginTopI = fontSizeRef * 2.5 + 10;
float marginLeftRightO = 10, marginTopO = fontSizeRef * 5 + 10;

/* Some counters */
float posHCounterC, posHCounterI, posHCounterO;
float posVCounterC, posVCounterI, posVCounterO;
float posHCounterSentence;
float posVCounterSentence;

/* Command Boxes  */
String[] cwords = {
  "play", "repeat", "random"
};

/* Items Boxes  */
String[] iwords = {
  "all songs", "1", "2", "3", "4", "5"
};

/* Option Boxes  */
String[] owords = {
  "volume", "shuffle"
};

BoxCommand[] cboxes = new BoxCommand[cwords.length];
BoxItem[] iboxes = new BoxItem[iwords.length];
BoxOption[] oboxes = new BoxOption[owords.length];

BoxCommand bcHead = null;
BoxItem biHead = null;
BoxOption boHead = null;

List<String> sentence;

void setup() {
  frameRate(30);
  size(600, 400);
  //  colorMode(RGB,1); // color nomenclature: RGB, HSV,...
  textSize(fontSizeRef);
  textAlign(CENTER);

  /* Color setup */
  // There must be a better way to set this
  frameColor[0] = 211; 
  frameColor[1] = 152; 
  frameColor[2] = 10;
  activeFrameColor[0] = 0; 
  activeFrameColor[1] = 255; 
  activeFrameColor[2] = 0;
  fillColor[0] = 211; 
  fillColor[1] = 211; 
  fillColor[2] = 211;
  fontColor[0] = 0; 
  fontColor[1] = 0; 
  fontColor[2] = 0;

  /* Creates a few boxes at the corner*/
  for (int w = 0; w < cwords.length; w++) {
    cboxes[w] = new BoxCommand(cwords[w], 0, 0, fontSizeRef, activeFrameColor, fillColor, fontColor);
  }
  
  for (int w = 0; w < iwords.length; w++) {
    iboxes[w] = new BoxItem(iwords[w], 0, 0, fontSizeRef, frameColor, fillColor, fontColor);
  }

  for (int w = 0; w < owords.length; w++) {
    oboxes[w] = new BoxOption(owords[w], 0, 0, fontSizeRef, frameColor, fillColor, fontColor);
  }

  /* Reallocate boxes from the corner */
  relocateBoxes();
}

void draw() {
  /* mouse event detented on boxes*/
  if (mousePressed) {
    for (BoxCommand c: cboxes) {
      if (mouseX > c.positionHmov && mouseX < c.positionHmov + c.boxWidth &&
        mouseY > c.positionVmov && mouseY < c.positionVmov + c.boxHeight) {
        if (c.clickedStatus()) {
          for (BoxItem i: iboxes) {
            i.setAvailable(true);
          }
          insertCommandBox(c);
        } 
        else {
          removeCommandBox(c);
        }
        relocateBoxes();
      }
    }
    for (BoxItem i: iboxes) {
      if (mouseX > i.positionHmov && mouseX < i.positionHmov + i.boxWidth &&
        mouseY > i.positionVmov && mouseY < i.positionVmov + i.boxHeight) {
        if (i.clickedStatus()) {
          insertItemBox(i);
        } 
        else {
          removeItemBox(i);
        }
        relocateBoxes();
      }
    }
    for (BoxOption o: oboxes) {
      if (mouseX > o.positionHmov && mouseX < o.positionHmov + o.boxWidth &&
        mouseY > o.positionVmov && mouseY < o.positionVmov + o.boxHeight) {
        if (o.clickedStatus()) {
          insertOptionBox(o);
        } 
        else {
          removeOptionBox(o);
        }
        relocateBoxes();
      }
    }
  }

  /* moves boxes */
  for (BoxCommand c: cboxes) {
    c.move();
  }
  for (BoxItem i: iboxes) {
    i.move();
  }
  for (BoxOption o: oboxes) {
    o.move();
  }

  /* draws everything */
  background(0, 0, 0, 1.0);
  fill(240);
  noStroke();
  rect(marginLeftRightC/2, screenHeight/2, width-marginLeftRightC, screenHeight/2-marginTopC, 5);
  for (BoxCommand c: cboxes) {
    c.drawBoxes();
  }
  for (BoxItem i: iboxes) {
    i.drawBoxes();
  }  
  for (BoxOption o: oboxes) {
    o.drawBoxes();
  }
}

void relocateBoxes() {
  posHCounterC = marginLeftRightC;
  posVCounterC = marginTopC;
  posHCounterI = marginLeftRightI;
  posVCounterI = marginTopI;
  posHCounterO = marginLeftRightO;
  posVCounterO = marginTopO;

  for (BoxCommand c: cboxes) {
    if (!c.active) {
      if (posHCounterC + c.boxWidth > width - marginLeftRightC) {
        posHCounterC = marginLeftRightC;
        posVCounterC += c.boxHeight + boxVerticalGap;
      }
      c.reallocate(posHCounterC, posVCounterC);
      posHCounterC += c.boxWidth + boxHorizontalGap;
    }
  }
  
  for (BoxItem i: iboxes) {
    if (!i.active) {
      if (posHCounterI + i.boxWidth > width - marginLeftRightI) {
        posHCounterI = marginLeftRightI;
        posVCounterI += i.boxHeight + boxVerticalGap;
      }
      i.reallocate(posHCounterI, posVCounterI);
      posHCounterI += i.boxWidth + boxHorizontalGap;
    }
  }

  for (BoxOption o: oboxes) {
    if (!o.active) {
      if (posHCounterO + o.boxWidth > width - marginLeftRightO) {
        posHCounterO = marginLeftRightO;
        posVCounterO += o.boxHeight + boxVerticalGap;
      }
      o.reallocate(posHCounterO, posVCounterO);
      posHCounterO += o.boxWidth + boxHorizontalGap;
    }
  }

  posHCounterSentence = marginLeftRightC;
  posVCounterSentence = screenHeight/2 + marginTopC;
  
  BoxCommand bcPointer = bcHead;
  BoxItem biPointer = biHead;
  BoxOption boPointer = boHead;
  
  sentence = new ArrayList<String>();
  
  while (bcPointer != null) {
    sentence.add(bcPointer.keyword);
    if (posHCounterSentence + bcPointer.boxWidth > width - marginLeftRightC) {
      posHCounterSentence = marginLeftRightC;
      posVCounterSentence += bcPointer.boxHeight + boxVerticalGap;
    }
    bcPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += bcPointer.boxWidth + boxHorizontalGap;
    bcPointer = bcPointer.next;
  }
  
  while (biPointer != null) {
    sentence.add(biPointer.keyword);
    if (posHCounterSentence + biPointer.boxWidth > width - marginLeftRightC) {
      posHCounterSentence = marginLeftRightC;
      posVCounterSentence += biPointer.boxHeight + boxVerticalGap;
    }
    biPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += biPointer.boxWidth + boxHorizontalGap;
    biPointer = biPointer.next;
  }
  
  while (boPointer != null) {
    sentence.add(boPointer.keyword);
    if (posHCounterSentence + boPointer.boxWidth > width - marginLeftRightC) {
      posHCounterSentence = marginLeftRightC;
      posVCounterSentence += boPointer.boxHeight + boxVerticalGap;
    }
    boPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += boPointer.boxWidth + boxHorizontalGap;
    boPointer = boPointer.next;
  }
  
  print("Sentence: ");
  for (String z : sentence)
    print(z + ' ');
  println();
}

void insertCommandBox(BoxCommand aBox) {
  if (bcHead == null) {
    bcHead = aBox;
  } 
  else {
      BoxCommand bPointer = bcHead; 
    while (bPointer.next != null)
    {
      bPointer = bPointer.next;
    }
    bPointer.next = aBox;
  }
}

void insertItemBox(BoxItem aBox) {
  if (biHead == null) {
    biHead = aBox;
  } 
  else {
      BoxItem bPointer = biHead; 
    while (bPointer.next != null)
    {
      bPointer = bPointer.next;
    }
    bPointer.next = aBox;
  }
}

void insertOptionBox(BoxOption aBox) {
  if (boHead == null) {
    boHead = aBox;
  } 
  else {
      BoxOption bPointer = boHead; 
    while (bPointer.next != null)
    {
      bPointer = bPointer.next;
    }
    bPointer.next = aBox;
  }
}

void removeCommandBox(BoxCommand aBox) {
  BoxCommand aPointer;
  if (aBox.equals(bcHead)) {
    aPointer = bcHead;
    bcHead = bcHead.next;
    aPointer.next = null;
  }
  else {
    BoxCommand bPointer = bcHead;
    while (!aBox.equals (bPointer.next)) {
      bPointer = bPointer.next;
    }
    aPointer = bPointer.next;
    bPointer.next = bPointer.next.next;
    aPointer.next = null;
  }
}

void removeItemBox(BoxItem aBox) {
  BoxItem aPointer;
  if (aBox.equals(biHead)) {
    aPointer = biHead;
    biHead = biHead.next;
    aPointer.next = null;
  }
  else {
    BoxItem bPointer = biHead;
    while (!aBox.equals (bPointer.next)) {
      bPointer = bPointer.next;
    }
    aPointer = bPointer.next;
    bPointer.next = bPointer.next.next;
    aPointer.next = null;
  }
}

void removeOptionBox(BoxOption aBox) {
  BoxOption aPointer;
  if (aBox.equals(boHead)) {
    aPointer = boHead;
    boHead = boHead.next;
    aPointer.next = null;
  }
  else {
    BoxOption bPointer = boHead;
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