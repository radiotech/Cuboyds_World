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
  
  return true;
}

float movementGrid(float tempX) {
  return round(tempX/(csize*cspeed))*(csize*cspeed);
}
