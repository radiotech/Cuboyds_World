/* @pjs preload="cuboyd.png"; */

//Run in Fullscreen
//boolean sketchFullScreen() {
//  return true;
//}

boolean paused = false;




//Constant Variables
int csize = 50; //Modifyable
int ssize = csize * 20; //Modifyable
int ssize2 = csize * 15;
float scale = ssize/float(1000);
int bsize = csize;
boolean facing = false;
int world = 1;
int level = 1;

//Animation[] animation = new Animation[0];
ArrayList<Animation> animations = new ArrayList<Animation>();

float cspeed = 1/float(8);
float squish = 0;
boolean editor;
boolean blockSelection;
int selectedBlock = 0;
int selectedBlock2 = -1;
boolean showInvisible;



String[] loadData;
String[] splitData;
String[] blockDefs;
String[] blockName;
String[] blockFileName;
String[] blockFile;
PImage[] blockImages;
String[][] blockTags;

//Varying Variables
int[][] blocks;
int[][] saveBlocks;
String[][] animationNotes;

//Cuboyd Posistion
float cx;
float cy;
float lastX;
float lastY;

int sling;

//Cuboyd Velocity
boolean pvcx;
boolean nvcx;
boolean jumping;
boolean muddy;
boolean noJump;

float vcy;
int lastUpdate;
int fps;
int fts;
boolean dead;

int cannonTrigger;

float gravity;

//Image Declaration
PImage cuboydImage;
PImage muddyImage;



//Occurs once at beginning of game
void setup() {
  size(ssize, ssize2); //this needs to be on the first line of setup
  reload();
}

void draw() {
  
  
  //updating the game world
  
  if(mousePressed){
    if(editor){
      if(blockSelection == false){
        if(mouseButton == LEFT){
          setBlock(floor(mouseX/csize),floor(mouseY/csize),selectedBlock,true);
        } else if(mouseButton == RIGHT){
          setBlock(floor(mouseX/csize),floor(mouseY/csize),selectedBlock2,true);
        }
      }
    }
  }
  
  if(lastUpdate != millis()/(1000/30) % 30){
    
    if(dead){
      reload();
    }
    
    if(paused == false){
      move();
    
      blockUpdates();
      collisions();
      touches();
    }
    
    //Cuboyd Modifications

    //Drawing the world
    renderWorld();
    
    fts += 1;
    if(lastUpdate > millis()/(1000/30) % 30){
      fps = fts;
      fts = 0;
    }
    lastUpdate = millis()/(1000/30) % 30;
  }
  
  
}

class Animation{
  //Multi-type Variables
  String type;
  int blockType;
  int originX;
  int originY;
  int fade = 0;
  float time = 1000;
  //Flow Variables
  int destinationX;
  int destinationY;
  PGraphics pg = createGraphics(csize, csize);
  PImage blockImage;
  int shiftX = 0;
  int shiftY = 0;
  boolean direction = true;
  boolean forward = true;
  
  //Crumble Variables
  int[][] cracking = new int[25][3];
  int cracks;
  
  //Fall Variables
  float fallY = 0;
  float fallV = 0;
  float oscillation;
  
  //Cannon Variables
  int dir;
  int speed;
  boolean flipX = false;
  boolean flipY = false;
  
  
  Animation( String aType, float aTime, int aOriginX, int aOriginY, int aDestinationX, int aDestinationY){
    type = aType;
    if(type.equals("Flow")){
      //animations.add(new Animation("Flow", flowSpeed, originX, originY, destinationX, destinationY));
      setupFlow( aTime, aOriginX, aOriginY, aDestinationX, aDestinationY);
    }
  }
  
  
  
  Animation( String aType, float aTime, int aOriginX, int aOriginY){
    type = aType;
    if(type.equals("Crumble")){
      //animations.add(new Animation("Crumble", time, originX, originY));
      setupCrumble( aTime, aOriginX, aOriginY);
    } else if(type.equals("Fall")){
      //animations.add(new Animation("Fall", waitTime, originX, originY));
      setupFall( aTime, aOriginX, aOriginY);
    } else if(type.equals("Mud")){
      //animations.add(new Animation("Fall", waitTime, originX, originY));
      setupMud( round(aTime), aOriginX, aOriginY);
    }
  }
  
  Animation( String aType, int aOriginX, int aOriginY){
    type = aType;
    if(type.equals("Cannon")){
      //animations.add(new Animation("Cannon", originX, originY));
      setupCannon( aOriginX, aOriginY);
    }
  }
  
  
  
  boolean update(){
    if(type.equals("Flow")){
      return updateFlow();
    } else if(type.equals("Crumble")){
      return updateCrumble();
    } else if(type.equals("Fall")){
      return updateFall();
    } else if(type.equals("Cannon")){
      return updateCannon();
    } else if(type.equals("Mud")){
      return updateMud();
    }
    return true;
  }
  
  
  
  
  void setupFlow(float aTime, int aOriginX, int aOriginY, int aDestinationX, int aDestinationY){
    time = aTime;
    originX = aOriginX;
    originY = aOriginY;
    destinationX = aDestinationX;
    destinationY = aDestinationY;
    blockType = blockAt(originX,originY);
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
    animationNotes[originX][originY] = "Flowing";
  }
  
  
  
  boolean updateFlow(){
    if(fade >= 0){
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
      image(blockImages[blockType],originX*csize,originY*csize,csize,csize);
      //image(pg,4*csize,4*csize);
      if(fade >= time){
        blocks[destinationX][destinationY] = blockType;
        disturb(destinationX,destinationY,1,1);
        fade = floor(-time)-2;
      } else {
        if(forward){
          if(hasTag(blocks[destinationX][destinationY],"Weak") && !hasTag(blocks[destinationX][destinationY],"Flow")){
            if(paused == false){
              fade++;
            }
          } else {
            forward = false;
          }
        } else {
          if(paused == false){
            fade -= 1;
          }
        }
      }
      if(blocks[originX][originY] != blockType){
        animationNotes[originX][originY] = "Idle";
        return false;
      }
    } else {
      if(fade == -1){
        animationNotes[originX][originY] = "Idle";
        return false;
      }
      if(paused == false){
        fade++;
      }
    }
    return true;
  }
  
  
  
  void setupCrumble(float aTime, int aOriginX, int aOriginY){
    time = aTime;
    originX = aOriginX;
    originY = aOriginY;
    blockType = blockAt(originX,originY);
    animationNotes[originX][originY] = "Crumble";
    blockImage = createImage(csize,csize, ARGB);
    blockImage.copy(blockImages[blockType], 0, 0, blockImages[blockType].width,blockImages[blockType].height, 0, 0, csize, csize);
    for(int i = 0; i < cracking.length; i++){
      if(i < 4){
        cracking[i][0] = i;
        cracking[i][1] = blockImage.width/2;
        cracking[i][2] = blockImage.height/2;
        cracks = i+1;
      } else {
        cracking[i][0] = -1;
      }
    }
  }
  
  
  
  boolean updateCrumble(){
    if(paused == false){
      for(int i = 0; i < 10; i++){
        if(cracking[i][0] > -1){
          clearImageSpot(blockImage,cracking[i][1],cracking[i][2]);
          if(cracking[i][0] == 0){
            cracking[i][2] += 1;
            cracking[i][1] += choose(1,-1);
          }
          if(cracking[i][0] == 1){
            cracking[i][2] -= 1;
            cracking[i][1] += choose(1,-1);
          }
          if(cracking[i][0] == 2){
            cracking[i][1] += 1;
            cracking[i][2] += choose(1,-1);
          }
          if(cracking[i][0] == 3){
            cracking[i][1] -= 1;
            cracking[i][2] += choose(1,-1);
          }
          if(random(100)<8){
            if(cracks<cracking.length){
              cracking[cracks][0] = floor(random(4));
              cracking[cracks][1] = cracking[i][1];
              cracking[cracks][2] = cracking[i][2];
              cracks++;
            }
          }
        }
      }
    }
    fill(0);
    noStroke();
    if(fade < time/4*3){
      rect(originX*csize,originY*csize,csize,csize);
      image(blockImage,(originX+shiftX)*csize,(originY+shiftY)*csize,csize,csize);
    } else {
      if(blocks[originX][originY] == blockType){
        blocks[originX][originY] = -1;
        animationNotes[originX][originY] = "Idle";
        disturb(originX,originY,1,1);
      }
      tint(255, 255*(1-(fade-time/4*3)/(time/4)));
      image(blockImage,(originX+shiftX)*csize-(fade-time/4*3)/(time/4)*csize/4,(originY+shiftY)*csize-(fade-time/4*3)/(time/4)*csize/4,csize+(fade-time/4*3)/(time/4)*csize/2,csize+(fade-time/4*3)/(time/4)*csize/2);
      tint(255, 255);
    }
    if(fade >= time){
      return false;
    } else {
      if(paused == false){
        fade++;
      }
    }
    return true;
  }
  
  
  
  void setupFall(float aTime, int aOriginX, int aOriginY){
    time = aTime;
    originX = aOriginX;
    originY = aOriginY;
    blockType = blockAt(originX,originY);
    animationNotes[originX][originY] = "Crumble";
    blockImage = createImage(csize,csize, ARGB);
    blockImage.copy(blockImages[blockType], 0, 0, blockImages[blockType].width,blockImages[blockType].height, 0, 0, csize, csize);
  }
  
  
  
  boolean updateFall(){
    if(fade >= time){
      if(fallY == 0){
        blocks[originX][originY] = -1;
        animationNotes[originX][originY] = "Idle";
      }
      if(paused == false){
        fallV += gravity/2;
        fallY += fallV*scale;
      }
      image(blockImage,originX*csize+fallV/2,originY*csize+fallY-fallV,csize-fallV,csize+fallV);
      if(abs(cx - originX*csize)<csize){
        if( abs((originY*csize+fallY+csize)-cy)<csize/2 ){
          kill();
        }
      }
      if(hasTag(blockAt(originX,floor((originY*csize+fallY+csize+fallV+gravity/2)/csize)),"Weak")){
        setBlock(originX,floor((originY*csize+fallY+fallV+gravity/2)/csize),-1);
      } else {
        if(onScreen(originX,floor((originY*csize+fallY+fallV+gravity/2)/csize))){
          setBlock(originX,floor((originY*csize+fallY+fallV+gravity/2)/csize),blockType);
          animationNotes[originX][floor((originY*csize+fallY+fallV+gravity/2)/csize)] = "Fell";
          disturb(originX,floor((originY*csize+fallY+fallV+gravity/2)/csize),1,1);
          //return false;
          fade = floor(-time)-2;
        } else {
          return false;
        }
      }
    } else {
      if(fade == -1){
        if(animationNotes[originX][floor((originY*csize+fallY+fallV+gravity/2)/csize)].equals("Fell")){
          animationNotes[originX][floor((originY*csize+fallY+fallV+gravity/2)/csize)] = "Idle";
        }
        return false;
      }
      if(fade >= 0){
        oscillation = (-cos(fade)+1)*csize/float(25);
        image(blockImage,originX*csize-oscillation/2,originY*csize-oscillation/2,csize+oscillation,csize+oscillation);
        //ellipse(originX*csize+csize/2,originY*csize+csize/2,csize/2,csize/2);
      }
      if(paused == false){
        fade++;
      }
    }
    return true;
  }
  
  
  
  void setupCannon( int aOriginX, int aOriginY){
    
    originX = aOriginX;
    originY = aOriginY;
    
    dir = -1;
    if(hasTag(blockAt(originX,originY),"Up")){
      dir = 0;
    } else if(hasTag(blockAt(originX,originY),"Down")){
      dir = 1;
    } else if(hasTag(blockAt(originX,originY),"Left")){
      dir = 2;
    } else if(hasTag(blockAt(originX,originY),"Right")){
      dir = 3;
    }
    
    speed = 5;
    shiftX = 0;
    shiftY = 0;
    blockImage = loadImage("animations/"+blockFileName[blockAt(originX,originY)]);
    //blockType = blockAt(originX,originY);
  }
  
  
  
  boolean updateCannon(){
    
    if(onScreen(originX+shiftX/csize,originY+shiftY/csize)){
      if(paused == false){
        switch(dir){
          case 0:
            shiftY -= speed;
            if(blockAt(round(originX+shiftX/float(csize)),floor(originY+shiftY/float(csize))) > -1){
                if(hasTag(blockAt(round(originX+shiftX/float(csize)),floor(originY+shiftY/float(csize))),"Weak")){
                  blocks[round(originX+shiftX/float(csize))][floor(originY+shiftY/float(csize))] = -1;
                  return false;
                } else if(hasTag(blockAt(round(originX+shiftX/float(csize)),floor(originY+shiftY/float(csize))),"Bounce")){
                  dir = 1;
                  if(flipY){
                    flipY = false;
                  } else {
                    flipY = true;
                  }
                } else if(hasTag(blockAt(round(originX+shiftX/float(csize)),floor(originY+shiftY/float(csize))),"Solid")){
                  disturb(round(originX+shiftX/float(csize)),floor(originY+shiftY/float(csize)),0,0);
                  return false;
                }
            }
            break;
          case 1:
            shiftY += speed;
            if(blockAt(round(originX+shiftX/float(csize)),ceil(originY+shiftY/float(csize))) > -1){
                if(hasTag(blockAt(round(originX+shiftX/float(csize)),ceil(originY+shiftY/float(csize))),"Weak")){
                  blocks[round(originX+shiftX/float(csize))][ceil(originY+shiftY/float(csize))] = -1;
                  return false;
                } else if(hasTag(blockAt(round(originX+shiftX/float(csize)),ceil(originY+shiftY/float(csize))),"Bounce")){
                  dir = 0;
                  if(flipY){
                    flipY = false;
                  } else {
                    flipY = true;
                  }
                } else if(hasTag(blockAt(round(originX+shiftX/float(csize)),ceil(originY+shiftY/float(csize))),"Solid")){
                  disturb(round(originX+shiftX/float(csize)),ceil(originY+shiftY/float(csize)),0,0);
                  return false;
                }
            }
            break;
          case 2:
            shiftX -= speed;
            if(blockAt(floor(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))) > -1){
                if(hasTag(blockAt(floor(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))),"Weak")){
                  blocks[floor(originX+shiftX/float(csize))][round(originY+shiftY/float(csize))] = -1;
                  return false;
                } else if(hasTag(blockAt(floor(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))),"Bounce")){
                  dir = 3;
                  if(flipX){
                    flipX = false;
                  } else {
                    flipX = true;
                  }
                } else if(hasTag(blockAt(floor(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))),"Solid")){
                  disturb(floor(originX+shiftX/float(csize)),round(originY+shiftY/float(csize)),0,0);
                  return false;
                }
            }
            break;
          case 3:
            shiftX += speed;
            if(blockAt(ceil(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))) > -1){
                if(hasTag(blockAt(ceil(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))),"Weak")){
                  blocks[ceil(originX+shiftX/float(csize))][round(originY+shiftY/float(csize))] = -1;
                  return false;
                } else if(hasTag(blockAt(ceil(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))),"Bounce")){
                  dir = 2;
                  if(flipX){
                    flipX = false;
                  } else {
                    flipX = true;
                  }
                } else if(hasTag(blockAt(ceil(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))),"Solid")){
                  disturb(ceil(originX+shiftX/float(csize)),round(originY+shiftY/float(csize)),0,0);
                  return false;
                }
            }
            break;
        }
      }
    } else {
      return false;
    }
    
    if(abs(cx - (originX*csize+shiftX))<csize){
      if(abs(cy - (originY*csize+shiftY))<csize){
        if(dir == 0 || dir == 1){
          if(abs(cx - (originX*csize+shiftX))<csize/2){
            kill();
          }
        } else {
          if(abs(cy - (originY*csize+shiftY))<csize/2){
            kill();
          }
        }
      }
    }
    
    if(flipX){
      pushMatrix();
      scale(-1.0, 1.0);
      image(blockImage,(originX*csize+shiftX)*-1-csize,originY*csize+shiftY,csize,csize);;
      popMatrix();
    } else if(flipY){
      pushMatrix();
      scale(1.0, -1.0);
      image(blockImage,originX*csize+shiftX,(originY*csize+shiftY)*-1-csize,csize,csize);;
      popMatrix();
    } else {
      image(blockImage,originX*csize+shiftX,originY*csize+shiftY,csize,csize);
    }
    
    return true;
  }
  
  
  
  void setupMud( int aDir, int aOriginX, int aOriginY){
    
    originX = aOriginX;
    originY = aOriginY;
    
    dir = aDir;
    
    speed = 5;
    shiftX = 0;
    shiftY = 0;
    blockImage = loadImage("animations/mudBall.png");
    //blockType = blockAt(originX,originY);
  }
  
  
  
  boolean updateMud(){
    
    if(onScreen(originX/csize+shiftX/csize,originY/csize+shiftY/csize)){
          
      /*
      shiftY += speed;
      if(blockAt(ceil(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))) > -1){
          if(hasTag(blockAt(ceil(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))),"Weak")){
            blocks[ceil(originX+shiftX/float(csize))][round(originY+shiftY/float(csize))] = -1;
            return false;
          } else if(hasTag(blockAt(ceil(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))),"Bounce")){
            dir = 2;
            if(flipX){
              flipX = false;
            } else {
              flipX = true;
            }
          } else if(hasTag(blockAt(ceil(originX+shiftX/float(csize)),round(originY+shiftY/float(csize))),"Solid")){
            disturb(ceil(originX+shiftX/float(csize)),round(originY+shiftY/float(csize)),0,0);
            return false;
          }
      }
        */  
        
        
        shiftX += cspeed*csize*dir;
        
        fallV += gravity;
        shiftY += fallV;
        
        if(blockAt(round((originX+shiftX)/float(csize)),round((originY+shiftY)/float(csize))) > -1){
          if(hasTag(blockAt(round((originX+shiftX)/float(csize)),round((originY+shiftY)/float(csize))),"Weak")){
            blocks[round((originX+shiftX)/float(csize))][round((originY+shiftY)/float(csize))] = index("HM");
            return false;
          } else if(hasTag(blockAt(round((originX+shiftX)/float(csize)),round((originY+shiftY)/float(csize))),"Bounce")){
            dir = 2;
            if(flipX){
              flipX = false;
            } else {
              flipX = true;
            }
          } else if(hasTag(blockAt(round((originX+shiftX)/float(csize)),round((originY+shiftY)/float(csize))),"Solid")){
            disturb(round((originX+shiftX)/float(csize)),round((originY+shiftY)/float(csize)),0,0);
            return false;
          }
        }
          
          
    } else {
      return false;
    }
    
    if(abs(cx - (originX+shiftX))<csize){
      if(abs(cy - (originY+shiftY))<csize){
        
      }
    }
    
    
    image(blockImage,originX+shiftX,originY+shiftY,csize,csize);
    
    
    return true;
  }
  
  
  
  
}




boolean clearImageSpot(PImage img, int xpos, int ypos){
  img.loadPixels();
  
  if(xpos < img.width && xpos >= 0 && ypos < img.height && ypos >= 0){
    img.pixels[xpos+img.width*ypos] = color(0, 0);
  } else {
    return false;
  }
  
  if(xpos+1 < img.width && xpos+1 >= 0 && ypos < img.height && ypos >= 0){
    img.pixels[xpos+1+img.width*ypos] = color(0, 0);
  } else {
    return false;
  }
  
  if(xpos-1 < img.width && xpos-1 >= 0 && ypos < img.height && ypos >= 0){
    img.pixels[xpos-1+img.width*ypos] = color(0, 0);
  } else {
    return false;
  }
  
  if(xpos < img.width && xpos >= 0 && ypos+1 < img.height && ypos+1 >= 0){
    img.pixels[xpos+img.width*(ypos+1)] = color(0, 0);
  } else {
    return false;
  }
  
  if(xpos < img.width && xpos >= 0 && ypos-1 < img.height && ypos-1 >= 0){
    img.pixels[xpos+img.width*(ypos-1)] = color(0, 0);
  } else {
    return false;
  }
  
  img.updatePixels();
  return true;
}

int choose(int a, int b){
  if(random(2)<1){
    return a;
  }
  return b;
}





String index(int valueInt){
  if(blockDefs.length > valueInt && valueInt > -1){
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
  } else {
    if(tempStr.equals("Weak")){
      return true;
    }
  }
  return false;
}

boolean hasTag(int tempBlocka, int tempBlockb, int tempBlockc, int tempBlockd, String tempStr){
  if(hasTag(tempBlocka,tempStr)){
    return true;
  }
  if(hasTag(tempBlockb,tempStr)){
    return true;
  }
  if(hasTag(tempBlockc,tempStr)){
    return true;
  }
  if(hasTag(tempBlockd,tempStr)){
    return true;
  }
  return false;
}

int hasTags(int tempBlock, String tempStr){
  int myreturn = 0;
  if(tempBlock >= 0){
    for(int i = 0; i < 10; i++){
      if(tempStr.equals(blockTags[tempBlock][i])){
        myreturn ++;
      }
    }
  }
  return myreturn;
}

float tagMod(int tempBlock){
  float myreturn = 1;
  myreturn *= pow(2,hasTags(tempBlock,"*2"));
  myreturn *= pow(1.5,hasTags(tempBlock,"*1.5"));
  myreturn *= pow(.5,hasTags(tempBlock,"*.5"));
  return myreturn;
}

int blockAt(float oxpos, float oypos) {
  int xpos = round(oxpos/csize);
  int ypos = round(oypos/csize);

  if (xpos >= 0 && xpos <= 19 && ypos >= 0 && ypos <= 14) {
    return blocks[xpos][ypos];
  } else {
    return -1;
  }
}

int blockAt(int oxpos, int oypos) {
  if (oxpos >= 0 && oxpos <= 19 && oypos >= 0 && oypos <= 14) {
    return blocks[oxpos][oypos];
  } else {
    if(oxpos > csize || oypos > csize){
      return blockAt(float(oxpos),float(oypos));
    } else {
      return -1;
    }
  }
}

boolean setBlock(int oxpos, int oypos, int blockVal) {
  if (oxpos >= 0 && oxpos <= 19 && oypos >= 0 && oypos <= 14) {
    blocks[oxpos][oypos] = blockVal;
  } else {
    return false;
  }
  return true;
}

boolean setBlock(int oxpos, int oypos, int blockVal, boolean saveable) {
  if (oxpos >= 0 && oxpos <= 19 && oypos >= 0 && oypos <= 14) {
    blocks[oxpos][oypos] = blockVal;
    saveBlocks[oxpos][oypos] = blockVal;
  } else {
    return false;
  }
  return true;
}

boolean disturb(int oxpos, int oypos, int radius, int wait){
  
  if(onScreen(oxpos, oypos)){
    if(animationNotes[oxpos][oypos].equals("Idle") && wait <= 0){
      if(hasTag(blocks[oxpos][oypos],"Fall")) {
        animations.add(new Animation("Fall", round(tagMod(blockAt(oxpos,oypos))*50), oxpos, oypos));
        
      }
      if (hasTag(blocks[oxpos][oypos],"Crumble")) {
        animations.add(new Animation("Crumble", round(tagMod(blockAt(oxpos,oypos))*50), oxpos, oypos));
        
      }
    }
    
    if(animationNotes[oxpos][oypos].equals("Idle") || wait > 0){
      if(radius != 0){
        disturb(oxpos+1,oypos,radius-1,wait-1);
        disturb(oxpos-1,oypos,radius-1,wait-1);
        disturb(oxpos,oypos+1,radius-1,wait-1);
        disturb(oxpos,oypos-1,radius-1,wait-1);
      }
    }
    
  }
  return true;
}

boolean onScreen(int oxpos, int oypos){
  if (oxpos >= 0 && oxpos <= 19 && oypos >= 0 && oypos <= 14) {
    return true;
  } else {
    return false;
  }
}
boolean blockUpdates(){
  
  int flowSpeed = 1000;
  
  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blocks[i][j] >= 0) {
        
        if(hasTag(blocks[i][j],"Flow")){
          if(animationNotes[i][j].equals("Idle")){
            flowSpeed = round(pow(tagMod(blocks[i][j]),-1)*30);
            if(hasTag(blocks[i][j],"Right")){
              if(hasTag(blocks[min(i+1,19)][j],"Weak") && hasTag(blocks[min(i+1,19)][j],"Flow") == false){
                animations.add(new Animation("Flow", flowSpeed, i, j, min(i+1,19), j));
              }
            }
            if(hasTag(blocks[i][j],"Left")){
              if(hasTag(blocks[max(i-1,0)][j],"Weak") && hasTag(blocks[max(i-1,0)][j],"Flow") == false){
                animations.add(new Animation("Flow", flowSpeed, i, j, max(i-1,0), j));
              }
            }
            if(hasTag(blocks[i][j],"Down")){
              if(hasTag(blocks[i][min(j+1,14)],"Weak") && hasTag(blocks[i][min(j+1,14)],"Flow") == false){
                animations.add(new Animation("Flow", flowSpeed/2, i, j, i, min(j+1,14)));
              }
            }
            if(hasTag(blocks[i][j],"Up")){
              if(hasTag(blocks[i][max(j-1,0)],"Weak") && hasTag(blocks[i][max(j-1,0)],"Flow") == false){
                animations.add(new Animation("Flow", flowSpeed, i, j, i, max(j-1,0)));
              }
            }
          }
        }
        
        if(hasTag(blocks[i][j],"Jet")){
          if(hasTag(blocks[i][j],"Left")){
            if(abs(cy-j*csize) < csize){
              if(cx/csize <= i){
                int range = 20;
                for(int k = 1; k < 20; k++){
                  if(hasTag(blockAt(i-k,j),"Solid")){
                    range = k-1;
                    k = 20;
                  }
                }
                if(cx/csize > i-range){
                  cx += ( 5 / (abs(cx-(i*csize))/csize + 5) ) *-5;
                }
              }
            }
          }
          
          if(hasTag(blocks[i][j],"Right")){
            if(abs(cy-j*csize) < csize){
              if(cx/csize >= i){
                int range = 20;
                for(int k = 1; k < 20; k++){
                  if(hasTag(blockAt(i+k,j),"Solid")){
                    range = k-1;
                    k = 20;
                  }
                }
                if(cx/csize < i+range){
                  cx += ( 5 / (abs(cx-(i*csize))/csize + 5) ) *5;
                }
              }
            }
          }
          
          if(hasTag(blocks[i][j],"Down")){
            if(abs(cx-i*csize) < csize){
              if(cy/csize >= i){
                int range = 15;
                for(int k = 1; k < 15; k++){
                  if(hasTag(blockAt(i,j+k),"Solid")){
                    range = k-1;
                    k = 15;
                  }
                }
                if(cy/csize < j+range){
                  cy += ( 5 / (abs(cy-(j*csize))/csize + 5) ) *5;
                }
              }
            }
          }
          
          if(hasTag(blocks[i][j],"Up")){
            if(abs(cx-i*csize) < csize){
              if(cy/csize <= j+.1){
                int range = 15;
                for(int k = 1; k < 15; k++){
                  if(hasTag(blockAt(i,j-k),"Solid")){
                    range = k-1;
                    k = 15;
                  }
                }
                if(cy/csize > j-range){
                  cy += ( 5 / (abs(cy-(j*csize))/csize + 5) ) *-5;
                }
              }
            }
          }
          
        }
        
        if(cannonTrigger == 0){
          if(hasTag(blocks[i][j],"Cannon")){
            animations.add(new Animation("Cannon", i, j));
          }
        }
        
        
        if("L".equals(index(blocks[i][j]))){
          if("H2".equals(index(blockAt(i+1,j))) || "H2".equals(index(blockAt(i-1,j))) || "H2".equals(index(blockAt(i,j+1))) || "H2".equals(index(blockAt(i,j-1)))){
            blocks[i][j] = index("WW");
          }
        }
        
        if("HM".equals(index(blocks[i][j]))){
          if(hasTag(blockAt(i,j+1),"Weak") == false){
            blocks[i][j] = index("M");
          }
        }
        
        
      }
    }
  }
  
  /*
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blockUpdates[i][j] >= 0) {
        blocks[i][j] = blockUpdates[i][j];
      }
    }
  }
  */
  cannonTrigger++;
  
  return true;
}

void selectBlock(){
  int tempvar = ceil((blockDefs.length+1)/3)+1;
  fill(200);
  stroke(0);
  strokeWeight(5);
  rect(ssize/2-((240+csize)*3+csize)/2-csize/2, ssize2/2-csize*tempvar/2-csize/2, ((240+csize)*3+csize)+csize,csize*tempvar+csize);
  
  fill(0);
  textSize(18);
  textAlign(LEFT,CENTER);
  for(int i = 0; i < 3; i++){
    for(int j = 0; j < tempvar; j++){
      if(i*tempvar+j-1 < blockDefs.length){
        
        if(selectedBlock == i*tempvar+j-1){
          noStroke();
          fill(255,255,0);
          rect(ssize/2-((240+csize)*3+csize)/2+i*(240+csize)+csize*1.25, j*csize+ssize2/2-csize*tempvar/2+csize/8, 240-csize/2,csize-csize/4);
          fill(0);
        }
        
        if(i*tempvar+j>0){
          image(blockImages[i*tempvar+j-1], ssize/2-((240+csize)*3+csize)/2+i*(240+csize), j*csize+ssize2/2-csize*tempvar/2, csize,csize);
          text(blockName[i*tempvar+j-1], ssize/2-((240+csize)*3+csize)/2+i*(240+csize)+csize*1.5, j*csize+ssize2/2-csize*tempvar/2+csize/2);
        } else {
          text("Air", ssize/2-((240+csize)*3+csize)/2+i*(240+csize)+csize*1.5, j*csize+ssize2/2-csize*tempvar/2+csize/2);
        }
        
      }
    }
  }
}

void blockSelectClick(){
  int tempvar = ceil((blockDefs.length+1)/3+1);
  for(int i = 0; i < 3; i++){
    for(int j = 0; j < tempvar; j++){
      if(i*tempvar+j-1 < blockDefs.length){
        if(abs((j*csize+ssize2/2-csize*tempvar/2+csize/2)-mouseY)<csize/2){
          if(abs((ssize/2-((240+csize)*3+csize)/2+i*(240+csize)+(240+csize)/2)-mouseX)<((240+csize)/2)){
              if(mouseButton == LEFT){
                selectedBlock = i*tempvar+j-1;
              } else if(mouseButton == RIGHT){
                selectedBlock2 = i*tempvar+j-1;
              }
              blockSelection = false;
          }
        }
      }
    }
  }
}

void saveBlocks(){
  loadData = new String[15];
  for(int i = 0; i < 15; i++){
    splitData[0] = "";
    for(int j = 0; j < 20; j++){
      if(saveBlocks[j][i] > -1){
        if(index(saveBlocks[j][i]).length() == 1){
          splitData[0] = splitData[0] + index(blocks[j][i]) + " ,";
        } else {
          splitData[0] = splitData[0] + index(blocks[j][i]) + ",";
        }
      } else {
        splitData[0] = splitData[0] + "  ,";
      }
    }
    
    loadData[i] = splitData[0].substring(0,splitData[0].length()-1);
  }
  saveStrings("data/world"+world+"/level"+level+".txt",loadData);
}

void clearRoom(){
  for(int i = 0; i < 20; i++){
    for(int j = 0; j < 20; j++){
      if(i > 0 && i < 19 && j > 0 && j < 14){
        setBlock(i,j,-1,true);
      } else {
        setBlock(i,j,0,true);
      }
    }
  }
  setBlock(19,1,index("D"),true);
  setBlock(19,2,index("D"),true);
  saveBlocks();
  reload();
}
boolean move(){
  
  vcy += gravity;

  if (jumping) {
    if(noJump){
      noJump = false;
    } else {
      if (hasTag(blockAt(floor(cx/csize),round(cy/csize+.5)),"Solid")) {
        if(vcy > -20){
          vcy = -20;
        }
      } else if(cy>13*csize) {
        if(vcy > -20){
          vcy = -20;
        }
      }
  
      if (round(cx/csize)*csize != round(cx)) {
        if (hasTag(blockAt(floor(cx/csize)+1,round(cy/csize+.5)),"Solid")) {
          if(vcy > -20){
            vcy = -20;
          }
        }
      }
    }
  }

  if (pvcx) {
    cx += csize*cspeed;
    if(sling < 5){
      sling += 1;
    }
    if(muddy){
      if(sling < 0){
        if (hasTag(blockAt(floor(cx/csize),round(cy/csize+.5)),"Solid") == false && hasTag(blockAt(floor(cx/csize)+1,round(cy/csize+.5)),"Solid") == false) {
          animations.add(new Animation("Mud", -1, round(cx), round(cy)));
          muddy = false;
        }
      }
    }
  } else {
    if(sling > 0){
      sling -= 1;
    }
  }
  
  if (nvcx) {
    cx -= csize*cspeed;
    if(sling > -5){
      sling -= 1;
    }
    if(muddy){
      if(sling > 0){
        if (hasTag(blockAt(floor(cx/csize),round(cy/csize+.5)),"Solid") == false && hasTag(blockAt(floor(cx/csize)+1,round(cy/csize+.5)),"Solid") == false) {
          animations.add(new Animation("Mud", 1, round(cx), round(cy)));
          muddy = false;
        }
      }
    }
  } else {
    if(sling < 0){
      sling += 1;
    }
  }
  
  cy += vcy*scale;
  
  if(lastX != cx || lastY != cy){
    moveTo(cx,cy);
  }
  
  //movementGrid();
  
  if (cy > ssize2-csize) {
    cy = ssize2-csize;
    if (vcy > 0) {
      vcy = 0;
    }
  }
  
  //Image Version
  squish = (squish*3+(vcy))/4;
  if (abs(squish)>csize/3) {
    squish = (abs(squish)/squish) * (csize/3);
  }
  
  return true;
}

float movementGrid(float tempX) {
  return round(tempX/(csize*cspeed))*(csize*cspeed);
}
boolean reload(){
  
  
  
  csize = 50; //Modifyable
  ssize = csize * 20; //Modifyable
  ssize2 = csize * 15;
  scale = ssize/float(1000);
  bsize = csize;
  facing = false;
  world = 1;
  level = 1;
  
  blockSelection = false;
  editor = true;
  showInvisible = false;
  
  //Animation[] animation = new Animation[0];
  animations = new ArrayList<Animation>();
  
  cspeed = 1/float(8);
  squish = 0;
  
  
  //Varying Variables
  blocks = new int[20][15];
  saveBlocks = new int[20][15];
  animationNotes = new String[20][15];
  
  //Cuboyd Posistion
  cx = ssize/10-csize;
  cy = ssize2-csize*2;
  lastX = cx;
  lastY = cy;
  sling = 0;
  
  //Cuboyd Velocity
  pvcx = false;
  nvcx = false;
  jumping = false;
  muddy = false;
  noJump = false;
  //float vcx = 0;
  vcy = 0;
  lastUpdate = -1;
  fps = 30;
  fts = 11;
  dead = false;
  
  cannonTrigger = 1;
  
  gravity = 1.5;
  
  
  
  
  loadBlocks();
  loadLevel();
  
  for (int i = animations.size()-1; i >= 0; i--) {
    animations.remove(i);
  }
  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      animationNotes[i][j] = "Idle";
    }
  }
  

  cuboydImage = loadImage("cuboyd.png");
  muddyImage = loadImage("muddy.png");
  
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

boolean loadBlocks(){
  loadData = loadStrings("blockInfo.txt");
  blockDefs = new String[loadData.length-3];
  blockName = new String[loadData.length-3];
  blockFileName = new String[loadData.length-3];
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
    blockFileName[i-3] = splitData[2];
    if(hasTag(i-3,"WorldSpecific")){
      blockImages[i-3] = loadImage("world"+world+"/blocks/"+splitData[2]);
    } else {
      blockImages[i-3] = loadImage("blocks/"+splitData[2]);
    }
    
  
  }
    
  return true;
}

boolean loadLevel(){
  
  //blockDefs[0] = "W";
  //blockDefs[1] = "D";
  
  loadData = loadStrings("WORLD_AND_LEVEL.txt");
  splitData = split(loadData[0],',');
  world = int(splitData[0]);
  level = int(splitData[1]);
  
  loadData = loadStrings("world"+world+"/level"+level+".txt");
  
  String tempStr;
  blocks = new int[20][15];
  
  for (int i = 0; i < 15; i++) {
    
    splitData = split(loadData[i],','); //KYLE! - THIS MEANS THAT THE LEVEL FILE WAS NOT FOUND- CHECK THAT THE FILE "data/world#/level#.txt" EXISTS BASED ON WHAT YOU ENTERED IN "WORLD_AND_LEVEL.txt"! GOOD LUCK!
    
    for (int j = 0; j < 20; j++) {
      
      tempStr = splitData[j];
      if(" ".equals(tempStr.charAt(1)+"")){
        tempStr = tempStr.charAt(0)+"";
      }
      blocks[j][i] = index(tempStr);
      saveBlocks[j][i] = index(tempStr);
    }
  }
  
  return true;
}

void kill(){
  dead = true;
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
  
  disturb(round((cx+csize)/csize),round(cy/csize),0,0);
  disturb(round((cx-csize)/csize),round(cy/csize),0,0);
  disturb(round(cx/csize),round((cy+csize)/csize),0,0);
  disturb(round(cx/csize),round((cy-csize)/csize),0,0);
  
  int tba = touch(cx+csize*tempx, cy);
  int tbb = touch(cx, cy+csize*tempy);
  int tbc = touch(cx+csize*tempx, cy+csize*tempy);
  int tbd = touch(cx, cy);
  
  
  if (hasTag(tba,tbb,tbc,tbd,"Climb")) {
    if(jumping){
      vcy -= .3;
    } else {
      vcy += .3;
    }
    if(abs(vcy)>3){
      vcy = vcy/abs(vcy)*3;
    }
    vcy -= gravity;
  } else if (hasTag(tba,tbb,tbc,tbd,"Swim")) {
    if(jumping){
      vcy -= .5;
    } else {
      if(vcy < 0){
        vcy += .5;
      } else {
        vcy += .1;
      }
    }
    if(abs(vcy)>10){
      vcy = vcy/abs(vcy)*10;
    }
    
    vcy -= gravity;
  }
  
  if (hasTag(tba,tbb,tbc,tbd,"Kill")) {
    kill();
  }
  
  if (hasTag(tba,tbb,tbc,tbd,"CannonTrigger")) {
    if(cannonTrigger > 2){
      cannonTrigger = 0;
    } else {
      cannonTrigger = 1;
    }
  }
  
  
  if (hasTag(tba,tbb,tbc,tbd,"End")) {
    reload();
  }
  
  /*
  if (hasTag(tba,tbb,tbc,tbd,"Crumble")) {
    if (hasTag(tba,"Crumble")) {
      if(animationNotes[round((cx+csize*tempx)/csize)][round(cy/csize)].equals("Idle")){
        animations.add(new Animation("Crumble", 50, round((cx+csize*tempx)/csize), round(cy/csize)));
      }
    }
    if (hasTag(tbb,"Crumble")) {
      if(animationNotes[round(cx/csize)][round((cy+csize*tempy)/csize)].equals("Idle")){
        animations.add(new Animation("Crumble", 50, round(cx/csize), round((cy+csize*tempy)/csize)));
      }
    }
    if (hasTag(tbc,"Crumble")) {
      if(animationNotes[round((cx+csize*tempx)/csize)][round((cy+csize*tempy)/csize)].equals("Idle")){
        animations.add(new Animation("Crumble", 50, round((cx+csize*tempx)/csize), round((cy+csize*tempy)/csize)));
      }
    }
    if (hasTag(tbd,"Crumble")) {
      if(animationNotes[round(cx/csize)][round(cy/csize)].equals("Idle")){
        animations.add(new Animation("Crumble", 50, round(cx/csize), round(cy/csize)));
      }
    }
  }
  
  if (hasTag(tba,tbb,tbc,tbd,"Fall")) {
    if (hasTag(tba,"Fall")) {
      if(animationNotes[round((cx+csize*tempx)/csize)][round(cy/csize)].equals("Idle")){
        animations.add(new Animation("Fall", 50, round((cx+csize*tempx)/csize), round(cy/csize)));
      }
    }
    if (hasTag(tbb,"Fall")) {
      if(animationNotes[round(cx/csize)][round((cy+csize*tempy)/csize)].equals("Idle")){
        animations.add(new Animation("Fall", 50, round(cx/csize), round((cy+csize*tempy)/csize)));
      }
    }
    if (hasTag(tbc,"Fall")) {
      if(animationNotes[round((cx+csize*tempx)/csize)][round((cy+csize*tempy)/csize)].equals("Idle")){
        animations.add(new Animation("Fall", 50, round((cx+csize*tempx)/csize), round((cy+csize*tempy)/csize)));
      }
    }
    if (hasTag(tbd,"Fall")) {
      if(animationNotes[round(cx/csize)][round(cy/csize)].equals("Idle")){
        animations.add(new Animation("Fall", 50, round(cx/csize), round(cy/csize)));
      }
    }
  }
  */
  
  return true;
  
}

int touch(float oxpos, float oypos){
  
  //Independent block touches
  
  return blockAt(oxpos,oypos);
}




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
  if (key == ' ') {
    if(paused){
      paused = false;
    } else {
      paused = true;
    }
  }
  if(editor){
    if (key == 'r') {
      reload();
    }
    if (key == 'C') {
      clearRoom();
    }
    if (key == 'b') {
      if(blockSelection){
        blockSelection = false;
      } else {
        blockSelection = true;
      }
    }
    if (key == 'i') {
      if(showInvisible){
        showInvisible = false;
      } else {
        showInvisible = true;
      }
    }
    
  } else {
    if (key == 'k') {
      kill();
    }
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

void mouseReleased(){
  if(editor){
    if(blockSelection == false){
      saveBlocks();
    } else {
      blockSelectClick();
    }
  }
}
  
boolean renderWorld(){
  
  background(200);
  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blocks[i][j] >= 0) {
        
        if("Invisible".equals(blockTags[blocks[i][j]][0])){
          
          
          tint(255, min(csize-(abs(i*csize-cx)-csize),csize-(abs(j*csize-cy)-csize))/csize*255);
          image(blockImages[blocks[i][j]],i*bsize, j*bsize, bsize, bsize);
          tint(255,255);
          
          if(editor){
            if(showInvisible){
              image(blockImages[blocks[i][j]],i*bsize, j*bsize, bsize, bsize);
            }
          }
          
        } else {
          image(blockImages[blocks[i][j]],i*bsize, j*bsize, bsize, bsize);
        }
        
      }
    }
  }
  
  for (int i = animations.size()-1; i >= 0; i--) {
    Animation animation = animations.get(i);
    if (animation.update() != true) {
      animations.remove(i);
    }
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
  if(muddy){
    image(muddyImage, cx+squish/2, cy-squish, csize-squish, csize+squish);
  }
  
  if(editor){
    if(blockSelection){
      selectBlock();
    }
    
    fill(255);
    textAlign(LEFT,CENTER);
    textSize(12);
    text(fps+" Steps/Second",ssize-csize*10,csize/2);
    text(round(frameRate)+" FPS",ssize-csize,csize/2);
    text(animations.size()+" Animations",ssize-csize*4,csize/2);
  }
  
  
  
  
  return true;
}
boolean collisions(){
  
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
          //cx = xpos*csize+csize;
        } else {
          //cx = xpos*csize-csize;
        }
      } else {
        if (cy>ypos*csize) {
          //cy = ypos*csize+csize;
        } else {
          //cy = ypos*csize-csize;
        }
        //vcy = 0;
      }
    }
  }
  //rect(xpos * csize, ypos * csize, csize, csize);
  return true;
}

boolean moveTo( float stopX, float stopY){
  
  float startX = lastX;
  float startY = lastY;
  
  stopX = cx;
  stopY = cy;
  
  
  //println("hi");
  
  if(stopX-startX>0){
    if(ceil(startX/csize) != ceil(stopX/csize)){
      if(hasTag(blockAt(ceil(startX/csize)+1,floor(startY/csize)),"Solid") || hasTag(blockAt(ceil(startX/csize)+1,ceil(startY/csize)),"Solid")){
        cx = (ceil(startX/csize))*csize;
        if(hasTag(blockAt(ceil(startX/csize)+1,floor(startY/csize)),"Muddy") || hasTag(blockAt(ceil(startX/csize)+1,ceil(startY/csize)),"Muddy")){
          muddy = true;
        }
      }
    }
  } else if(stopX-startX<0){
    if(floor(startX/csize) != floor(stopX/csize)){
      if(hasTag(blockAt(floor(startX/csize)-1,floor(startY/csize)),"Solid") || hasTag(blockAt(floor(startX/csize)-1,ceil(startY/csize)),"Solid")){
        cx = (floor(startX/csize))*csize;
        if(hasTag(blockAt(floor(startX/csize)-1,floor(startY/csize)),"Muddy") || hasTag(blockAt(floor(startX/csize)-1,ceil(startY/csize)),"Muddy")){
          muddy = true;
        }
      }
    }
  }
  
  if(stopY-startY>0){
    if(ceil(startY/csize) != ceil(stopY/csize)){
      if(hasTag(blockAt(floor(cx/csize),ceil(movementGrid(startY)/csize)+1),"Solid") || hasTag(blockAt(ceil(cx/csize),ceil(movementGrid(startY)/csize)+1),"Solid")){
        cy = (ceil(startY/csize))*csize;
        
        if(hasTag(blockAt(floor(cx/csize),ceil(movementGrid(startY)/csize)+1),"Muddy") || hasTag(blockAt(ceil(cx/csize),ceil(movementGrid(startY)/csize)+1),"Muddy")){
          muddy = true;
          noJump = true;
        }
        if(hasTag(blockAt(floor(cx/csize),ceil(movementGrid(startY)/csize)+1),"Bounce") || hasTag(blockAt(ceil(cx/csize),ceil(movementGrid(startY)/csize)+1),"Bounce")){
          if(hasTag(blockAt(floor(cx/csize),ceil(movementGrid(startY)/csize)+1),"Weak")){
            if(jumping){
              vcy = -vcy-round(tagMod(blockAt(ceil(cx/csize),ceil(movementGrid(startY)/csize)+1))*3);
            } else {
              vcy = -vcy+round(tagMod(blockAt(ceil(cx/csize),ceil(movementGrid(startY)/csize)+1))*3);
            }
          } else if(hasTag(blockAt(ceil(cx/csize),ceil(movementGrid(startY)/csize)+1),"Weak")){
            if(jumping){
              vcy = -vcy-round(tagMod(blockAt(floor(cx/csize),ceil(movementGrid(startY)/csize)+1))*3);
            } else {
              vcy = -vcy+round(tagMod(blockAt(floor(cx/csize),ceil(movementGrid(startY)/csize)+1))*3);
            }
          } else if(hasTag(blockAt(floor(cx/csize),ceil(movementGrid(startY)/csize)+1),"Bounce") && hasTag(blockAt(ceil(cx/csize),ceil(movementGrid(startY)/csize)+1),"Bounce")){
            if(jumping){
              vcy = -vcy-round(tagMod(blockAt(ceil(cx/csize),ceil(movementGrid(startY)/csize)+1))*3);
            } else {
              vcy = -vcy+round(tagMod(blockAt(ceil(cx/csize),ceil(movementGrid(startY)/csize)+1))*3);
            }
          } else {
            vcy = 0;
          }
        } else {
          vcy = 0;
        }
      }
    }
  } else if(stopY-startY<0){
    if(floor(startY/csize) != floor(stopY/csize)){
      if(hasTag(blockAt(floor(cx/csize),floor(movementGrid(startY)/csize)-1),"Solid") || hasTag(blockAt(ceil(cx/csize),floor(movementGrid(startY)/csize)-1),"Solid")){
        cy = (floor(startY/csize))*csize;
        vcy = 0;
        if(hasTag(blockAt(floor(cx/csize),floor(movementGrid(startY)/csize)-1),"Muddy") || hasTag(blockAt(ceil(cx/csize),floor(movementGrid(startY)/csize)-1),"Muddy")){
          muddy = true;
        }
      }
    }
  }
  
  lastX = cx;
  lastY = cy;
  
  return true;
}

