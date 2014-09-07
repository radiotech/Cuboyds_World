String index(int valueInt){
  if(blockDefs.length > valueInt){
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

boolean disturb(int oxpos, int oypos, int radius, int wait){
  
  if(onScreen(oxpos, oypos)){
    if(animationNotes[oxpos][oypos].equals("Idle") && wait <= 0){
      if(hasTag(blocks[oxpos][oypos],"Fall")) {
        animations.add(new Animation("Fall", 50, oxpos, oypos));
        
      }
      if (hasTag(blocks[oxpos][oypos],"Crumble")) {
        animations.add(new Animation("Crumble", 50, oxpos, oypos));
        
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
