/*
    Algorithm class does the mathmatics for weighted scores derrived from current tags and characters scores.
 */
class Algorithm {

  // Current x & y
  float x,
        y;

  // Data points mapped to 100 x 100 grid
  int[][] cornerPoints = {
      { 100, 0 },
      { 100, 100 },
      { 0, 100 },
      { 0, 0 }
  };

  // Maximum distance on 100 x 100 grid
  float distanceMax = dist( float(cornerPoints[0][0]), float(cornerPoints[0][1]), float(cornerPoints[2][0]), float(cornerPoints[2][1]) );

  // Tag Domain
  float tagMinValue=1;
  float tagMaxValue=12;

  // Score Range
  float scoreMinValue=5800;
  float scoreMaxValue=16000;

  // Radius Range
  float radiusMinValue=10;
  float radiusMaxValue=110;

  // Scale maps
  ScaleMap tagLogMap = new ScaleMap( log(tagMinValue), log(tagMaxValue), 10, 100 );
  ScaleMap radiusLogMap = new ScaleMap( log(scoreMinValue), log(scoreMaxValue), radiusMinValue, radiusMaxValue );

  Algorithm()
  {
  }

  void updatePointer( float _x, float _y )
  {
    x = _x;
    y = _y;
  }
  
  void updatePointerX( float _x )
  {
    x = _x;
  }
  
  void updatePointerY( float _y )
  {
    y = _y;
  }

  float getDistanceFromCorner( int corner )
  {
    return dist(x, y, cornerPoints[corner][0], cornerPoints[corner][1]);
  }

  float getCornerScore( int corner )
  {
    return map(distanceMax - getDistanceFromCorner(corner), 0, distanceMax, 0, 100 );
  }

  float getCharacterScoreMultiplier( int characterScore )
  {
    return (float)tagLogMap.getMappedValueFor( log( characterScore ) );
  }

  float getRadiusFromTotalScore( float totalScore )
  {
    float radius = (float)radiusLogMap.getMappedValueFor( log( totalScore ) );
    
    // Cap min radius size
    if ( radius<circle_radius_min )
    {
      radius = circle_radius_min;
    }
    
    return radius;
  }

}