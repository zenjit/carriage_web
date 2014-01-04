/**
 Box-coding
 
 Rafael Redondo Tejedor & Zenjiskan CC - 12.2013
 */
import java.util.List;

/* General page settings */
//int screenWidth = 800, screenHeight = 400;
//int screenWidthMobile = 400, screenHeightMobile = 300;
public boolean mobile = false;

/* Fonts */
float fontSizeRef = 16;

/* Boxes general settings */
float boxHorizontalGap = 10, boxVerticalGap = 10, boxHorizontalGapCommandLine = boxHorizontalGap * 2;
float delta = 10;
float marginLeftRight = delta;
float marginTopC = delta;
float executeButtonGap = fontSizeRef * 2.5;
public float punctuationGapLR = boxHorizontalGapCommandLine;
float promptGap = fontSizeRef * 4;

/* Execute button settings */
int[] execButtonColor = new int[3];
int[] execActiveColor = new int[3];
int[] execInactiveColor = new int[3];
public boolean execStatus = false; 

/* Some counters */
float frameCounter;
float posHCounter;
float posVCounterC, posVCounterI, posVCounterO;
float posHCounterSentence;
float posVCounterSentence;
float posHClosedParenthesis;
float posVClosedParenthesis;
float posHPrompt;
float posVPrompt;
int nSongs = 0;
int numberOfRndSongs = 0;

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
  shuffleKey, "loud"
};

/* Punctuation */
char parOpen = '(';
char parClosed = ')';
char bracketOpen = '[';
char bracketClosed = ']';
char comma = ',';

BoxCommand[] cboxes = new BoxCommand[cwords.length];
BoxItem[] iboxes = new BoxItem[iwords.length];
BoxOption[] oboxes = new BoxOption[owords.length];

BoxCommand bcHead = null;
BoxItem biHead = null;
BoxOption boHead = null;

List<String> sentence;

PFont font;

void setup() {
  // Font manager
  //  String[] fontList = PFont.list();
  //  println(fontList);
  font = createFont("Silom", 32, true);
  textFont(font, fontSizeRef);

  //mobile = true;
  frameRate(30);
  if (mobile) { 
    size(400, 300);
    fontSizeRef /= 1.2;
  }
  else {
    size(800, 400);
  }
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
  frameCounter += 0.1;

  /* draws everything */
  background(0, 0, 0, 1.0);
  fill(240);
  noStroke();
  if (mobile) {
    rect(marginLeftRight/2, height-(fontSizeRef * 6), width-marginLeftRight-executeButtonGap, (fontSizeRef*6)-delta/2, 5);
    fill(execButtonColor[0], execButtonColor[1], execButtonColor[2]);
    triangle(width-executeButtonGap, height-(fontSizeRef*4.5), width-delta, height-(fontSizeRef*3)-delta/2, width-executeButtonGap, height - delta/2 - fontSizeRef*1.5);
    fill(0, 0, 0);
    text(">>", marginLeftRight/2, height - (fontSizeRef * 6) + marginTopC + 2, promptGap/2, fontSizeRef * 1.5);
  }
  else {
    rect(marginLeftRight/2, height-(fontSizeRef * 3)+delta/4 -1, width-marginLeftRight-executeButtonGap, (fontSizeRef*2)-delta/2 +1, 5); 
    fill(execButtonColor[0], execButtonColor[1], execButtonColor[2]);
    triangle(width-executeButtonGap, height-(fontSizeRef*3)+delta/4 -1, width-delta*2, height-fontSizeRef*2, width-executeButtonGap, height - fontSizeRef);
    fill(0, 0, 0);
    text(">>", marginLeftRight/2, height - (fontSizeRef * 3) + marginTopC + 2, promptGap/2, fontSizeRef * 1.5);
  }
  updateExecButtonColor();

  for (BoxCommand c: cboxes) {
    c.move();
    c.drawBox();
    c.drawPunctuation();
  }
  for (BoxItem i: iboxes) {
    i.move();
    i.drawBox();
    i.drawPunctuation();
  }  
  for (BoxOption o: oboxes) {
    o.move();
    o.drawBox();
    o.drawPunctuation();
  }
  if (frameCounter >= 300) {
    frameCounter = 0;
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

  if (isExecButtonClicked()) {
  }
}

void updateExecButtonColor() {
  if (execStatus) {
    execButtonColor[0] = 0;
    execButtonColor[1] = 255;
    execButtonColor[2] = 0;
  } 
  else {
    execButtonColor[0] = 118;
    execButtonColor[1] = 118;
    execButtonColor[2] = 118;
  }
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
    int whichOption = (int)(random (0, 2)); // pick a random option (only one)
    if (numberOfRndSongs == 1) // if a single song has been randomly selected, don't put shuffle option
      insertOptionAndRelocateBoxes(oboxes[1]);
    else 
      insertOptionAndRelocateBoxes(oboxes[whichOption]);
  }
  else if (options == 2) { // both options
    //println(numberOfRndSongs);
    if (numberOfRndSongs != 1) // if a single song has been randomly selected, don't put shuffle option
      insertOptionAndRelocateBoxes(oboxes[0]);
    insertOptionAndRelocateBoxes(oboxes[1]);
  }
}

void generateRandomSongList() {
  boolean isFirstOccurrence = false;
  int songNumber, count = 0;
  numberOfRndSongs = (int)(random (1, 6));
  int[] rndsongs = new int[numberOfRndSongs];

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
  while (count < numberOfRndSongs);

  for (int r =0; r < rndsongs.length; r++) {
    insertItemAndRelocateBoxes(iboxes[rndsongs[r]]);
  }
}

boolean isExecButtonClicked () {
  if (  mouseX > (width-executeButtonGap) && mouseX < width &&
    mouseY > (height-(fontSizeRef*3)+delta/4 -1) && mouseY < height - fontSizeRef*2 ) {

    giveMeMySentence();

    float time = millis();
    while (millis ()-time < 200) {
    }

    return true;
  }
  else return false;
}

List<String> giveMeMySentence() {
  printSentence();
  return sentence;
}

void printSentence() {
  //print("Sentence: ");
  for (String z : sentence)
    print(z + "  ");
  println();
}

