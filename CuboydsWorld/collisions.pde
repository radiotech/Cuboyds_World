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
