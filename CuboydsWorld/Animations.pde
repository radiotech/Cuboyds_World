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
  
  Animation( String aType, float aTime, int aOriginX, int aOriginY, int aDestinationX, int aDestinationY){
    type = aType;
    if(type.equals("Flow")){
      //animations.add(new Animation("Flow", flowSpeed, originX, originY, destinationX, destinationY));
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
  }
  
  Animation( String aType, float aTime, int aOriginX, int aOriginY){
    type = aType;
    if(type.equals("Crumble")){
      //animations.add(new Animation("Crumble", time, originX, originY));
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
    
    if(type.equals("Fall")){
      //animations.add(new Animation("Fall", waitTime, originX, originY));
      time = aTime;
      originX = aOriginX;
      originY = aOriginY;
      
      blockType = blockAt(originX,originY);
      
      animationNotes[originX][originY] = "Crumble";
      blockImage = createImage(csize,csize, ARGB);
      blockImage.copy(blockImages[blockType], 0, 0, blockImages[blockType].width,blockImages[blockType].height, 0, 0, csize, csize);
      
    }
  }
  
  boolean update(){
    
    if(type.equals("Flow")){
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
              fade++;
            } else {
              forward = false;
            }
          } else {
            fade -= 1;
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
        fade++;
      }
      
    } else if(type.equals("Crumble")){
      
      
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
        fade += 1;
      }
      
    } else if(type.equals("Fall")){

      if(fade >= time){
        if(fallY == 0){
          blocks[originX][originY] = -1;
          animationNotes[originX][originY] = "Idle";
        }
        
        fallV += gravity/2;
        
        fallY += fallV*scale;
        
        image(blockImage,originX*csize+fallV/2,originY*csize+fallY-fallV,csize-fallV,csize+fallV);
        
        if(hasTag(blockAt(originX,floor((originY*csize+fallY+csize+fallV+gravity/2)/csize)),"Weak")){
          setBlock(originX,floor((originY*csize+fallY+fallV+gravity/2)/csize),-1);
        } else {
          setBlock(originX,floor((originY*csize+fallY+fallV+gravity/2)/csize),blockType);
          animationNotes[originX][floor((originY*csize+fallY+fallV+gravity/2)/csize)] = "Fell";
          disturb(originX,floor((originY*csize+fallY+fallV+gravity/2)/csize),1,1);
          //return false;
          fade = floor(-time)-2;
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
        fade++;
      }
    }
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