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
int bsize = csize;
boolean facing = false;
int level = 1;
int room = 1;

//Animation[] animation = new Animation[0];
ArrayList<Animation> animations = new ArrayList<Animation>();

float cspeed = .1;
float squish = 0;

String[] loadData;
String[] splitData;
String[] blockDefs;
String[] blockName;
String[] blockFile;
PImage[] blockImages;
String[][] blockTags;

//Varying Variables
int[][] blocks = new int[20][15];
int[][] blockUpdates = new int[20][15];

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


//Occurs once at beginning of game
void setup() {
  size(ssize, ssize2); //this needs to be on the first line of setup
  //Loading Image Facing the Right
  
  reload();
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
    reload();
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
  
  //for(int i = 0; i < animation.length; i++){
  //  animation[i].update();
  //}
  for (int i = animations.size()-1; i >= 0; i--) {
    Animation animation = animations.get(i);
    if (animation.update() != true) {
      animations.remove(i);
    }
  }
  
  /*
  for(int i = 0; i < 100; i++){
    for(int j = 0; j < 100; j++){
      image(blockImages[floor(random(19))+1],i*ssize/100,j*ssize2/100, ssize/100, ssize/100);//, floor(random(800)),floor(random(800)),100,100);
    }
  }
  */
  


  //updating the game world

  vcy += .5;

  //text(scale, csize*3, csize*3);


  if (jumping) {
    if (hasTag(blocks[floor(cx/csize)][round(cy/csize+.5)],"Solid")) {
      vcy = -11;
    }

    if (round(cx/csize)*csize != round(cx)) {
      if (hasTag(blocks[floor(cx/csize)+1][round(cy/csize+.5)],"Solid")) {
        vcy = -11;
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

  blockUpdates();
  collisions();
  touches();  

  //Cuboyd Modifications

  //Drawing the world
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blocks[i][j] >= 0) {
        
        if(hasTag(blocks[i][j],"Invisible")){
          
          tint(255, min(255-(abs(i*csize-cx)-csize)/csize*255,255-(abs(j*csize-cy)-csize)/(csize*2)*255));
          image(blockImages[blocks[i][j]],i*bsize, j*bsize, bsize, bsize);
          tint(255,255);
          
        } else {
          image(blockImages[blocks[i][j]],i*bsize, j*bsize, bsize, bsize);
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
    rect(cx+csize/2-12/float(32)*(csize-squish),cy+csize-24/float(32)*(csize+squish),4/float(32)*(csize-squish),7/float(32)*(csize+squish));
    rect(cx+csize/2+4/float(32)*(csize-squish),cy+csize-24/float(32)*(csize+squish),4/float(32)*(csize-squish),7/float(32)*(csize+squish));
  } else {
    rect(cx+csize/2-8/float(32)*(csize-squish),cy+csize-24/float(32)*(csize+squish),4/float(32)*(csize-squish),7/float(32)*(csize+squish));
    rect(cx+csize/2+8/float(32)*(csize-squish),cy+csize-24/float(32)*(csize+squish),4/float(32)*(csize-squish),7/float(32)*(csize+squish));
  }
  
  
  
  
  text(round(frameRate)+" FPS",ssize-csize,csize/2);
  text(animations.size()+" Animations",ssize-csize*4,csize/2);
}


boolean blockUpdates(){
  
  int flowSpeed = 1000;
  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blocks[i][j] >= 0) {
        
        if(hasTag(blocks[i][j],"Flow")){
          if(blockUpdates[i][j] == -1){
            if(hasTag(blocks[i][j],"Fast")){
              flowSpeed = 15;
            }
            if(hasTag(blocks[i][j],"Medium")){
              flowSpeed = 30;
            }
            if(hasTag(blocks[i][j],"Slow")){
              flowSpeed = 60;
            }
            
            if(blocks[min(i+1,19)][j] < 0 || hasTag(blocks[min(i+1,19)][j],"Weak")){
                blockUpdates[i][j] = 1;
                animations.add(new Animation("WaterFlow", blocks[i][j], flowSpeed, i, j, min(i+1,19), j));
            }
            if(blocks[max(i-1,0)][j] < 0 || hasTag(blocks[max(i-1,0)][j],"Weak")){
              blockUpdates[i][j] = 1;
              animations.add(new Animation("WaterFlow", blocks[i][j], flowSpeed, i, j, max(i-1,0), j));
            }
            if(blocks[i][min(j+1,14)] < 0 || hasTag(blocks[i][min(j+1,14)],"Weak")){
              blockUpdates[i][j] = 1;
              animations.add(new Animation("WaterFlow", blocks[i][j], flowSpeed/2, i, j, i, min(j+1,14)));
            }
          
          }
        }
        
        
        
      }
    }
  }
  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blockUpdates[i][j] >= 0) {
        //blocks[i][j] = blockUpdates[i][j];
      }
    }
  }
  
  return true;
}




boolean collide(float oxpos, float oypos) {
  int xpos = round(oxpos/csize);
  int ypos = round(oypos/csize);

  if (xpos >= 0 && xpos <= 19 && ypos >= 0 && ypos <= 14) {
    fill(255);
    if (hasTag(blocks[xpos][ypos],"Solid")) {
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

boolean touches(){
  
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
  
  touch(cx+csize*tempx, cy);
  touch(cx, cy+csize*tempy);
  touch(cx+csize*tempx, cy+csize*tempy);
  touch(cx, cy);
  return true;
  
}

boolean touch(float oxpos, float oypos) {
  int xpos = round(oxpos/csize);
  int ypos = round(oypos/csize);

  if (xpos >= 0 && xpos <= 19 && ypos >= 0 && ypos <= 14) {
    
    if (hasTag(blocks[xpos][ypos],"Climb")) {
      if(jumping){
        vcy = -3;
      } else {
        vcy = 3;
      }
    }
    
    if (hasTag(blocks[xpos][ypos],"Swim")) {
      if(jumping){
        vcy -= .5;
      } else {
        vcy += .5;
      }
      if(abs(vcy)>5){
        vcy = vcy/abs(vcy)*5;
      }
    }
    
    if (hasTag(blocks[xpos][ypos],"Bouncy")) {
      
      vcy = -15;
      
    }
    
    if (hasTag(blocks[xpos][ypos],"Kill")) {
      
      reload();
      
    }
    
  }


  //rect(xpos * csize, ypos * csize, csize, csize);

  return true;
}

boolean movementGrid() {
  cx = round(cx/(csize*cspeed))*(csize*cspeed);
  return true;
}

boolean loadLevel(){
  
  //blockDefs[0] = "W";
  //blockDefs[1] = "D";
  
  loadData = loadStrings("level"+level+"/room"+room+".txt");
  
  String tempStr;
  blocks = new int[20][15];
  
  for (int i = 0; i < 15; i++) {
    
    splitData = split(loadData[i],',');
    
    for (int j = 0; j < 20; j++) {
      
      tempStr = splitData[j];
      if(" ".equals(tempStr.charAt(1)+"")){
        tempStr = tempStr.charAt(0)+"";
      }
      blocks[j][i] = index(tempStr);
      
    }
  }
  
  return true;
}

boolean loadBlocks(){
  loadData = loadStrings("blockInfo.txt");
  blockDefs = new String[loadData.length-3];
  blockName = new String[loadData.length-3];
  blockFile = new String[loadData.length-3];
  blockImages = new PImage[loadData.length-3];
  blockTags = new String[loadData.length-3][10];

  for(int i = 3; i < loadData.length; i++){
    splitData = split(loadData[i],',');
    
    for(int j = 3; j < splitData.length; j++){
      blockTags[i-3][j-3] = splitData[j];
    }
    
    blockDefs[i-3] = splitData[0];
    blockName[i-3] = splitData[1];
    if(hasTag(i-3,"LevelSpecific")){
      blockImages[i-3] = loadImage("level"+level+"/blocks/"+splitData[2]);
    } else {
      blockImages[i-3] = loadImage("blocks/"+splitData[2]);
    }
    
  
  }
    
  return true;
}

String index(int valueInt){
  if(blockDefs.length > valueInt){
    return blockDefs[valueInt];
  } else {
    return "-1";
  }
}

int index(String valueStr){
  
  valueStr = valueStr.toUpperCase();
  for(int i = 0; i < blockDefs.length; i++){
    if(valueStr.equals(blockDefs[i])){
      return i;
    }
  }
  return -1;
  
}

boolean hasTag(int tempBlock, String tempStr){
  if(tempBlock >= 0){
    for(int i = 0; i < 10; i++){
      if(tempStr.equals(blockTags[tempBlock][i])){
        return true;
      }
    }
  }
  return false;
}

boolean reload(){
  
  
  
  
  cx = ssize/10-csize;
  cy = ssize2-csize*2;
  
  loadBlocks();
  loadLevel();
  
  for (int i = animations.size()-1; i >= 0; i--) {
    animations.remove(i);
  }
  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      blockUpdates[i][j] = -1;
    }
  }
  

  cuboydImage = loadImage("cuboyd.png");
  
  


  //Block Creation  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<14; j++) {
      //blocks[i][j] = floor(random(20));
    }
  }
  //Box Around
  for (int i = 0; i<20; i++) {
    //blocks[i][0] = 1;
    //blocks[i][14] = 1;
  }
  for (int i = 0; i<15; i++) {
    //blocks[0][i] = 1;
    //blocks[19][i] = 1;
  }
  
  return true;
}


class Animation{
  String type;
  int blockType;
  int originX;
  int originY;
  int destinationX;
  int destinationY;
  
  PGraphics pg = createGraphics(csize, csize);
  PGraphics pg2;
  PImage blockImage;
  int fade = 0;
  int shiftX = 0;
  int shiftY = 0;
  float time = 1000;
  boolean direction = true;
  
  //Animation constructor for flowing
  Animation( String aType, int aBlockType, float aTime, int aOriginX, int aOriginY, int aDestinationX, int aDestinationY){
    type = aType;
    blockType = aBlockType;
    time = aTime;
    originX = aOriginX;
    originY = aOriginY;
    destinationX = aDestinationX;
    destinationY = aDestinationY;
    
    blockImage = createImage(csize,csize, ARGB);
    blockImage.copy(blockImages[blockType], 0, 0, blockImages[blockType].width,blockImages[blockType].height, 0, 0, csize, csize);
    
    if(destinationX>originX){
      shiftX = 1;
    } else if(destinationX<originX) {
      shiftX = -1;
    }
    if(destinationY>originY){
      shiftY = 1;
    } else if(destinationY<originY) {
      shiftY = -1;
    }
    
    if(destinationX==originX){
      direction = false;
    }
    
  }
  
  boolean update(){
    
    pg.beginDraw();
    
    pg.ellipseMode(CENTER);
    pg.rectMode(CENTER);
    
    pg.background(0);
    
    pg.fill(255);
    pg.noStroke();
    if(direction){
      pg.ellipse(abs(shiftX-1)/2*csize,csize/2,fade/time*csize*2,csize);
      pg.rect(abs(shiftX-1)/2*csize,csize/2,pow((fade-time/2)/(time/2),.5)*csize*2,csize,(1-fade/time)*csize);
    } else {
      pg.ellipse(csize/2,abs(shiftY-1)/2*csize,csize,fade/time*csize*2);
      pg.rect(csize/2,abs(shiftY-1)/2*csize,csize,pow((fade-time/2)/(time/2),.5)*csize*2,(1-fade/time)*csize);
    }
    pg.endDraw();

    blockImage.mask(pg);
    
    image(blockImage,(originX+shiftX)*csize,(originY+shiftY)*csize,csize,csize);
    //image(pg,4*csize,4*csize);
    
    
    if(fade >= time){
      if(blocks[destinationX][destinationY] < 0 || hasTag(blocks[destinationX][destinationY],"Weak")){
        blocks[destinationX][destinationY] = blockType;
      }
      //remove
      return false;
    } else {
      fade += 1;
    }
    
    return true;
  }
}

/*
boolean addAnimation( String aType, int aBlockType, float aTime, int aOriginX, int aOriginY, int aDestinationX, int aDestinationY){
  Animation[] tempAnimation = animation;
  animation = new Animation[tempAnimation.length+1];
  for(int i = 0; i < tempAnimation.length; i++){
    animation[i] = tempAnimation[i];
  }
  animation[tempAnimation.length] = new Animation(aType,aBlockType,aTime,aOriginX,aOriginY,aDestinationX,aDestinationY);
  
  return true;
}

boolean removeAnimation( int index){
  Animation[] tempAnimation = animation;
  animation = new Animation[tempAnimation.length-1];
  int pointer = 0;
  for(int i = 0; i < animation.length; i++){
    if(index > i){
      pointer = 1;
    }
    animation[i] = tempAnimation[i+pointer];
  }
  
  return true;
}
*/
