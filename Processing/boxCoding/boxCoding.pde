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

