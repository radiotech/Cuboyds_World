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
  if (key == 'r') {
    reload();
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
