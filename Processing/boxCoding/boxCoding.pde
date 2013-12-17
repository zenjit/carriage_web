/**
 Box-coding
 
 Rafael Redondo Tejedor CC - 12.2013
 Zenjiskan - 12.2013
 */
import java.util.List;

/* General page settings */
int screenWidth = 600, screenHeight = 400;

/* Fonts */
//int[] fontColor = new int[3];
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
int nsongs, i = 0;

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

  /* Creates a few boxes at the corner*/
  for (int w = 0; w < cwords.length; w++) {
    cboxes[w] = new BoxCommand(cwords[w], 0, 0, fontSizeRef);
  }
  
  for (int w = 0; w < iwords.length; w++) {
    iboxes[w] = new BoxItem(iwords[w], 0, 0, fontSizeRef);
    iboxes[w].setUnavailable();
  }

  for (int w = 0; w < owords.length; w++) {
    oboxes[w] = new BoxOption(owords[w], 0, 0, fontSizeRef);
    oboxes[w].setUnavailable();
  }

  /* Rellocate boxes from the corner */
  relocateBoxes();
}

void draw() {
  /* mouse event detected on boxes*/
  if (mousePressed) {
    actionHandler();
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

void actionHandler () {
  /* control boxes */
  for (BoxCommand c: cboxes) {
    if (c.getAvailable() || c.getUsed()) {
      /* mouse event detected on control box */
      if (c.overTheBox()) {
        /* command box to be used */
        if (c.clickedStatus()) {
          if (c.getKey() == "random") { randomSentence(); break; }
          insertCommandBox(c);
          for (BoxCommand d: cboxes) {
            d.setUnavailable();
          }
          for (BoxItem i: iboxes) {
            i.setAvailable();
          }
        }
        /* already used command box */
        else {
          removeCommandBox(c);
          for (BoxCommand d: cboxes) {
            d.setAvailable();
          }
          for (BoxItem i: iboxes) {
            i.setUnavailable();
          }
          for (BoxOption o: oboxes) {
            o.setUnavailable();
          }
        }
        relocateBoxes();
      }
    }
  }
  /* item boxes */
  for (BoxItem i: iboxes) {
    if (i.getAvailable() || i.getUsed()) {
      /* mouse event detected on item box */
      if (i.overTheBox()) {
        /* item box to be used */
        if (i.clickedStatus()) {
          /* if all songs has been selected */
          if (i.getKey() == "all songs") {
            insertItemBox(i);
            for (BoxItem h: iboxes) {
              h.setUnavailable();
            }
            for (BoxOption o: oboxes) {
              o.setAvailable();
            }
          }
          /* ...or a single track */
          else {
            insertItemBox(i);
            nsongs ++;
            println(nsongs);
            i.setUnavailable();
            for (BoxItem h: iboxes) {
              if (h.getKey() == "all songs") {
                h.setUnavailable();
              }
            }
            if (nsongs == 1)
            {
              for (BoxOption o: oboxes) {
                if (o.getKey() == "volume") o.setAvailable();
              }
            }
            else {
              for (BoxOption o: oboxes) {
                o.setAvailable();
              }              
            }
          }
        }
        /* already used item box */
        else {
          String item = i.getKey();
          println (item);
          if (item == "all songs") {
            removeItemBox(i);
            for (BoxItem h: iboxes) {
              h.setAvailable();
            }
            for (BoxOption o: oboxes) {
              o.setUnavailable();
            }
          }
          else {
            removeItemBox(i);
            nsongs--;
            println(nsongs);
            if (nsongs == 0) {
              for (BoxItem h: iboxes) {
                h.setAvailable();
              }
              for (BoxOption o: oboxes) {
                println("here");
                o.setUnavailable();
              }                
            }
            if (nsongs == 1) {
              
            }
            else {
                for (BoxOption o: oboxes) {
                o.setAvailable();
              }      
            }
          }
        }
        relocateBoxes();
      }
    }
  }
  /* option boxes */
  for (BoxOption o: oboxes) {
    if (o.getAvailable() || o.getUsed()) {
      /* mouse event detected on option box */
      if (o.overTheBox()) {
        /* option box to be used */
        if (o.clickedStatus()) {
          insertOptionBox(o);
        } 
        /* already used option box */
        else {
          removeOptionBox(o);
        }
        relocateBoxes();
      }
    }
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

void randomSentence() {
  int unodue = (int)abs(random (0, 2)); // random between play and repeat
  insertCommandBox(cboxes[unodue]);
  relocateBoxes();
  int songs = (int)abs(random (0, 2)); // random between all songs and song list
  if (songs == 1) {
    int nsongs = (int)abs(random (0, 6));
    }
  else {
    insertItemBox(iboxes[0]);
  }
  int options = (int)abs(random (0, 2));
//  for (BoxControl c: cboxes) {
//  }
//  for (BoxItem i: iboxes) {
//  }
//  for (BoxOption o: oboxes) {
//  }
  println(unodue);
}
void insertCommandBox(BoxCommand aBox) {
  aBox.used = true;
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
  aBox.used = true;
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
  aBox.used = true;
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
  aBox.used = false;
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
  aBox.used = false;
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
  aBox.used = false;
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
