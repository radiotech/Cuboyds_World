
void selectBlock(){
  int tempvar = ceil((blockDefs.length+1)/3)+1;
  fill(200);
  stroke(0);
  strokeWeight(5);
  rect(ssize/2-((240+csize)*3+csize)/2-csize/2, ssize2/2-csize*tempvar/2-csize/2, ((240+csize)*3+csize)+csize,csize*tempvar+csize);
  
  fill(0);
  textSize(18);
  textAlign(LEFT,CENTER);
  for(int i = 0; i < 3; i++){
    for(int j = 0; j < tempvar; j++){
      if(i*tempvar+j-1 < blockDefs.length){
        
        if(selectedBlock == i*tempvar+j-1){
          noStroke();
          fill(255,255,0);
          rect(ssize/2-((240+csize)*3+csize)/2+i*(240+csize)+csize*1.25, j*csize+ssize2/2-csize*tempvar/2+csize/8, 240-csize/2,csize-csize/4);
          fill(0);
        }
        
        if(i*tempvar+j>0){
          image(blockImages[i*tempvar+j-1], ssize/2-((240+csize)*3+csize)/2+i*(240+csize), j*csize+ssize2/2-csize*tempvar/2, csize,csize);
          text(blockName[i*tempvar+j-1], ssize/2-((240+csize)*3+csize)/2+i*(240+csize)+csize*1.5, j*csize+ssize2/2-csize*tempvar/2+csize/2);
        } else {
          text("Air", ssize/2-((240+csize)*3+csize)/2+i*(240+csize)+csize*1.5, j*csize+ssize2/2-csize*tempvar/2+csize/2);
        }
        
      }
    }
  }
}

void blockSelectClick(){
  int tempvar = ceil((blockDefs.length+1)/3+1);
  for(int i = 0; i < 3; i++){
    for(int j = 0; j < tempvar; j++){
      if(i*tempvar+j-1 < blockDefs.length){
        if(abs((j*csize+ssize2/2-csize*tempvar/2+csize/2)-mouseY)<csize/2){
          if(abs((ssize/2-((240+csize)*3+csize)/2+i*(240+csize)+(240+csize)/2)-mouseX)<((240+csize)/2)){
              if(mouseButton == LEFT){
                selectedBlock = i*tempvar+j-1;
              } else if(mouseButton == RIGHT){
                selectedBlock2 = i*tempvar+j-1;
              }
              blockSelection = false;
          }
        }
      }
    }
  }
}

void saveBlocks(){
  loadData = new String[15];
  for(int i = 0; i < 15; i++){
    splitData[0] = "";
    for(int j = 0; j < 20; j++){
      if(saveBlocks[j][i] > -1){
        if(index(saveBlocks[j][i]).length() == 1){
          splitData[0] = splitData[0] + index(blocks[j][i]) + " ,";
        } else {
          splitData[0] = splitData[0] + index(blocks[j][i]) + ",";
        }
      } else {
        splitData[0] = splitData[0] + "  ,";
      }
    }
    
    loadData[i] = splitData[0].substring(0,splitData[0].length()-1);
  }
  saveStrings("data/world"+world+"/level"+level+".txt",loadData);
}

void clearRoom(){
  for(int i = 0; i < 20; i++){
    for(int j = 0; j < 20; j++){
      if(i > 0 && i < 19 && j > 0 && j < 14){
        setBlock(i,j,-1,true);
      } else {
        setBlock(i,j,0,true);
      }
    }
  }
  setBlock(19,1,index("D"),true);
  setBlock(19,2,index("D"),true);
  saveBlocks();
  reload();
}
