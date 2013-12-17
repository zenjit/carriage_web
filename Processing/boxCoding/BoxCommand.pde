class BoxCommand extends Box {

  BoxCommand next = null;
  //boolean available = true;

  /* Constructor */
  BoxCommand(String keyw, float posH, float posV, float fontSizeR) {
    super(keyw, posH, posV, fontSizeR);
  }


  String getKey(BoxCommand c) {
    return c.keyword;
  }
}

