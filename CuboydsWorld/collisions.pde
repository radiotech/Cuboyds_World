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

boolean movementGrid() {
  cx = round(cx/(csize*cspeed))*(csize*cspeed);
  return true;
}
