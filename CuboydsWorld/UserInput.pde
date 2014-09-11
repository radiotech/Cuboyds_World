void keyPressed() {
  if (keyCode == UP) {
    jumping = true;
  }
  if (keyCode == LEFT) {
    nvcx = true;
    facing = true;
  }
  if (keyCode == RIGHT) {
    pvcx = true;
    facing = false;
  }
  if (key == ' ') {
    if(paused){
      paused = false;
    } else {
      paused = true;
    }
  }
  if(editor){
    if (key == 'r') {
      reload();
    }
    if (key == 'b') {
      if(blockSelection){
        blockSelection = false;
      } else {
        blockSelection = true;
      }
    }
  } else {
    if (key == 'k') {
      kill();
    }
  }
}

//Obtain user input
void keyReleased() {
  if (keyCode == UP) {
    jumping = false;
  }
  if (keyCode == LEFT) {
    nvcx = false;
    if (pvcx) {
      facing = false;
    }
  }
  if (keyCode == RIGHT) {
    pvcx = false;
    if (nvcx) {
      facing = true;
    }
  }
} 

void mouseReleased(){
  if(editor){
    if(blockSelection == false){
      saveBlocks();
    } else {
      blockSelectClick();
    }
  }
}
  
