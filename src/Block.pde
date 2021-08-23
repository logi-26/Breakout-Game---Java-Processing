
class Block {
  
  PVector location;                                           // Vector for the location of the block
  int row;                                                    // The blocks row number (0-7)
  int bWidth;                                                 // Block width                                                                   
  int bHeight;                                                // Block height    
  color colour;                                               // Block colour 
  boolean visible;                                            // Boolean to determine if the block has been hit by the ball
  
  // Block constructor takes 4 parameters (int, boolean, vector, color)
  Block(int rowNumber, boolean blockVisible, PVector blockLocation, color blockColour) { 
    row = rowNumber;                                            
    visible = blockVisible;                                  
    location = blockLocation;                                  
    colour = blockColour;
    bWidth = 50;                                                                       
    bHeight = 10;  
  }
  
  
  // This function draws the block
  void display() {
    
    stroke(colour);                                                                                                            
    fill(colour);                                                                      
    rect(location.x, location.y, bWidth, bHeight);
  }  
}