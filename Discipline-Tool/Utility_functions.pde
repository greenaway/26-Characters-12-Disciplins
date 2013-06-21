/*
    Utility functions
 */

// Array contains value
boolean contains(final int[] array, final int key) {     
  for (int i = 0; i<array.length; i++){
    if (array[i] == key){
      return true;
    }
  }
  return false;
}

// Save screen grab
void saveGrab()
{
  Date dNow = new Date();
  SimpleDateFormat ft = new SimpleDateFormat ("yyyy-MM-dd-mm-ss");
  saveFrame("screen_grabs/" + ft.format(dNow) + ".png");
};
