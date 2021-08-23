
class Ball {

  PVector location, velocity, acceleration;                                                                               // Ball location, velocity and acceleration 
  float mass;                                                                                                             // Mass of the ball
  float size;                                                                                                             // Ball size is related to the ball mass
  float noiseX = 0;                                                                                                       // Used to generate perlin noise
  
  // Ball constructor
  Ball(PVector ballLocation, float ballMass) {
    location = ballLocation;
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    mass = ballMass;
    size = mass*16;
  }
  
  
  // This function applies a force to the ball
  void applyForce(PVector force) {
    
    PVector newForce = PVector.div(force, mass);                                                                           // Divide by mass
    acceleration.add(newForce);                                                                                            // Accumulate all forces in acceleration
  }
  
  
  // This function Updates the ball
  void update() {
    
    velocity.add(acceleration);                                                                                             // Velocity changes according to acceleration
    location.add(velocity);                                                                                                 // Location changes by velocity
    acceleration.mult(0);                                                                                                   // Acceleration must be cleared each frame
    
    noiseX += 0.1;
  }
  
  
  // This function draws the ball
  void display() {
    
    stroke(255);                                                                                                             // Ball outline colour (White)
    fill(255);                                                                                                               // Ball colour (White)
    ellipse(location.x, location.y, size, size);                                                                             // Draws the ball ellipse
  }
  
  
  // This function checks if the ball hit any walls or the roof
  void checkHitSide() {
    
    if (location.x <= 10 || location.x >= width - size) {
      velocity.x =- velocity.x;                                                                                               // If the ball hits a side wall, reverse its direction in the x plane
      applyPerlinNoise();                                                                                                     // Using perlin noise to modify the balls acceleration along the X axis
    }
    
    if (location.y < 60) velocity.y =- velocity.y;                                                                            // If the ball hits the top wall, change its direction in the y plane
  }
  
  
  // This function checks if the ball hits any of the blocks
  boolean checkHitBlock(Block[][] blockArray) {
    
    boolean blockHit = false;
    
    for(int i=0; i<8; i++){                                                                                                        
      for(int j=0; j<13; j++){
        if (location.y < blockArray[i][j].location.y && location.x >= blockArray[i][j].location.x && velocity.y < 0 
        && location.x <= blockArray[i][j].location.x + blockArray[i][j].bWidth && blockArray[i][j].visible) {
          
          blockHit = true;
          velocity.y =- velocity.y;                                                                                            // Reverse the balls direction
          blockArray[i][j].visible = false;                                                                                    // When a block is hit by the ball it is no longer drawn on the screen
          applyForce(new PVector (acceleration.x,acceleration.y + 0.20));                                                      // Increase the balls speed on the Y axis
          applyPerlinNoise();                                                                                                  // Using perlin noise to modify the balls acceleration along the X axis
        }
      }
    }
    return blockHit;
  }
  

  // This function checks if the ball hits the bat
  void checkHitBat(PVector batLocation, int batWidth) {

    // If the ball is at the bottom of the arena
    if (location.y >= batLocation.y) {
      
      // If the ball hits the bat, reverse its direction in the y plane
      if (location.x >= batLocation.x && location.x <= batLocation.x + batWidth) {
        
        velocity.y =- velocity.y;                                                                                              // Swith the balls direction along the Y axis
        location.y = batLocation.y;                                                                                            // Set the balls location Y
        applyPerlinNoise();                                                                                                    // Using perlin noise to modify the balls acceleration along the X axis
  
        if (location.x >= batLocation.x && location.x <= batLocation.x + batWidth/2) velocity.y += 0.3;                        // If the ball hits the left side of the bat, the ball speed is increased
        else if (location.x >= batLocation.x + batWidth/2 && location.x <= batLocation.x + batWidth) velocity.y -= 0.3;        // If the ball hits the right side of the bat, the ball speed is decreased
      } 
    } 
  }
  
  
  // This function uses perlin noise to modify the balls acceleration along the X axis
  void applyPerlinNoise() {
    
    // Using perlin noise to modify the balls acceleration along the X axis
    float pNoise = (0.1 * noise(noiseX));
    applyForce(new PVector (pNoise,acceleration.y));
  }
 
 
  // This function checks if the ball has reached the bottom of the screen
  boolean outOfBounds(boolean gameOver) {
    
    if (location.y >= height) gameOver = true;                                                                                 // If the ball has reached the bottom of the screen the boolean is set true
    return gameOver;                                                                                                           // Returns the boolean
  }
}