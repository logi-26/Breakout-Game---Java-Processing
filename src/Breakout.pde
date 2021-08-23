PFont font;                                                                               // Font to be used
int wallWidth = 10;                                                                       // Width of the walls
int gameLevel = 1;                                                                        // Stores the current game level
int arenaTop = 35;                                                                        // Location of arena top rectangle
int gameScore = 0;                                                                        // Game score
boolean gameOver = false;                                                                 // Used to check the game over state
boolean firstLaunch = true;                                                               // Used to check if this is the first time the application has launched
Block[][]  blockArray = new Block[8][13];                                                 // 2D array of blocks
Ball ball;                                                                                // Ball object
Bat bat;                                                                                  // Bat object


void setup() {
  
  size(740, 640);                                                                         // Arena size
  font = loadFont("Calibri-BoldItalic-30.vlw");                                           // Set the font that will be used
  
  // Creates the ball object
  PVector ball_location = new PVector((int) random (width - 50), height - 10);            // Ball location
  float ballMass = 1.0;                                                                   // Ball mass
  ball = new Ball(ball_location, ballMass);                                               // Creates the ball                          
  
  // Creates the bat object
  PVector bat_location = new PVector(0, 0);                                               // Bat location
  bat = new Bat(bat_location);                                                            // Creates the bat
  
  noCursor();                                                                             // Prevents the cursor from bring displayed
}


void draw() {
  
  if (!gameOver) {                                                                         // If the game is running
    background(0);                                                                         // Fill the screen background colour (Black)
    stroke(255);                                                                           // Sets the outline colour for the text (White)
    fill(255);                                                                             // Sets the text colour for the text (White)
    textFont(font, 18);
    text("LEVEL " + gameLevel, 650, 20);                                                   // Draw the level text
    text("SCORE " + gameScore, 350, 20);                                                   // Draw the score text

    float ballYSpeedDisplay = ball.velocity.y;                                             // Gets the balls velocity along the Y axis
    if (ball.velocity.y < 0) ballYSpeedDisplay =- ballYSpeedDisplay;                       // If the number is negative it is made positive for display purposes
    String ballYSpeed = String.format("%.2f", ballYSpeedDisplay);                          // String used to round the current changeY float value to 2 decimal places
    text("Ball Speed  (Y) " + ballYSpeed, 30, 20);                                         // Draw the ball speed text (Always positive number no matter what direction the ball is moving)
    
    float ballXSpeedDisplay = ball.velocity.x;                                             // Gets the balls velocity along the X axis
    if (ball.velocity.x < 0) ballXSpeedDisplay =- ballXSpeedDisplay;                       // If the number is negative it is made positive for display purposes
    String ballXSpeed = String.format("%.2f", ballXSpeedDisplay);                          // String used to round the current changeY float value to 2 decimal places
    text("(X) " + ballXSpeed, 180, 20);                                                    // Draw the ball speed text (Always positive number no matter what direction the ball is moving)
    
    // Draws the game arena 
    stroke(71, 114, 188);                                                                  // Wall outline colour (Blue)
    fill(71, 114, 188);                                                                    // Wall colour (Blue)
    rect(0, 35, wallWidth, height);                                                        // Draw the left wall
    rect(width - wallWidth, 35, width, height);                                            // Draw the right wall
    rect(0, arenaTop, width, wallWidth);                                                   // Draw the arena roof
    
    // Draws the 2D array of blocks
    float blockY = 50;                                                                     // Sets the location Y for the first row of blocks                                          
    for(int i=0; i<8; i++){                                                                // This loops 8 times to create the 8 rows of blocks
      drawBlockRow(blockY, i);                                                             // Calls the draw block function passing in the row number an location Y for the block
      blockY += 15;                                                                        // Increment the blocks location Y for the next row of blocks
    }

    bat.display();                                                                         // Draws the bat 
    ball.display();                                                                        // Draws the ball
    update();                                                                              // Update game
   
  } else {
    drawGameOverScreen();
  }
}
  

// This function updates the game
void update() {
  
  // If this is the first time that the game has launched
  if (firstLaunch) {
    PVector acceleration = new PVector(3, -3);                                             // Sets the balls initial acceleration value
    ball.applyForce(acceleration);                                                         // Applies the nes acceleration value to the ball
    firstLaunch = false;                                                                   // Change boolen to prevent this function being called again
  }
  
  ball.update();                                                                           // Updates the ball
  ball.checkHitSide();                                                                     // Checks if the ball has hit the sides or top
  boolean blockHit = ball.checkHitBlock(blockArray);
  
  if (blockHit) gameScore++;                                                               // If a block has been hit, gamescore is incremented
 
  updateLevel();                                                                           // Updates the level number
  ball.checkHitBat(bat.location, bat.bWidth);                                              // Checks if the ball has hit the sides of the arena
  gameOver = ball.outOfBounds(gameOver);                                                   // Checks if the ball has gone beyond the bottom of the screen
}
  

// Mouse clicked event handler used to start the game
void mouseClicked() {
  
  // If the game is currently not running
  if (gameOver) {
    ball.velocity.y =- ball.velocity.y;                                                    // Change the ball direction so that it is moving up the screen
    gameScore = 0;                                                                         // Reset the game score for the next game
    gameLevel = 1;                                                                         // Reset the game level for the next game
    firstLaunch = true;                                                                    // Reset the first launched boolean for the next game
    resetBlocks();                                                                         // Reset the blocks so that they are all re-drawn in the next game
    gameOver = false;                                                                      // Reset the game over boolean so that the next game will begin
    ball.velocity.x = 0;                                                                   // Reset the balls X and Y velocity value
    ball.velocity.y = 0;
  }
}


// This function updates level number
void updateLevel() {
  
  // The level number is based on the number of blocks destroyed
  if (gameScore < 13) gameLevel = 1;
  else if (gameScore < 26) gameLevel = 2;
  else if (gameScore < 39) gameLevel = 3;
  else if (gameScore < 52) gameLevel = 4;
  else if (gameScore < 65) gameLevel = 5;
  else if (gameScore < 78) gameLevel = 6;
  else if (gameScore < 91) gameLevel = 7;
  else if (gameScore < 104) gameLevel = 8;
}


// This function is used to draw a complete row of blocks
void drawBlockRow(float rowY, int rowNumber) {
  
  color blockColour = color(255, 255, 255);
  
  // This switches the colour of the blocks depending on the row number
  if (rowNumber == 0 || rowNumber == 1) blockColour = color(200, 5, 5);                      // Block colour (Red)
  else if (rowNumber == 2 || rowNumber == 3) blockColour = color(231, 139, 41);              // Block colour (Orange)
  else if (rowNumber == 4 || rowNumber == 5) blockColour = color(51, 149, 24);               // Block colour (Green)
  else if (rowNumber == 6 || rowNumber == 7) blockColour = color(220, 240, 55);              // Block colour (Yellow)
    
  boolean drawBlock = true;
  int blockX = 15;                                                                           // This will be used for the location X of the first block in each row
  
  // Loops 13 times to create and draw all of the blocks in a row
  for(int i=0; i<13; i++){
    
    if (blockArray[rowNumber][i] != null) drawBlock = blockArray[rowNumber][i].visible;      // Get the blocks visible value to determine if it should be drawn
    PVector block_location = new PVector(blockX, rowY);                                      // Set the location for the next block
    blockArray[rowNumber][i] = new Block(rowNumber, drawBlock, block_location, blockColour); // Create the new block
    if (drawBlock) blockArray[rowNumber][i].display();                                       // If the blocks visible value is true, this draws the block

    blockX += 55;                                                                            // Increment the X location for the next block                                                                                              
  }
}


// This function draws the game over screen
void drawGameOverScreen() {
  textFont(font, 40);                                                                        // Sets the font size
  fill(255,0,0);                                                                             // Sets the text colour for the text (Red)
  background(0);                                                                             // Change the background colour when the game has ended
  text("Game Over!  Your Score:  " + gameScore, width /2 - 230, height / 2 - 200);           // Display the game over text and the users final score
  textFont(font, 30);                                                                        // Reduces the font size
  fill(255);                                                                                 // Sets the text colour for the text (White)
  text("Click the mouse to restart!", width /2 - 160, height / 2 - 140);                     // Display the game over text and the users final score
}


// This function resets the visibility for all of the blocks
void resetBlocks() {
  for(int i=0; i<8; i++) for(int j=0; j<13; j++) blockArray[i][j].visible = true;            // Loops through the 2D array of blocks, settings each blocks visible value true
}