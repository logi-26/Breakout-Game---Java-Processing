
class Bat {

  PVector location;                                                 // Bat location
  int bWidth;                                                       // Bat width                                                               
  int bHeight;                                                      // Bat height

  // Bat constructor
  Bat(PVector batLocation) {
    location = batLocation;
    bWidth = 50;                                                                       
    bHeight = 10; 
  }
                        
                                  
  // This function draws the block
  void display() {
    
    stroke(201, 21, 190);                                           // Bat outline colour (Purple)
    fill(201, 21, 190);                                             // Bat colour (Purple)
    if (mouseX < 680 && mouseX > 10) location.x = mouseX;           // Bat X position is equal to the mouse X position                                                              
    else if (mouseX >= 680) location.x = 680;                       // Bat X position equals 680 (Right edge of arena)
    else if (mouseX <= 10) location.x = 10;                         // Bat X position equals 10 (Left edge of arena)
    location.y = height - 10;                                       // Bat Y position at the bottom of the screen
    rect(location.x, location.y, bWidth, bHeight);                  // Draws the bat 
  }  
}