boolean renderWorld(){
  
  background(200);
  
  for (int i = 0; i<20; i++) {
    for (int j = 0; j<15; j++) {
      if (blocks[i][j] >= 0) {
        
        if("Invisible".equals(blockTags[blocks[i][j]][0])){
          
          
          tint(255, min(csize-(abs(i*csize-cx)-csize),csize-(abs(j*csize-cy)-csize))/csize*255);
          image(blockImages[blocks[i][j]],i*bsize, j*bsize, bsize, bsize);
          tint(255,255);
          
          if(editor){
            if(showInvisible){
              image(blockImages[blocks[i][j]],i*bsize, j*bsize, bsize, bsize);
            }
          }
          
        } else {
          image(blockImages[blocks[i][j]],i*bsize, j*bsize, bsize, bsize);
        }
        
      }
    }
  }
  
  for (int i = animations.size()-1; i >= 0; i--) {
    Animation animation = animations.get(i);
    if (animation.update() != true) {
      animations.remove(i);
    }
  }
  
  fill(255);
  noStroke();
  image(cuboydImage, cx+squish/2, cy-squish, csize-squish, csize+squish);
  if(facing){
    rect(cx+csize/2-12/float(32)*(csize-squish),cy+csize-24/float(32)*(csize+squish),4/float(32)*(csize-squish),7/float(32)*(csize+squish));
    rect(cx+csize/2+4/float(32)*(csize-squish),cy+csize-24/float(32)*(csize+squish),4/float(32)*(csize-squish),7/float(32)*(csize+squish));
  } else {
    rect(cx+csize/2-8/float(32)*(csize-squish),cy+csize-24/float(32)*(csize+squish),4/float(32)*(csize-squish),7/float(32)*(csize+squish));
    rect(cx+csize/2+8/float(32)*(csize-squish),cy+csize-24/float(32)*(csize+squish),4/float(32)*(csize-squish),7/float(32)*(csize+squish));
  }
  if(muddy){
    image(muddyImage, cx+squish/2, cy-squish, csize-squish, csize+squish);
  }
  
  if(editor){
    if(blockSelection){
      selectBlock();
    }
    
    fill(255);
    textAlign(LEFT,CENTER);
    textSize(12);
    text(fps+" Steps/Second",ssize-csize*10,csize/2);
    text(round(frameRate)+" FPS",ssize-csize,csize/2);
    text(animations.size()+" Animations",ssize-csize*4,csize/2);
  }
  
  
  
  
  return true;
}
