boolean blockUpdates(){
  
  int flowSpeed = 1000;
  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blocks[i][j] >= 0) {
        
        if(hasTag(blocks[i][j],"Flow")){
          if(animationNotes[i][j].equals("Idle")){
            if(hasTag(blocks[i][j],"Fast")){
              flowSpeed = 15;
            }
            if(hasTag(blocks[i][j],"Medium")){
              flowSpeed = 30;
            }
            if(hasTag(blocks[i][j],"Slow")){
              flowSpeed = 60;
            }
            
            if(hasTag(blocks[min(i+1,19)][j],"Weak") && hasTag(blocks[min(i+1,19)][j],"Flow") == false){
              animations.add(new Animation("Flow", flowSpeed, i, j, min(i+1,19), j));
            }
            if(hasTag(blocks[max(i-1,0)][j],"Weak") && hasTag(blocks[max(i-1,0)][j],"Flow") == false){
              animations.add(new Animation("Flow", flowSpeed, i, j, max(i-1,0), j));
            }
            if(hasTag(blocks[i][min(j+1,14)],"Weak") && hasTag(blocks[i][min(j+1,14)],"Flow") == false){
              animations.add(new Animation("Flow", flowSpeed/2, i, j, i, min(j+1,14)));
            }
          
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
  
  return true;
}
