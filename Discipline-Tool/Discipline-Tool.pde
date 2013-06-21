/*
    26 Characters, 12 Disciplins
    
    Interactive experience which reveals each characters' design specialities. 
    Created for 26 Characters (@26chars) as part of The Degree Show (@thedegreeshow) by James Greenaway (@jvgreenaway)

    Controls:
    - Mouse position calculates weighted score relative to corner tags
    - Mouse clicking in each corner steps tags
    - Touch OSC Midi Controller interface is included
 */

import java.util.*;
import java.text.*;

import toxi.math.*;
import de.looksgood.ani.*;
import themidibus.*; 

// Settings
int screen_width = 1280,
    screen_height = 800;

float circle_radius_min = 10,
      circle_radius_max = 200,
      circle_show_name_radius = 80; 

color color_dark = color( 0, 0, 255 ),
      color_light = color( 255, 255, 255 );

// World
CirclePacking cp;
UI ui;
Algorithm al;
MidiBus midiBus;

long timePast;
PFont nameFont;
int[] currentTags = { 0, 7, 9, 1 };


void setup()
{
  size(screen_width, screen_height);
  frameRate(30);
  smooth(8);
  
  // Init
  Ani.init(this);
  MidiBus.list();
  midiBus = new MidiBus(this, 0, 0);

  // Setup World
  cp = new CirclePacking(width, height);
  ui = new UI();
  al = new Algorithm();

  // Create all the circles for each character( index, fullname, x_pos, y_pos, radius, score_data )
  for (int i=0; i<characters.length; i++)
  {
    cp.circles.add( new Circle( i+1, characters[i], random(width), random(height), circle_radius_min, characterScores[i]) );
  }

  // Character name font
  // nameFont = createFont("Karben105Mono-Bold", 32);
  nameFont = loadFont("Karben105Mono-Bold-32.vlw");

  // Start ui last update timer
  timePast = System.currentTimeMillis();

  // Pointer start position
  int x = 50, y = 50;
  al.updatePointer( x, y );
  ui.setPointer( x, y );
}

void draw()
{
  background( color_dark );
  
  // Loop over all Characters
  for (int i=0; i<characters.length; i++)
  {
    float totalCurrentScore = 0;
    Circle c = (Circle) cp.circles.get(i);

    // Loop over all tags on display
    for (int j = 0; j<currentTags.length; j++)
    {
      // Calculate coner and charcters multipliers
      float characterScoreMultiplier = al.getCharacterScoreMultiplier( c.scores[currentTags[j]] );      
      float cornerScoreMultiplyer = al.getCornerScore(j);

      // Multiply and add onto current score
      totalCurrentScore += characterScoreMultiplier * cornerScoreMultiplyer;
    }

    // Animate to new radius
    float newRadius = al.getRadiusFromTotalScore( totalCurrentScore );
    Ani.to( c, 0.5, "r", newRadius );

    // Show name if score is high enough
    if ( newRadius > circle_show_name_radius ){
      c.showName = true;
    } 
    else {
      c.showName = false;
    }
  }

  // Update circle packing
  cp.pack();

  // Draw sequence
  ui.drawTitle();
  cp.draw();
  ui.drawTags();
  ui.drawPointer();
}

void keyPressed()
{
  if (key == ' ') {
    saveGrab();
  }
}

void mouseReleased()
{
  // Step each corner
  if ( mouseX > width/2 && mouseY < height/2 ) {
    ui.stepTag( 0 );
  }
  else if (mouseX > width/2 && mouseY > height/2) {
    ui.stepTag( 1 );
  }
  else if (mouseX < width/2 && mouseY > height/2) {
    ui.stepTag( 2 );
  }
  else if (mouseX < width/2 && mouseY < height/2) {
    ui.stepTag( 3 );
  }
}

void mouseMoved()
{
  int _x = int(map( mouseX, 0, width, 0, 100 ));
  int _y = int(map( mouseY, 0, height, 0, 100 ));

  // Update al the Algorithm 
  al.updatePointer( _x, _y );

  // Update the pointer UI
  ui.setPointer( _x, _y );
}

void controllerChange(int channel, int number, int value)
{
  if ( channel == 0 && value == 0 ){
    // Push buttons
    // Step tags
    switch ( number ){
      case 0 :
        println("Pressed A");
        ui.stepTag( 0 );
        break;
      
      case 1 :
        println("Pressed B");
        ui.stepTag( 1 );
        break;
      
      case 2 :
        println("Pressed C");
        ui.stepTag( 2 );
        break;
      
      case 3 :
        println("Pressed D");
        ui.stepTag( 3 );
        break;
    }

  } else if ( channel == 1 ) {
    // X,Y controller 
    // Update al the Algorithm and Set pointer for ui
    if ( number == 1 ) {
      // X
      al.updatePointerX( value );
      ui.setPointerX( value );
    } else {
      // Y
      al.updatePointerY( value );
      ui.setPointerY( value );
    }
  }

}

