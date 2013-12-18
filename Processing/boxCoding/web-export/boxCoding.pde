/**
 Box-coding
 
 Rafael Redondo Tejedor CC - 12.2013
 Zenjiskan - 12.2013
 */
import java.util.List;

/* General page settings */
int screenWidth = 600, screenHeight = 400;

/* Fonts */
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
int nSongs = 0;

/* Command Boxes  */
String[] cwords = {
  "play", "repeat", "random"
};

/* Items Boxes  */
String allsongsKey = "all songs";
String[] iwords = {
  allsongsKey, "1", "2", "3", "4", "5"
};

/* Option Boxes  */
String shuffleKey = "shuffle";
String[] owords = {
  "volume", shuffleKey
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

  /* Creates a few boxes at the corner*/
  for (int w = 0; w < cwords.length; w++) {
    cboxes[w] = new BoxCommand(cwords[w], 0, 0, fontSizeRef);
  }

  for (int w = 0; w < iwords.length; w++) {
    iboxes[w] = new BoxItem(iwords[w], 0, 0, fontSizeRef);
    iboxes[w].setStatus(2);
  }

  for (int w = 0; w < owords.length; w++) {
    oboxes[w] = new BoxOption(owords[w], 0, 0, fontSizeRef);
    oboxes[w].setStatus(2);
  }

  /* Rellocate boxes from the corner */
  relocateBoxes();
}

void draw() {
  /* mouse event detected on boxes*/
  if (mousePressed) {
    actionHandler();
  }

  /* draws everything */
  background(0, 0, 0, 1.0);
  fill(240);
  noStroke();
  rect(marginLeftRightC/2, screenHeight/2, width-marginLeftRightC, screenHeight/2-marginTopC, 5);
  for (BoxCommand c: cboxes) {
    c.move();
    c.drawBox();
  }
  for (BoxItem i: iboxes) {
    i.move();
    i.drawBox();
  }  
  for (BoxOption o: oboxes) {
    o.move();
    o.drawBox();
  }
}

void actionHandler () {

  /* control boxes */
  for (BoxCommand c: cboxes) {
    if (c.isClicked()) {
      /* status used */
      if (c.getStatus() == 3) {
        removeCommandAndRelocateBoxes(c);
      }
      /* status active */
      else if (c.getStatus() == 1) {
        if (c.getKey() == "random") { 
          randomSentence(); 
          break;
        }
        insertCommandAndRelocateBoxes(c);
      }
    }
  }

  /* item boxes */
  for (BoxItem i: iboxes) {
    if (i.isClicked()) {
      /* status used */
      if (i.getStatus() == 3) {
        removeItemAndRelocateBoxes(i);
      } 
      /* status active */
      else if (i.getStatus() == 1) {
        insertItemAndRelocateBoxes(i);
      }
    }
  }

  /* option boxes */
  for (BoxOption o: oboxes) {
    if (o.isClicked()) {
      if (o.getStatus() == 3) {
        removeOptionAndRelocateBoxes(o);
      }
      else if (o.getStatus() == 1) {
        insertOptionAndRelocateBoxes(o);
      }
    }
  }

  relocateBoxes();
}

void relocateBoxes() {
  posHCounterC = marginLeftRightC;
  posVCounterC = marginTopC;

  for (BoxCommand c: cboxes) {
    if (c.getStatus() != 3) {
      if (posHCounterC + c.boxWidth > width - marginLeftRightC) {
        posHCounterC = marginLeftRightC;
        posVCounterC += c.boxHeight + boxVerticalGap;
      }
      c.reallocate(posHCounterC, posVCounterC);
      posHCounterC += c.boxWidth + boxHorizontalGap;
    }
  }

  posHCounterI = marginLeftRightI;
  posVCounterI = posVCounterC + cboxes[0].boxHeight + boxVerticalGap+10;

  for (BoxItem i: iboxes) {
    if (i.getStatus() != 3) {
      if (posHCounterI + i.boxWidth > width - marginLeftRightI) {
        posHCounterI = marginLeftRightI;
        posVCounterI += i.boxHeight + boxVerticalGap;
      }
      i.reallocate(posHCounterI, posVCounterI);
      posHCounterI += i.boxWidth + boxHorizontalGap;
    }
  }

  posHCounterO = marginLeftRightO;
  posVCounterO = posVCounterI + iboxes[0].boxHeight + boxVerticalGap+10;


  for (BoxOption o: oboxes) {
    if (o.getStatus() != 3) {
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
    sentence.add(bcPointer.getKey());
    if (posHCounterSentence + bcPointer.boxWidth > width - marginLeftRightC) {
      posHCounterSentence = marginLeftRightC;
      posVCounterSentence += bcPointer.boxHeight + boxVerticalGap;
    }
    bcPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += bcPointer.boxWidth + boxHorizontalGap;
    bcPointer = bcPointer.next;
  }

  while (biPointer != null) {
    sentence.add(biPointer.getKey());
    if (posHCounterSentence + biPointer.boxWidth > width - marginLeftRightC) {
      posHCounterSentence = marginLeftRightC;
      posVCounterSentence += biPointer.boxHeight + boxVerticalGap;
    }
    biPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += biPointer.boxWidth + boxHorizontalGap;
    biPointer = biPointer.next;
  }

  while (boPointer != null) {
    sentence.add(boPointer.getKey());
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

void randomSentence() {
  int unodue = (int)(random (0, 2)); // random between play and repeat
  insertCommandAndRelocateBoxes(cboxes[unodue]);

  int songs = (int)(random (0, 2)); // random between all songs and song list
  if (songs == 1) {
    generateRandomSongList();
  }
  else {
    insertItemAndRelocateBoxes(iboxes[0]);
  }

  int options = (int)(random (0, 3)); // random number of options
  if (options == 1) {
    int whichOption = (int)(random (0, 2)); // random between play and repeat
    insertOptionAndRelocateBoxes(oboxes[whichOption]);
  }
  else if (options == 2) { // both options
    insertOptionAndRelocateBoxes(oboxes[0]);
    insertOptionAndRelocateBoxes(oboxes[1]);
  }
}

void generateRandomSongList() {
  boolean isFirstOccurrence = false;
  int songNumber, count = 0;
  int numberOfSongs = (int)(random (1, 6));
  int[] rndsongs = new int[numberOfSongs];

  println(numberOfSongs);

  do {
    isFirstOccurrence = true;
    // get random song
    songNumber = (int)(random(0, 6));

    // if the song number already exists in the array
    for (int i = 0; i < rndsongs.length; i++)
    {
      if (rndsongs[i] == songNumber)
        isFirstOccurrence = false;
    }
    if (isFirstOccurrence)
    {
      rndsongs[count] = songNumber;
      count++;
    }
  }
  while (count < numberOfSongs);

  for (int r =0; r < rndsongs.length; r++) {
    println(rndsongs[r]);
    insertItemAndRelocateBoxes(iboxes[rndsongs[r]]);
  }
}



List<String> giveMeMySentence() {
  return sentence;
}

void removeCommandAndRelocateBoxes (BoxCommand c) {
  removeBoxCommand(c);
  for (BoxCommand cc: cboxes) {
    cc.setStatus(1);
  }
  for (BoxItem i: iboxes) {
    if (i.getStatus() == 3) {
      removeBoxItem(i);
    }
    i.setStatus(2);
  }
  for (BoxOption o: oboxes) {
    if (o.getStatus() == 3) {
      removeBoxOption(o);
    }
    o.setStatus(2);
  }
}

void insertCommandAndRelocateBoxes (BoxCommand c) {
  for (BoxCommand cc: cboxes) {
    cc.setStatus(2);
  }
  for (BoxItem i: iboxes) {
    i.setStatus(1);
  }
  for (BoxOption o: oboxes) {
    o.setStatus(2);
  }
  insertBoxCommand(c);
}

void removeItemAndRelocateBoxes (BoxItem i) {
  removeBoxItem(i);
  if (i.getKey() == allsongsKey) {
    for (BoxOption o: oboxes) {
      if (o.getStatus() == 3)
        removeBoxOption(o);
    }
    i.setStatus(1);
    for (BoxItem ii: iboxes)
      ii.setStatus(1);
    for (BoxOption o: oboxes)
      o.setStatus(2);
  }
  else {
    nSongs--;
    if (nSongs == 0) {
      for (BoxOption o: oboxes) {
        if (o.getStatus() == 3) {
          removeBoxOption(o);
        }
        o.setStatus(2);
      }
      for (BoxItem ii: iboxes)
        if (ii.getKey() == allsongsKey)
          ii.setStatus(1);
    }
    if (nSongs <= 1) {
      for (BoxOption o: oboxes)
        if (o.getKey() == shuffleKey) {
          if (o.getStatus() == 3) {
            removeBoxOption(o);
          }
          o.setStatus(2);
        }
    }
  }
}

void insertItemAndRelocateBoxes (BoxItem i) {
  if (i.getKey() == allsongsKey) {
    for (BoxItem ii: iboxes) {
      ii.setStatus(2);
    }
    i.setStatus(3);
    for (BoxOption o: oboxes)
      o.setStatus(1);
  }
  else {
    nSongs++;
    for (BoxItem ii: iboxes)
      if (ii.getKey() == allsongsKey)
        ii.setStatus(2);
    if (nSongs == 1) {
      for (BoxOption o: oboxes)
        if (o.getKey() == shuffleKey)
          o.setStatus(2);
        else o.setStatus(1);
    } 
    else {
      for (BoxOption o: oboxes)
        if (o.getKey() == shuffleKey)
          o.setStatus(1);
    }
  }
  insertBoxItem(i);
}

void removeOptionAndRelocateBoxes (BoxOption o) {
  removeBoxOption(o);        
  o.setStatus(1);
}

void insertOptionAndRelocateBoxes (BoxOption o) {
  o.setStatus(3);
  insertBoxOption(o);
}

void insertBoxCommand(BoxCommand aBox) {
  aBox.setStatus(3);
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

void insertBoxItem(BoxItem aBox) {
  aBox.setStatus(3);
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

void insertBoxOption(BoxOption aBox) {
  aBox.setStatus(3);
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

void removeBoxCommand(BoxCommand aBox) {
  if (aBox.getStatus() == 3) {
    aBox.setStatus(1);
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
}

void removeBoxItem(BoxItem aBox) {
  if (aBox.getStatus() == 3) {
    aBox.setStatus(1);
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
}

void removeBoxOption(BoxOption aBox) {
  if (aBox.getStatus() == 3) {
    aBox.setStatus(1);
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
}
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



