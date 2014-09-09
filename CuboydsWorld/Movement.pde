boolean move(){
  
  vcy += gravity;

  if (jumping) {
    if (hasTag(blockAt(floor(cx/csize),round(cy/csize+.5)),"Solid")) {
      vcy = -20;
    } else if(cy>13*csize) {
      vcy = -20;
    }

    if (round(cx/csize)*csize != round(cx)) {
      if (hasTag(blockAt(floor(cx/csize)+1,round(cy/csize+.5)),"Solid")) {
        vcy = -20;
      }
    }
  }

  if (pvcx) {
    cx += csize*cspeed;
  }
  if (nvcx) {
    cx -= csize*cspeed;
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
