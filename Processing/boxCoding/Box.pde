interface Box {

  /* Constructor */
  //Box(String keyw, float posH, float posV, float fontSizeR, int[] frameC, int[] fillC, int[] fontC);

  /* Draws box */
  void drawBoxes();

  /* Changues absolute box location */
  void reallocate(float posH, float posV);

  /* Changes box status and appearance */
  boolean clickedStatus();

  /* Relative box movements */
  void move();
}


//
//class BoxSongs extends Box {
//}
//
//class BoxSongsList extends Box {
//}
