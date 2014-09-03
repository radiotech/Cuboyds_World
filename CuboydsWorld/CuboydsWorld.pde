/* @pjs preload="cuboyd.png"; */


//Run in Fullscreen
boolean sketchFullScreen() {
  return false;
}


//Constant Variables
int csize = 50; //Modifyable
int ssize = csize * 20; //Modifyable
int ssize2 = csize * 15;
float scale = ssize/float(1000);
//float scale = //(csize*20)/1000;
int bsize = csize;
boolean facing = false;

float cspeed = .1;
float squish = 0;


//Varying Variables
int[][] blocks = new int[20][15];

int[] blockDefs = new int[20];

//Cuboyd Posistion
float cx = ssize/10-csize;
float cy = ssize2-csize*2;

//Cuboyd Velocity
boolean pvcx = false;
boolean nvcx = false;

boolean jumping = false;

float vcy = 0;
//Image Declaration
PImage cuboydImage;
PImage[] blockImages = new PImage[20];

//Occurs once at beginning of game
void setup() {
  size(ssize, ssize2); //this needs to be on the first line of setup
  //Loading Image Facing the Right


  for  (int i = 0; i<20; i++) {
    blockDefs[i] = floor(random(3));
  }

  cuboydImage = loadImage("minecraft.png");
  
  for(int i = 1; i < 20; i++){
    blockImages[i] = loadImage("block"+i+".png");
  }
  
  blockDefs[0] = 0;
  blockDefs[1] = 1;
  blockDefs[19] = 2;


  //Block Creation  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<14; j++) {
      blocks[i][j] = floor(random(20));
    }
  }
  //Box Around
  for (int i = 0; i<20; i++) {
    blocks[i][0] = 1;
    blocks[i][14] = 1;
  }
  for (int i = 0; i<15; i++) {
    blocks[0][i] = 1;
    blocks[19][i] = 1;
  }
  blocks[1][13] = 0;
}



//Obtain user input
void keyPressed() {
  if (keyCode == UP) {
    jumping = true;
  }
  if (keyCode == LEFT) {
    nvcx = true;
    facing = true;
  }
  if (keyCode == RIGHT) {
    pvcx = true;
    facing = false;
  }
  if (key == 'r') {
    setup();
  }
}

//Obtain user input
void keyReleased() {
  if (keyCode == UP) {
    jumping = false;
  }
  if (keyCode == LEFT) {
    nvcx = false;
    if (pvcx) {
      facing = false;
    }
  }
  if (keyCode == RIGHT) {
    pvcx = false;
    if (nvcx) {
      facing = true;
    }
  }
} 


//Occurs a bunch of times every second
void draw() {
  background(200);
  
  
  for(int i = 0; i < 100; i++){
    for(int j = 0; j < 100; j++){
      image(blockImages[floor(random(19))+1],i*ssize/100,j*ssize2/100, ssize/100, ssize/100);//, floor(random(800)),floor(random(800)),100,100);
    }
  }
  


  //updating the game world

  vcy += .5;

  text(scale, csize*3, csize*3);


  if (jumping) {
    if (blockDefs[blocks[floor(cx/csize)][round(cy/csize+.5)]]!=0) {
      vcy = -12;
    }


    if (round(cx/csize)*csize != round(cx)) {
      if (blockDefs[blocks[floor(cx/csize)+1][round(cy/csize+.5)]]!=0) {
        vcy = -12;
      }
    }
  }

  if (pvcx) {
    cx += csize*cspeed;
    movementGrid();
  }
  if (nvcx) {
    cx -= csize*cspeed;
    movementGrid();
  }

  cy += vcy*scale;

  if (cy > ssize2-csize) {
    cy = ssize2-csize;
    if (vcy > 0) {
      vcy = 0;
    }
  }



  int tempx = 0;
  int tempy = 0;

  if (round(cx/csize)*csize>cx) {
    tempx = -1;
  } else if (round(cx/csize)*csize<cx) {
    tempx = 1;
  }

  if (round(cy/csize)*csize>cy) {
    tempy = -1;
  } else if (round(cy/csize)*csize<cy) {
    tempy = 1;
  }

  collide(cx+csize*tempx, cy);
  collide(cx, cy+csize*tempy);

  collide(cx+csize*tempx, cy+csize*tempy);

  collide(cx, cy);

  //Cuboyd Modifications

  //Drawing the world
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blockDefs[blocks[i][j]] > 0) {
        image(blockImages[blocks[i][j]],i*bsize, j*bsize, bsize, bsize);
        
        if (blockDefs[blocks[i][j]] == 1) {
          noStroke();
          fill(255, 0, 0);
          rect(i*bsize+10, j*bsize+10, bsize-20, bsize-20);
        }
      }
    }
  }
  //Image Version
  squish = (squish*3+(vcy*2))/4;
  if (abs(squish)>csize/3) {
    squish = (abs(squish)/squish) * (csize/3);
  }
  
  fill(255);
  noStroke();
  image(cuboydImage, cx+squish/2, cy-squish, csize-squish, csize+squish);
  if(facing){
    rect(cx+5/float(32)*csize,cy+6/float(32)*csize,4/float(32)*csize,7/float(32)*csize);
    rect(cx+19/float(32)*csize,cy+6/float(32)*csize,4/float(32)*csize,7/float(32)*csize);
  } else {
    rect(cx+9/float(32)*csize,cy+6/float(32)*csize,4/float(32)*csize,7/float(32)*csize);
    rect(cx+23/float(32)*csize,cy+6/float(32)*csize,4/float(32)*csize,7/float(32)*csize);
  }
  
  
  
  
  text(round(frameRate),ssize-csize/3*2,csize/2);
}



boolean collide(float oxpos, float oypos) {
  int xpos = round(oxpos/csize);
  int ypos = round(oypos/csize);

  if (xpos >= 0 && xpos <= 19 && ypos >= 0 && ypos <= 14) {
    fill(255);
    if (blockDefs[blocks[xpos][ypos]] == 1) {
      fill(0);

      int tempxdis = abs(round(cx)-xpos*csize);
      int tempydis = abs(round(cy)-ypos*csize);

      if (tempxdis+5 > tempydis) {
        if (cx>xpos*csize) {
          cx = xpos*csize+csize;
        } else {
          cx = xpos*csize-csize;
        }
      } else {
        if (cy>ypos*csize) {
          cy = ypos*csize+csize;
        } else {
          cy = ypos*csize-csize;
        }
        vcy = 0;
      }
    }
  }


  //rect(xpos * csize, ypos * csize, csize, csize);



  return true;
}

boolean movementGrid() {
  cx = round(cx/(csize*cspeed))*(csize*cspeed);
  return true;
}

