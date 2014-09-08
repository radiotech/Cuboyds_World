boolean move(){
  
  //vcy += gravity;

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
    vcx += csize*cspeed;
  }
  if (nvcx) {
    vcx -= csize*cspeed;
  }
  
    //cy += vcy*scale;
  //cx += vcx*scale;

  moveTo(cx+vcx*scale,cy+vcy*scale);
  
  movementGrid();
  
  if (cy > ssize2-csize) {
    cy = ssize2-csize;
    if (vcy > 0) {
      vcy = 0;
    }
  }
  
  return true;
}

boolean movementGrid() {
  float tempcx = round((cx+ocx)/(csize*cspeed))*(csize*cspeed);
  ocx = (cx+ocx) - (tempcx);
  cx = tempcx;
  if(ocx == lastocx){
    ocx = 0;
  }
  lastocx = ocx;
  return true;
}
