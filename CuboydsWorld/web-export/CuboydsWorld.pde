


//Run in Fullscreen
//boolean sketchFullScreen() {
//  return true;
//}


//Constant Variables
int csize = 49; //Modifyable
int ssize = csize * 20; //Modifyable
int ssize2 = csize * 15;
//float scale = ssize/1000;
float scale = 1;//(csize*20)/1000;
int bsize = csize;
boolean cleft = false;
boolean cright = false;
boolean cleft2 = false;
boolean cright2 = false;
boolean cstill = true;


//Varying Variables
int[][] blocks = new int[20][15];

int[] blockDefs = new int[20];

//Cuboyd Posistion
float cx = ssize/10-csize;
float cy = ssize2-csize*2;

//Cuboyd Velocity
boolean pvcx = false;
boolean nvcx = false;
float vcy = 0;
//Image Declaration



//Occurs once at beginning of game
void setup() {
  //Screen Size
  //size(ssize, ssize2);
  //Loading Image Facing the Right


  for  (int i = 0; i<20; i++) {
    blockDefs[i] = floor(random(3));
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
}



//Obtain user input
void keyPressed() {
  if (keyCode == UP) {
    if (blockDefs[blocks[floor(cx/csize)][round(cy/csize+.5)]]!=0) {
      vcy = -20;
    }
    
    
    if(round(cx/csize)*csize != round(cx)){
      if (blockDefs[blocks[floor(cx/csize)+1][round(cy/csize+.5)]]!=0) {
        vcy = -20;
      }
    }
    
    cstill = false;
    cright = true;
  }
  if (keyCode == LEFT) {
    nvcx = true;
    cleft = true;
    cleft2 = false;
    cstill = false;
  }
  if (keyCode == RIGHT) {
    pvcx = true;
    cright = true;
    cright2 = false;
    cstill = false;
  }
  if (key == 'R') {
    
  }
}

//Obtain user input
void keyReleased() {
  if (keyCode == LEFT) {
    nvcx = false;
    cleft = false;
    cright2 = true;
    cstill = false;
  }
  if (keyCode == RIGHT) {
    pvcx = false;
    cright = false;
    cleft2 = true;
    cstill = false;
  }
} 


//Occurs a bunch of times every second
void draw() {
  background(200);

  //updating the game world

  vcy += 1;

  text(scale, csize*3, csize*3);

  if (pvcx) {
    cx += 5*scale;
  }
  if (nvcx) {
    cx -= 5*scale;
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

  //if(tempx > cx){rect(tempx-csize,tempy,csize,csize);}
  //if(tempx < cx){rect(tempx+csize,tempy,csize,csize);}

  //if(tempy > cy){rect(tempx,tempy-csize,csize,csize);}
  //if(tempy < cy){rect(tempx,tempy+csize,csize,csize);}





  //Cuboyd Modifications

  //Drawing the world
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blockDefs[blocks[i][j]] > 0) {
        noStroke();
        fill(255-(blocks[i][j]*10),255,255);
        rect(i*bsize, j*bsize, bsize, bsize);
        if (blockDefs[blocks[i][j]] == 1) {
          noStroke();
          fill(255,0,0);
          rect(i*bsize+10, j*bsize+10, bsize-20, bsize-20);
          
        }
      }
    }
  }
  //Rectangle Version
  stroke(0);
  fill(157, 79, 0);
  rect(cx, cy, csize, csize);
  
  noFill();
  stroke(0);
  rect((floor(cx/csize))*csize,(round(cy/csize+.5))*csize,csize,csize);
  if(round(cx/csize)*csize != round(cx)){
    rect((floor(cx/csize)+1)*csize,(round(cy/csize+.5))*csize,csize,csize);
  }
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

      if (tempxdis > tempydis) {
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


  rect(xpos * csize, ypos * csize, csize, csize);



  return true;
}



void draw() {
  background(0,255,0);
}


