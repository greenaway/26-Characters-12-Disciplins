/*
    UI Classes in charge of drawing tags, titles and user feedback
 */
class UI {

  PFont tagFont;
  PFont titleFont;
  color textColor;

  boolean horizontal = true;
  int padding = 26;

  int tagFontSize = 42;
  int titleFontSize = 126;
  int pointerSize = 32;
  int pointerStroke = 6;

  int showPointerFor = 2;
  int pointerX, pointerY;
  float pointerMappedX, pointerMappedY;
  long timePointerLastUpdated;

  UI()
  {
    // UI go!
    //myFont = createFont("Karben105Mono-Book", tagFontSize);
    tagFont = loadFont("Karben105Mono-Book-42.vlw");
    titleFont = loadFont("Karben105Mono-Book-126.vlw");
    textColor = color_light;

    // Set last update time to now
    timePointerLastUpdated = System.currentTimeMillis();
  }

  void renderText( String text, int x, int y, float rotate, int align, int baseline )
  {
      pushMatrix();
      fill(textColor);
      translate(x, y);
      textAlign(align, baseline);
      rotate(rotate);
      text(text, 0, 0);
      popMatrix();
  }

  void drawTitle()
  {
    textFont(titleFont, titleFontSize);
    renderText("26 Characters", width/2, height/2, 0, CENTER, BOTTOM);
  }

  void drawTags() 
  {
    // Draw the UI to the screen from set properties
    textFont(tagFont, tagFontSize);

    // Tag a, b, c & d
    if ( horizontal ){
      renderText( tags[currentTags[0]], width-padding, padding, 0, RIGHT, TOP );
      renderText( tags[currentTags[1]], width-padding, height-padding, 0, RIGHT, BOTTOM );
      renderText( tags[currentTags[2]], padding, height-padding, 0, LEFT, BOTTOM );
      renderText( tags[currentTags[3]], padding, padding, 0, LEFT, TOP );
    } else {
      renderText( tags[currentTags[0]], width-padding, padding, HALF_PI, LEFT, TOP );
      renderText( tags[currentTags[1]], width-padding, height-padding, HALF_PI, RIGHT, TOP );
      renderText( tags[currentTags[2]], padding, height-padding, -HALF_PI, LEFT, TOP );
      renderText( tags[currentTags[3]], padding, padding, -HALF_PI, RIGHT, TOP );
    }

  }

  void stepTag( int instanceIndex )
  {
    boolean isSet = false;
    int newTagIndex = currentTags[instanceIndex] + 1;

    // Tag must not be one already used
    while (!isSet){
      if ( contains(currentTags, newTagIndex) ) {
        newTagIndex++;
      } else if ( newTagIndex == tags.length ){
        newTagIndex = 0;
      } else {
        isSet = true;
      }
    }
    currentTags[instanceIndex] = newTagIndex;
  }


  void setPointer( int _x, int _y )
  {
    // Update timer
    timePointerLastUpdated = System.currentTimeMillis();

    // Set x & y
    pointerX = _x;
    pointerY = _y;
    pointerMappedX = map( pointerX, 0, 100, 0, width );
    pointerMappedY = map( pointerY, 0, 100, 0, height );
  }
  
  void setPointerX( int _x ) 
  {
    // Update timer
    timePointerLastUpdated = System.currentTimeMillis();

    // Set x
    pointerX = _x;
    pointerMappedX = map( pointerX, 0, 100, 0, width );
  }
  
  void setPointerY( int _y )
  {
    // Update timer
    timePointerLastUpdated = System.currentTimeMillis();

    // Set y
    pointerY = _y;
    pointerMappedY = map( pointerY, 0, 100, 0, height );
  }

  void drawPointer()
  {
    long timeNow = System.currentTimeMillis();

    if(timeNow < (timePointerLastUpdated + showPointerFor*1000))
    { 
      fill( color_dark );
      stroke( color_light );
      strokeWeight( pointerStroke );
      ellipseMode( CENTER );
      ellipse( pointerMappedX, pointerMappedY, pointerSize, pointerSize );
    } 
  }
}