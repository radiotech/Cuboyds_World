boolean move(){
  
  vcy += gravity;

  if (jumping) {
    if (hasTag(blockAt(floor(cx/csize),round(cy/csize+.5)),"Solid")) {
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
  
  return true;
}
