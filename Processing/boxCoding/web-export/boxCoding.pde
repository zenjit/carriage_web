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
float boxHorizontalGap = 10, boxVerticalGap = 10, boxHorizontalGapCommandLine = boxHorizontalGap * 2;
float delta = 10;
float marginLeftRight = delta;
float marginTopC = delta;
float marginTopI = fontSizeRef * 2.5 + 10;
float marginTopO = fontSizeRef * 5 + 10;
public float punctuationGapLR = boxHorizontalGapCommandLine;

/* Some counters */
float posHCounter;
float posVCounterC, posVCounterI, posVCounterO;
float posHCounterSentence;
float posVCounterSentence;
int nSongs = 0;

/* Command Boxes  */
String[] cwords = {
  "play", "repeat", "random"
};

/* Items Boxes  */
String allsongsKey = "all_songs";
String[] iwords = {
  allsongsKey, "1", "2", "3", "4", "5"
};

/* Option Boxes  */
String shuffleKey = "shuffle";
String[] owords = {
  "volume", shuffleKey
};

/* Punctuation */
char parOpen = '(';
char parClosed = ')';
char bracketOpen = '[';
char bracketClosed = ']';
char comma = ',';

BoxCommand[] cboxes = new BoxCommand[cwords.length];
BoxItem[] iboxes = new BoxItem[iwords.length];
BoxItem[] songList = new BoxItem[5];
BoxOption[] oboxes = new BoxOption[owords.length];

BoxCommand bcHead = null;
BoxItem biHead = null;
BoxItem songsPlaylistHead = null;
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
  rect(marginLeftRight/2, screenHeight/2, width-marginLeftRight, screenHeight/2-marginTopC, 5);

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
    nSongs = 0;
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
  //aBox.closedBrackets = "";
  if (aBox.getKey() != allsongsKey)
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
    aBox.comma = "";
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
    aBox.comma = "";
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

void relocateBoxes() {
  posHCounter = marginLeftRight;
  posVCounterC = marginTopC;

  for (BoxCommand c: cboxes) {
    if (c.getStatus() != 3) {
      if (posHCounter + c.boxWidth > width - marginLeftRight) {
        posHCounter = marginLeftRight;
        posVCounterC += c.boxHeight + boxVerticalGap;
      }
      c.reallocate(posHCounter, posVCounterC);
      posHCounter += c.boxWidth + boxHorizontalGap;
    }
  }

  posHCounter = marginLeftRight;
  posVCounterI = posVCounterC + cboxes[0].boxHeight + boxVerticalGap+10;

  for (BoxItem i: iboxes) {
    if (i.getStatus() != 3) {
      if (posHCounter + i.boxWidth > width - marginLeftRight) {
        posHCounter = marginLeftRight;
        posVCounterI += i.boxHeight + boxVerticalGap;
      }
      i.reallocate(posHCounter, posVCounterI);
      posHCounter += i.boxWidth + boxHorizontalGap;
    }
  }

  posHCounter = marginLeftRight;
  posVCounterO = posVCounterI + iboxes[0].boxHeight + boxVerticalGap+10;


  for (BoxOption o: oboxes) {
    if (o.getStatus() != 3) {
      if (posHCounter + o.boxWidth > width - marginLeftRight) {
        posHCounter = marginLeftRight;
        posVCounterO += o.boxHeight + boxVerticalGap;
      }
      o.reallocate(posHCounter, posVCounterO);
      posHCounter += o.boxWidth + boxHorizontalGap;
    }
  }

  posHCounterSentence = marginLeftRight;
  posVCounterSentence = screenHeight/2 + marginTopC;

  BoxCommand bcPointer = bcHead;
  BoxItem biPointer = biHead;
  BoxOption boPointer = boHead;

  sentence = new ArrayList<String>();

  // counters for pun
  int numCommands = 0;
  int numItems = 0;
  int numOptions = 0;

  // COMMAND LINE COMMANDS RELOCATION AND PUNCTUATION
  while (bcPointer != null) {
    sentence.add(bcPointer.getKey());
    if (posHCounterSentence + bcPointer.boxWidth > width - marginLeftRight) {
      posHCounterSentence = marginLeftRight;
      posVCounterSentence += bcPointer.boxHeight + boxVerticalGap;
    }
    bcPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += bcPointer.boxWidth + boxHorizontalGapCommandLine;

    numCommands ++;
    bcPointer.openParenthesis = "("; 
    bcPointer.closedParenthesis = ")";

    bcPointer = bcPointer.next;
  }

  if (numCommands == 0) {
    for (BoxCommand c: cboxes) {
      c.openParenthesis = "";
      c.closedParenthesis = "";
    }
  }

  String first = "";
  String last = "";
  boolean isFirst = true;
  // COMMAND LINE ITEMS RELOCATION AND PUNCTUATION
  while (biPointer != null) {
    sentence.add(biPointer.getKey());
    if (posHCounterSentence + biPointer.boxWidth > width - marginLeftRight) {
      posHCounterSentence = marginLeftRight;
      posVCounterSentence += biPointer.boxHeight + boxVerticalGap;
    }
    // if one or more songs are present
    if (biPointer.getKey() != allsongsKey) {
      numItems ++;
      // only for first song added, increse margin because two interpunc marks will be added '(['
      if (numItems == 1) {
        posHCounterSentence += punctuationGapLR;
      }
      if (numItems >= 1) {
        // save first and last songs in items
        if (isFirst) { 
          first = biPointer.getKey();
          last = biPointer.getKey();
        }
        else {
          last = biPointer.getKey();
        }
      }
    } 

    biPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += biPointer.boxWidth + boxHorizontalGapCommandLine ;
    biPointer = biPointer.next;
    isFirst = false;
  }
  println("len: " + numItems);
  println("first: " + first);
  println("last: " + last);

  if (numItems == 0) {
    for (BoxItem i: iboxes) {
      i.openBrackets = "";
      i.closedBrackets = "";
      i.comma = "";
    }
  }
  else {
    if (first == last) {
      for (BoxItem i: iboxes) {
        if (i.getKey () == first) {
          i.comma = "";
          i.openBrackets = "[";
          i.closedBrackets = "]";
          posHCounterSentence += punctuationGapLR/2;
        }
      }
    }
    else {
      println("here");
      for (BoxItem i: iboxes) {
        if (i.getStatus () == 3) {
          println ("iboxes " + i.getKey());
          if (i.getKey () == first) {
            i.closedBrackets = "";
            i.openBrackets = "[";
            i.comma = "";
          }
          else if (i.getKey () == last) {
            i.comma = ",";
            i.openBrackets = "";
            i.closedBrackets = "]";
            posHCounterSentence += punctuationGapLR/2;
          }
          else { 
            i.comma = ",";
            i.openBrackets = "";
            i.closedBrackets = "";
          }
        }
      }
    }
  }

  // COMMAND LINE OPTIONS RELOCATION AND PUNCTUATION
  while (boPointer != null) {
    sentence.add(boPointer.getKey());
    numOptions ++;
    if (posHCounterSentence + boPointer.boxWidth > width - marginLeftRight) {
      posHCounterSentence = marginLeftRight;
      posVCounterSentence += boPointer.boxHeight + boxVerticalGap;
    }

    boPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += boPointer.boxWidth + boxHorizontalGapCommandLine;
    boPointer = boPointer.next;
  }

  if (numOptions >= 1) {
    for (BoxOption o: oboxes)
      o.comma = ",";
  }
  else {
    for (BoxOption o: oboxes)
      o.comma = "";
  }



  print("Sentence: ");
  for (String z : sentence)
    print(z + ' ');
  println();
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
    arraycopy(frameInactiveColor, 0, frameUsedColor, 0, frameInactiveColor.length );
    arraycopy(frameActiveColor, 0, frameColor, 0, frameInactiveColor.length );
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
    text(keyword, positionHmov, positionVmov + 2, boxWidth, boxHeight);
    //    fill(0,0,0, transpSymbol);
    //fill(255,255,255);
    // open parenthesis between command and items,
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
    // bool drawSymbol is true when positionH - positionHmov && positionV - positionVmov < 0.1?
    transpSymbol = min(255, transpSymbol+0.01);
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


