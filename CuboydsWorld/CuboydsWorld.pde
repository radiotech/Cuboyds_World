/* @pjs preload="cuboyd.png"; */

//Run in Fullscreen
//boolean sketchFullScreen() {
//  return true;
//}

boolean paused = false;




//Constant Variables
int csize = 50; //Modifyable
int ssize = csize * 20; //Modifyable
int ssize2 = csize * 15;
float scale = ssize/float(1000);
int bsize = csize;
boolean facing = false;
int world = 1;
int level = 1;

//Animation[] animation = new Animation[0];
ArrayList<Animation> animations = new ArrayList<Animation>();

float cspeed = 1/float(8);
float squish = 0;
boolean editor;
boolean blockSelection;
int selectedBlock = 0;
int selectedBlock2 = -1;
boolean showInvisible;



String[] loadData;
String[] splitData;
String[] blockDefs;
String[] blockName;
String[] blockFileName;
String[] blockFile;
PImage[] blockImages;
String[][] blockTags;

//Varying Variables
int[][] blocks;
int[][] saveBlocks;
String[][] animationNotes;

//Cuboyd Posistion
float cx;
float cy;
float lastX;
float lastY;

int sling;

//Cuboyd Velocity
boolean pvcx;
boolean nvcx;
boolean jumping;
boolean muddy;
boolean noJump;

float vcy;
int lastUpdate;
int fps;
int fts;
boolean dead;

int cannonTrigger;

float gravity;

//Image Declaration
PImage cuboydImage;
PImage muddyImage;



//Occurs once at beginning of game
void setup() {
  size(ssize, ssize2); //this needs to be on the first line of setup
  reload();
}

void draw() {
  
  
  //updating the game world
  
  if(mousePressed){
    if(editor){
      if(blockSelection == false){
        if(mouseButton == LEFT){
          setBlock(floor(mouseX/csize),floor(mouseY/csize),selectedBlock,true);
        } else if(mouseButton == RIGHT){
          setBlock(floor(mouseX/csize),floor(mouseY/csize),selectedBlock2,true);
        }
      }
    }
  }
  
  if(lastUpdate != millis()/(1000/30) % 30){
    
    if(dead){
      reload();
    }
    
    if(paused == false){
      move();
    
      blockUpdates();
      collisions();
      touches();
    }
    
    //Cuboyd Modifications

    //Drawing the world
    renderWorld();
    
    fts += 1;
    if(lastUpdate > millis()/(1000/30) % 30){
      fps = fts;
      fts = 0;
    }
    lastUpdate = millis()/(1000/30) % 30;
  }
  
  
}

