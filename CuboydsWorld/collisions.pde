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
