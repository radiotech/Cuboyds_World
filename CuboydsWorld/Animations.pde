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





