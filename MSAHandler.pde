/* 
 HANDLES THE DATA FOR THE FLUID SOLVER
 */

class MSAHandler {


  float sizex, sizey;

  final float FLUID_WIDTH = 32;
  boolean colorfluid=true;
  float invWidth, invHeight;  
  float aspectRatio, aspectRatio2;

  MSAFluidSolver2D fluidSolver;

  PImage imgFluid;

  int[] texPixels;
  int fw;
  int fh;

  //// bottle ID for switching
  int botID = 0;
  // positions
  PVector prevPos = new PVector(0, 0);
  PVector curPos = new PVector(0, 0);
  /// constructor
  MSAHandler() {    
    initMSA();
  }

  public void initMSA() {
    invWidth = 1.0f/width;
    invHeight = 1.0f/height;
    aspectRatio = width * invHeight;
    aspectRatio2 = aspectRatio * aspectRatio;

    // create fluid and set options
    //   fluidSolver = new MSAFluidSolver2D((int)(FLUID_WIDTH), (int)(FLUID_WIDTH * height/width));
    //   fluidSolver.enableRGB(colorfluid).setFadeSpeed(0.012f).setDeltaT(0.5f).setVisc(0.0000001f);
    //  fluidSolver.setSolverIterations(1);


    fluidSolver = new MSAFluidSolver2D((int)(FLUID_WIDTH), (int)(FLUID_WIDTH * height/width));
    fluidSolver.enableRGB(true).setFadeSpeed(0.003f).setDeltaT(0.5f).setVisc(0.0001f);

    // create image to hold fluid picture
    imgFluid = createImage(fluidSolver.getWidth(), fluidSolver.getHeight(), ARGB);
    //     bgImage.resize(fluidSolver.getWidth(), fluidSolver.getHeight());
    fw=fluidSolver.getWidth();
    fh=fluidSolver.getHeight();
    int fc=fw*fh;
    texPixels=new int[fc];
    mImage.loadPixels();
    sizex=(float)width/(float)fluidSolver.getWidth();
    sizey=(float)height/(float)fluidSolver.getHeight();
  }


  /////////  pass it the bottle id we're currently using ////
  public void updatePositions(int bottleID) {

    ///////// change this to track the UI Sliders
    curPos.x = mouseX;
    curPos.y = mouseY;
    /*
    float mouseNormX = mouseX * invWidth;
     float mouseNormY = mouseY * invHeight;
     float mouseVelX = (mouseX - pmouseX) * invWidth;
     float mouseVelY = (mouseY - pmouseY) * invHeight;
     */
    ///*
    float mouseNormX = prevPos.x * invWidth;
    float mouseNormY = curPos.y * invHeight;
    float mouseVelX = (curPos.x - prevPos.x) * invWidth;
    float mouseVelY = (curPos.y - prevPos.y) * invHeight;
    //*/
    prevPos.x = curPos.x;
    prevPos.y = curPos.y;

    botID = bottleID;

    float tYPos = mouseY;


    addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY, 15, 15); /// smaller is less force
  }


  public void update() {

    fluidSolver.update();

    if (colorfluid) {       
      colorMode(RGB, 1); 
      if (frameCount==10) {      
        background(0);  
        image(mImage, 0, 0, fw, fh); 
        loadPixels();
      }

      for (int x=0;x<fw;x++) {
        for (int y=0;y<fh;y++) {
          int a = y*fw+x;

          if (frameCount==10) {      

            int c = get(x, y);
            texPixels[a]=c;
            fluidSolver.r[a]=red(c);
            fluidSolver.g[a]=green(c);
            fluidSolver.b[a]=blue(c);
          }

          if (frameCount%4==0) {      

            fluidSolver.r[a]+=red(texPixels[a])/32f;
            fluidSolver.g[a]+=green(texPixels[a])/32f;
            fluidSolver.b[a]+=blue(texPixels[a])/32f;
          }
        }
      }



      float d = .8f;
      for (int i=0; i<fluidSolver.getNumCells(); i++) {
        imgFluid.pixels[i] = color(fluidSolver.r[i] * d, fluidSolver.g[i] * d, fluidSolver.b[i] * d, ((fluidSolver.r[i] * d)+(fluidSolver.g[i] * d)+(fluidSolver.b[i] * d))/3);
      }                  

      imgFluid.updatePixels();

      //  tint(1,1,1,.4f);
      // imgFluid.filter(BLUR,1);
      /// CANT TELL IF BLEND IS HELPFUL OR NOT
      blend(imgFluid, 0, 0, width, height, 0, 0, width, height, LIGHTEST); /// LIGHTEST //// ADD /// SUBTRACT  //// DARKEST
      image(imgFluid, 0, 0, width, height);
    }
  }

  int deathZone=10;

  // add force and dye to fluid, and create particles
  void emitter(float x, float y, float dx, float dy, int count, int emitterSize) {
    if (x>deathZone&& x<width-deathZone && y>deathZone&&y<height-deathZone) {

      if (Math.abs(dx) <tuioStationaryForce/10 && Math.abs(dx)<tuioStationaryForce/10) {
        dx = random(-tuioStationaryForce, tuioStationaryForce);
        dy = random(-tuioStationaryForce, tuioStationaryForce);
      }

      float mouseNormX = x * invWidth;
      float mouseNormY = y * invHeight;
      float mouseVelX = dx * invWidth;
      float mouseVelY = dy * invHeight;
      addForce(mouseNormX, mouseNormY, mouseVelX, mouseVelY, count, emitterSize);
    }
  }


  final static float tuioStationaryForce = 10.75f; // force exerted when cursor is stationary



  public void addForce(float x, float y, float dx, float dy, int count, int emitterSize) {

    if (x<0) x = 0;
    else if (x>1) x = 1;
    if (y<0) y = 0;
    else if (y>1) y = 1;

    float colorMult = 5;
    float velocityMult = 30.0f;

    int index = fluidSolver.getIndexForNormalizedPosition(x, y);

    int drawColor;

    colorMode(HSB, 360, 1, 1);
    float hue = ((x + y) * 180 + frameCount) % 360;
    drawColor = color(hue, 1, 1);
    colorMode(RGB, 1); 

    fluidSolver.rOld[index]  += red(drawColor) * colorMult;
    fluidSolver.gOld[index]  += green(drawColor) * colorMult;
    fluidSolver.bOld[index]  += blue(drawColor) * colorMult;

    //// draw the particle systems
    switch(botID) {
    case 0: 
      particleSystemC.emitter(x * width, y * height, count, emitterSize);
      break;
    case 1: 
      particleSystemM.emitter(x * width, y * height, count, emitterSize);
      break;

    case 2:
      particleSystemY.emitter(x * width, y * height, count, emitterSize);
      break;

    case 3:
      particleSystemK.emitter(x * width, y * height, count, emitterSize);
      break;
    }






    fluidSolver.uOld[index] += dx * velocityMult;
    fluidSolver.vOld[index] += dy * velocityMult;
    colorMode(RGB, 255); 
    //   }
  }

  public class frame {
    int x, y;
    float rot;
    public frame(  int mx, int my, float mrot) {
      x=mx;
      y=my;
      rot=mrot;
    }
    public frame() {
      this(0, 0, 0);
    }
    public void update() {
      rot--;
    }
  }
}

