boolean blockUpdates(){
  
  int flowSpeed = 1000;
  
  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blocks[i][j] >= 0) {
        
        if(hasTag(blocks[i][j],"Flow")){
          if(animationNotes[i][j].equals("Idle")){
            flowSpeed = round(pow(tagMod(blocks[i][j]),-1)*30);
            if(hasTag(blocks[i][j],"Right")){
              if(hasTag(blocks[min(i+1,19)][j],"Weak") && hasTag(blocks[min(i+1,19)][j],"Flow") == false){
                animations.add(new Animation("Flow", flowSpeed, i, j, min(i+1,19), j));
              }
            }
            if(hasTag(blocks[i][j],"Left")){
              if(hasTag(blocks[max(i-1,0)][j],"Weak") && hasTag(blocks[max(i-1,0)][j],"Flow") == false){
                animations.add(new Animation("Flow", flowSpeed, i, j, max(i-1,0), j));
              }
            }
            if(hasTag(blocks[i][j],"Down")){
              if(hasTag(blocks[i][min(j+1,14)],"Weak") && hasTag(blocks[i][min(j+1,14)],"Flow") == false){
                animations.add(new Animation("Flow", flowSpeed/2, i, j, i, min(j+1,14)));
              }
            }
            if(hasTag(blocks[i][j],"Up")){
              if(hasTag(blocks[i][max(j-1,0)],"Weak") && hasTag(blocks[i][max(j-1,0)],"Flow") == false){
                animations.add(new Animation("Flow", flowSpeed, i, j, i, max(j-1,0)));
              }
            }
          }
        }
        
        if(hasTag(blocks[i][j],"Jet")){
          if(hasTag(blocks[i][j],"Left")){
            if(abs(cy-j*csize) < csize){
              if(cx/csize <= i){
                int range = 20;
                for(int k = 1; k < 20; k++){
                  if(hasTag(blockAt(i-k,j),"Solid")){
                    range = k-1;
                    k = 20;
                  }
                }
                if(cx/csize > i-range){
                  cx += ( 5 / (abs(cx-(i*csize))/csize + 5) ) *-5;
                }
              }
            }
          }
          
          if(hasTag(blocks[i][j],"Right")){
            if(abs(cy-j*csize) < csize){
              if(cx/csize >= i){
                int range = 20;
                for(int k = 1; k < 20; k++){
                  if(hasTag(blockAt(i+k,j),"Solid")){
                    range = k-1;
                    k = 20;
                  }
                }
                if(cx/csize < i+range){
                  cx += ( 5 / (abs(cx-(i*csize))/csize + 5) ) *5;
                }
              }
            }
          }
          
          if(hasTag(blocks[i][j],"Down")){
            if(abs(cx-i*csize) < csize){
              if(cy/csize >= i){
                int range = 15;
                for(int k = 1; k < 15; k++){
                  if(hasTag(blockAt(i,j+k),"Solid")){
                    range = k-1;
                    k = 15;
                  }
                }
                if(cy/csize < j+range){
                  cy += ( 5 / (abs(cy-(j*csize))/csize + 5) ) *5;
                }
              }
            }
          }
          
          if(hasTag(blocks[i][j],"Up")){
            if(abs(cx-i*csize) < csize){
              if(cy/csize <= j+.1){
                int range = 15;
                for(int k = 1; k < 15; k++){
                  if(hasTag(blockAt(i,j-k),"Solid")){
                    range = k-1;
                    k = 15;
                  }
                }
                if(cy/csize > j-range){
                  cy += ( 5 / (abs(cy-(j*csize))/csize + 5) ) *-5;
                }
              }
            }
          }
          
        }
        
        if(cannonTrigger == 0){
          if(hasTag(blocks[i][j],"Cannon")){
            animations.add(new Animation("Cannon", i, j));
          }
        }
        
        
        if("L".equals(index(blocks[i][j]))){
          if("H2".equals(index(blockAt(i+1,j))) || "H2".equals(index(blockAt(i-1,j))) || "H2".equals(index(blockAt(i,j+1))) || "H2".equals(index(blockAt(i,j-1)))){
            blocks[i][j] = index("WW");
          }
        }
        
        if("HM".equals(index(blocks[i][j]))){
          if(hasTag(blockAt(i,j+1),"Weak") == false){
            blocks[i][j] = index("M");
          }
        }
        
        
      }
    }
  }
  
  /*
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blockUpdates[i][j] >= 0) {
        blocks[i][j] = blockUpdates[i][j];
      }
    }
  }
  */
  cannonTrigger++;
  
  return true;
}
