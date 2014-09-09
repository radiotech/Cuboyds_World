boolean reload(){

  cx = ssize/10-csize;
  cy = ssize2-csize*2;
  
  loadBlocks();
  loadLevel();
  
  for (int i = animations.size()-1; i >= 0; i--) {
    animations.remove(i);
  }
  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      animationNotes[i][j] = "Idle";
    }
  }
  

  cuboydImage = loadImage("cuboyd.png");
  
  //Block Creation  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<14; j++) {
      //blocks[i][j] = floor(random(20));
    }
  }
  //Box Around
  for (int i = 0; i<20; i++) {
    //blocks[i][0] = 1;
    //blocks[i][14] = 1;
  }
  for (int i = 0; i<15; i++) {
    //blocks[0][i] = 1;
    //blocks[19][i] = 1;
  }
  
  return true;
}

boolean loadBlocks(){
  loadData = loadStrings("blockInfo.txt");
  blockDefs = new String[loadData.length-3];
  blockName = new String[loadData.length-3];
  blockFileName = new String[loadData.length-3];
  blockFile = new String[loadData.length-3];
  blockImages = new PImage[loadData.length-3];
  blockTags = new String[loadData.length-3][10];

  for(int i = 3; i < loadData.length; i++){
    splitData = split(loadData[i],',');
    
    for(int j = 3; j < splitData.length; j++){
      blockTags[i-3][j-3] = splitData[j];
    }
    
    blockDefs[i-3] = splitData[0];
    blockName[i-3] = splitData[1];
    blockFileName[i-3] = splitData[2];
    if(hasTag(i-3,"LevelSpecific")){
      blockImages[i-3] = loadImage("level"+level+"/blocks/"+splitData[2]);
    } else {
      blockImages[i-3] = loadImage("blocks/"+splitData[2]);
    }
    
  
  }
    
  return true;
}

boolean loadLevel(){
  
  //blockDefs[0] = "W";
  //blockDefs[1] = "D";
  
  loadData = loadStrings("LEVEL_AND_ROOM.txt");
  splitData = split(loadData[0],',');
  level = int(splitData[0]);
  room = int(splitData[1]);
  
  loadData = loadStrings("level"+level+"/room"+room+".txt");
  
  String tempStr;
  blocks = new int[20][15];
  
  for (int i = 0; i < 15; i++) {
    
    splitData = split(loadData[i],','); //KYLE! - THIS MEANS THAT THE ROOM FILE WAS NOT FOUND- CHECK THAT THE FILE "data/level#/room#.txt" EXISTS BASED ON WHAT YOU ENTERED IN "LEVEL_AND_ROOM.txt"! GOOD LUCK!
    
    for (int j = 0; j < 20; j++) {
      
      tempStr = splitData[j];
      if(" ".equals(tempStr.charAt(1)+"")){
        tempStr = tempStr.charAt(0)+"";
      }
      blocks[j][i] = index(tempStr);
      
    }
  }
  
  return true;
}
