/* OpenProcessing Tweak of *@*http://www.openprocessing.org/sketch/101045*@* */
/*
 globalKeyEvents=true; 
 pauseOnBlur=false; 
 */

//////////// GLOBALS 
int stageW=1200;
int stageH=600;
// the color for the background

int backgroundRed=35*2;
int backgroundGreen=30*2;
int backgroundBlue=50*2;
int backgroundAlpha=30; 

////// PARTICLE SYSTEM 
int maxParticles = 1200;
int particlesRenderSize = 3; 
float particlesLifeFactor = (float)(0.95);

///// ARRAY LIST TO HOLD THE COLOR STREAMS ////////////
ArrayList<ParticleSystem> StreamCyan = new ArrayList<ParticleSystem>();
ArrayList<ParticleSystem> StreamMagenta = new ArrayList<ParticleSystem>();
ArrayList<ParticleSystem> StreamYellow = new ArrayList<ParticleSystem>();
ArrayList<ParticleSystem> StreamBlack = new ArrayList<ParticleSystem>();

//// kill these later and have generic p systems
ParticleSystem particleSystemC;
ParticleSystem particleSystemM;
ParticleSystem particleSystemY;
ParticleSystem particleSystemK;

MSAHandler mSa;
PImage mImage;// the image

//// SPAWN POSITIONS ///////////
int botCyan;
int botMag;
int botYellow;
int botBlk;

//// colors ///
color theCyan = color(0, 174, 239);
color theMagenta = color(236, 0, 140);
color theYellow = color(255, 242, 0);
color theBlack = color(0, 0, 0);

//// EMITTER POSTIONS /////////
PVector posCyan = new PVector(stageW/5, 0);
PVector posMag = new PVector(stageW/4, 0);
PVector posYellow = new PVector(stageW/3, 0);
PVector posBlack = new PVector(stageW/2, 0);

//// TARGET SET BY THE SLIDER POSITION //////
PVector targetCyan =  new PVector(stageW/5, 0);
PVector targetMag = new PVector(stageW/4, 0);
PVector targetYellow = new PVector(stageW/3, 0);
PVector targetBlack = new PVector(stageW/2, 0);

//// current emitter ID /////////
int bottleID = 0;

boolean mMousePressed=false; 
float mMouseX=(float)(stageW/2); 
float mMouseY=(float)(stageH/2); // triggered from mouse and multitouch

float[] pTx= new float[99];
float[] pTy= new float[99];
float[] pTvx= new float[99];
float[] pTvy= new float[99];

//// CMYK CONVERSION ///////////////////
CMYK_Colour cmykConverter; /// cmyk_swatch = new CMYK_Colour(swatch);

public void setup() { 

  size(stageW, stageH, OPENGL);
  mImage = loadImage("data/background_epson_stars.jpg"); //mImage.resize(w,h);

  rectMode(CENTER);  

  /// cmyk converter
  cmykConverter = new CMYK_Colour();

  noSmooth();

  /// frameRate(20);   // not sure why we need this

  colorMode(RGB, 255); 
  //create the ParticleSystems assign them their colors
  particleSystemC = new ParticleSystem(theCyan);
  particleSystemM = new ParticleSystem(theMagenta);
  particleSystemY = new ParticleSystem(theYellow);
  particleSystemK = new ParticleSystem(theBlack);
  
  StreamCyan.add(particleSystemC);
  StreamMagenta.add(particleSystemM);
  StreamYellow.add(particleSystemY);
  StreamBlack.add(particleSystemK);
  
  mSa = new MSAHandler();
}
public void draw() {   
  
  /*
  if (mousePressed) {    
    mMouseX=mouseX;
    mMouseY=mouseY;  
    mMousePressed=true;
  }//handle the mouse events

*/
  fill(backgroundRed, backgroundGreen, backgroundBlue, backgroundAlpha); 
  rect(width/2, height/2, width, height); //draw a background with motion blur
  tint(255, 10);
  image(mImage, 0, 0, width, height);
  tint(255, 255);
  colorMode(RGB, 1); 
  mSa.update(); 
  colorMode(RGB, 255); 
  
  updateEmitterPositions();

  updateAllParticles();

  /// particleSystemK.updateAndDraw();
  //selectedThumbnail.src=externals.canvas.toDataURL("image/jpeg",0.7);// take a screenshot from the sketch and place it in the imgElement
  //make the mouse unpressed for next draw loop
  mMousePressed=false;
}

void updateEmitterPositions(){
  targetCyan.y = targetMag.y = targetYellow.y = targetBlack.y = mouseY;
  if(posCyan.y < targetCyan.y){
    
    posCyan.y = stageH;
  } else {
    posCyan.y -= 10;
  }
  
  if(posMag.y < targetMag.y){
    
    posMag.y = stageH;
  } else {
    posMag.y -= 10;
  }
  
  if(posYellow.y < targetYellow.y){
    
    posYellow.y = stageH;
  } else {
    posYellow.y -= 10;
  }
  
  if(posBlack.y < targetBlack.y){
    
    posBlack.y = stageH;
  } else {
    posBlack.y -= 10;
  }
  /*
  fill(0);
  ellipse(posBlack.x, posBlack.y, 30,30);
  println("Pos y: " + posBlack.y + " target: " + targetBlack.y);
  */
  /*
  //// EMITTER POSTIONS /////////
PVector posCyan = new PVector(stageW/5, 0);
PVector posMag = new PVector(stageW/4, 0);
PVector posYellow = new PVector(stageW/3, 0);
PVector posBlack = new PVector(stageW/2, 0);

//// TARGET SET BY THE SLIDER POSITION //////
PVector targetCyan =  new PVector(stageW/5, 0);
PVector targetMag = new PVector(stageW/4, 0);
PVector targetYellow = new PVector(stageW/3, 0);
PVector targetBlack = new PVector(stageW/2, 0);
*/
  ///// move the emitter from stageH to target
  
  //// once it's there put it back
  
  
}

void updateAllParticles() {

  int num = bottleID;

  ////////// WE DON"T NEED TO PASS THE POSITIONS HERE //////////////////
  switch(num) {
  case 0: 
    for (int i = 0; i < StreamCyan.size(); i++) {
      ParticleSystem pc = StreamCyan.get(i);
      pc.updateAndDraw(new PVector(posCyan.x, posCyan.y));
    }

   ////  particleSystemC.updateAndDraw(new PVector(posCyan.x, mouseY));
    break;
  case 1: 
    for (int j = 0; j < StreamMagenta.size(); j++) {
      ParticleSystem pm = StreamMagenta.get(j);
      pm.updateAndDraw(new PVector(posMag.x, posMag.y));
    }
    //// particleSystemM.updateAndDraw(new PVector(posMag.x, mouseY));
    break;

  case 2:
    for (int K = 0; K < StreamYellow.size(); K++) {
      ParticleSystem py = StreamYellow.get(K);
      py.updateAndDraw(new PVector(posYellow.x, posYellow.y));
    }
    /// particleSystemY.updateAndDraw(new PVector(posYellow.x, mouseY));
    break;

  case 3:
      for (int l = 0; l < StreamBlack.size(); l++) {
      ParticleSystem pb= StreamBlack.get(l);
      pb.updateAndDraw(new PVector(posBlack.x, posBlack.y));
    }
    /// particleSystemK.updateAndDraw(new PVector(posBlack.x, mouseY));
    break;
  }
}

///////// INTERACTIVITY ////////////
void keyPressed() {
  println(keyCode);
  if (keyCode == 67) {
    println("CYAN");
    bottleID = 0;
  } 
  else if (keyCode == 77) {
    println("MAGENTA");
    bottleID = 1;
  } 
  else if (keyCode == 89) {
    println("YELLOW");
    bottleID = 2;
  } 
  else if (keyCode == 75) {
    println("BLACK");
    bottleID = 3;
  }
  println("Bottle ID: " + bottleID);
}


public void mouseDragged() {

  /*
  float tYPos = mouseY;
   switch(num) {
   case 0: 
   particleSystemC.updateAndDraw(new PVector(posCyan.x, mouseY));
   break;
   case 1: 
   particleSystemM.updateAndDraw(new PVector(posMag.x, mouseY));
   break;
   
   case 2:
   particleSystemY.updateAndDraw(new PVector(posYellow.x, mouseY));
   break;
   
   case 3:
   particleSystemK.updateAndDraw(new PVector(posBlack.x, mouseY));
   break;
   }
   */
  mSa.updatePositions(bottleID);
}
