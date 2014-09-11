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
    execStatus = false;
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
      execStatus = false;
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
    if (nSongs == 1) {
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
        if (o.getKey() == shuffleKey) {
          o.setStatus(2);
        }
        else o.setStatus(1);
    } 
    else {
      for (BoxOption o: oboxes)
        if (o.getKey() == shuffleKey && o.getStatus() == 2) {
          o.setStatus(1);
        }
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

boolean hasMoreLines = false;

void relocateBoxes() {
  // Calculating H starting position to be (always) centered
  startingHPosC = 0;
  for (BoxCommand c: cboxes) {
    if (c.getStatus() != 3) {
      startingHPosC += c.boxWidth + boxHorizontalGap;
    }
  }
  posHCounter = (width- startingHPosC + boxHorizontalGap)/2;
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

  // Calculating H starting position to be (always) centered
  startingHPosI = 0;
  for (BoxItem i: iboxes) {
    if (i.getStatus() != 3) {
      startingHPosI += i.boxWidth + boxHorizontalGap;
    }
  }
  posHCounter = (width- startingHPosI + boxHorizontalGap)/2;
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

  // Calculating H starting position to be (always) centered
  startingHPosO = 0;
  for (BoxOption o: oboxes) {
    if (o.getStatus() != 3) {
      startingHPosO += o.boxWidth + boxHorizontalGap;
    }
  }
  posHCounter = (width- startingHPosO + boxHorizontalGap)/2;
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

  /* Starting position for command line phrase*/
  posHCounterSentence = marginLeftRight + promptGap/2;
  if (mobile) {
    posVCounterSentence = height/2 + marginTopC;
  }
  else {
    posVCounterSentence = height - (fontSizeRef * 3) + marginTopC;
  }
  //posHCounterSentence = posHCounterSentence;
  posHPrompt = posHCounterSentence - punctuationGapLR;
  posVClosedParenthesis = posVPrompt = posVCounterSentence;

  BoxCommand bcPointer = bcHead;
  BoxItem biPointer = biHead;
  BoxOption boPointer = boHead;

  sentence = new ArrayList<String>();

  // counters for punctuation marks
  int numCommands = 0;
  int numItems = 0;
  int numOptions = 0;

  // COMMAND LINE COMMANDS RELOCATION AND PUNCTUATION
  while (bcPointer != null) {
    sentence.add(bcPointer.getKey());
    
    //json.setString("command", bcPointer.getKey());
    
    if (posHCounterSentence + bcPointer.boxWidth > width - marginLeftRight - executeButtonGap) {
      posHCounterSentence = marginLeftRight + promptGap;
      posVCounterSentence += bcPointer.boxHeight + boxVerticalGap;
    }
    bcPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += bcPointer.boxWidth + punctuationGapLR;
    numCommands ++;
    bcPointer.openParenthesis = "("; 
    posHClosedParenthesis = posHPrompt = posHCounterSentence;
    posVClosedParenthesis = posVPrompt = posVCounterSentence;
    bcPointer.closedParenthesis = ")";

    bcPointer = bcPointer.next;
  }

  if (numCommands == 0) {
    for (BoxCommand c: cboxes) {
      c.openParenthesis = "";
      c.closedParenthesis = "";
    }
    execStatus = false;
  }

  String first = "";
  String last = "";
  boolean isFirst = true;
  boolean containsAllSongs = false;

  // COMMAND LINE ITEMS RELOCATION AND PUNCTUATION
//  int c=0;
//  JSONArray iValues = new JSONArray();
  
  while (biPointer != null) {
    sentence.add(biPointer.getKey());
    
//    JSONObject iItems = new JSONObject();
//    iItems.setInt("id", c);
//    iItems.setString("value", biPointer.getKey());
//    iValues.setJSONObject(c, iItems);
    
    if (posHCounterSentence + biPointer.boxWidth > width - marginLeftRight - executeButtonGap) {
      posHCounterSentence = marginLeftRight + promptGap/2 + punctuationGapLR/2;
      posVCounterSentence += biPointer.boxHeight + boxVerticalGap;
    }
    // if one or more songs are present
    if (biPointer.getKey() != allsongsKey) {
      numItems ++;
      // only for first song added, increse margin because two interpunc marks will be added '(['
      if (numItems == 1) {
        posHCounterSentence += punctuationGapLR/2;
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
    else {
      containsAllSongs = true;
    }

    biPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += biPointer.boxWidth + boxHorizontalGapCommandLine ;
    biPointer = biPointer.next;
    isFirst = false;
    execStatus = true;
//    c++;
  }
//  json.setJSONArray("items", iValues);

  if (containsAllSongs) {
    posHClosedParenthesis = posHPrompt = posHCounterSentence - punctuationGapLR;
    posVClosedParenthesis = posVPrompt = posVCounterSentence;
  }
  if (numItems == 0) {
    for (BoxItem i: iboxes) {
      i.openBrackets = "";
      i.closedBrackets = "";
      i.comma = "";
    }
  }
  else {
    posHClosedParenthesis = posHPrompt = posHCounterSentence - punctuationGapLR/2;
    posVClosedParenthesis = posVPrompt = posVCounterSentence;
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
      for (BoxItem i: iboxes) {
        if (i.getStatus () == 3) {
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

//  int d=0;
//  JSONArray oValues = new JSONArray();
      
  // COMMAND LINE OPTIONS RELOCATION AND PUNCTUATION
  while (boPointer != null) {
    sentence.add(boPointer.getKey());
//    JSONObject oItems = new JSONObject();
//    oItems.setInt("id", d);
//    oItems.setString("value", boPointer.getKey());
//    oValues.setJSONObject(d, oItems);
    numOptions ++;
    if (posHCounterSentence + boPointer.boxWidth > width - marginLeftRight - executeButtonGap) {
      posHCounterSentence = marginLeftRight + promptGap/2 + punctuationGapLR/2;
      posVCounterSentence += boPointer.boxHeight + boxVerticalGap;
    }

    boPointer.reallocate(posHCounterSentence, posVCounterSentence);
    posHCounterSentence += boPointer.boxWidth + boxHorizontalGapCommandLine;
    boPointer = boPointer.next;
//    json.setJSONArray("options", oValues);
//    d++;
  }

  if (numOptions >= 1) {
    posHClosedParenthesis = posHPrompt = posHCounterSentence - punctuationGapLR;
    posVClosedParenthesis = posVPrompt = posVCounterSentence;
    for (BoxOption o: oboxes)
      o.comma = ",";
  }
  else {
    for (BoxOption o: oboxes)
      o.comma = "";
  }
//  saveJSONObject(json, "data/new.json");
}

