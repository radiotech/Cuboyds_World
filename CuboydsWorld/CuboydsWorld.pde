/* @pjs preload="cuboyd.png"; */


//Run in Fullscreen
//boolean sketchFullScreen() {
//  return true;
//}


//Constant Variables
int csize = 50; //Modifyable
int ssize = csize * 20; //Modifyable
int ssize2 = csize * 15;
float scale = ssize/float(1000);
int bsize = csize;
boolean facing = false;
int level = 1;
int room = 1;

//Animation[] animation = new Animation[0];
ArrayList<Animation> animations = new ArrayList<Animation>();

float cspeed = 1/float(8);
float squish = 0;

String[] loadData;
String[] splitData;
String[] blockDefs;
String[] blockName;
String[] blockFileName;
String[] blockFile;
PImage[] blockImages;
String[][] blockTags;

//Varying Variables
int[][] blocks = new int[20][15];
String[][] animationNotes = new String[20][15];

//Cuboyd Posistion
float cx = ssize/10-csize;
float cy = ssize2-csize*2;
float lastX = cx;
float lastY = cy;

//Cuboyd Velocity
boolean pvcx = false;
boolean nvcx = false;
boolean jumping = false;
//float vcx = 0;
float vcy = 0;
int lastUpdate = -1;
int fps = 30;
int fts = 11;

int cannonTrigger = 1;

float gravity = 1.5;

//Image Declaration
PImage cuboydImage;



//Occurs once at beginning of game
void setup() {
  size(ssize, ssize2); //this needs to be on the first line of setup
  reload();
}

void draw() {
  
  
  //updating the game world
  
  if(lastUpdate != millis()/(1000/30) % 30){
    
    move();
  
    blockUpdates();
    collisions();
    touches();
    
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

