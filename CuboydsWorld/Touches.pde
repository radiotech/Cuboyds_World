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
    reload();
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




