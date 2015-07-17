class Particle { 
  //// CMYK CONVERSION ///////////////////
  CMYK_Colour cmykConverter; /// cmyk_swatch = new CMYK_Colour(swatch);// don't really need this
  /// particle attributes
  float x;
  float y;
  float vx;
  float vy;
  float life;
  float mass;
  final static float MOMENTUM = 0.5f;
  final static float FLUID_FORCE = 0.35f;

  color sprayColor;
  PImage img = loadImage("data/texture.png");

  void init(float x, float y, color theColor) { 
    // cmykConverter = new CMYK_Colour();
    this.x = x; 
    this.y = y;  
    float tC;
    float tM;
    float tY;
    float tK; 
    sprayColor = theColor; // cmykConverter.cmykConvert(theColor);
    life = random(0.1f, 0.5f); 
    mass = random(0.1f, 1);  
    vx = random(-3, 3);/*-alpha*1-10;*/
    vy = random(-3, 3);
    
    /// create our blurry graphic
    /*
    PGraphics pg = createGraphics(200,200,OPENGL);
    pg.beginDraw();
    pg.background(0,0,0,0);
    pg.fill(255);
    pg.noStroke();
    pg.ellipse(100,100,10,10);
    pg.filter(BLUR,2);
    pg.endDraw();
    cir = pg.get();
    imageMode(CENTER);
    */
  }
  void update() { 
    if (life == 0) return; // only update if particle is visible

    int fluidIndex = mSa.fluidSolver.getIndexForNormalizedPosition(x * mSa.invWidth, y * mSa.invHeight);
    vx = mSa.fluidSolver.u[fluidIndex] * width * mass * FLUID_FORCE + vx * MOMENTUM;
    vy = mSa.fluidSolver.v[fluidIndex] * height * mass * FLUID_FORCE + vy * MOMENTUM;
    if (x<0||x>stageW)vx=-vx;
    if (y<0||y>stageH)vy=-vy;
    x += vx; 
    y += vy; 
    vx*=life; 
    vy*=life; //vy+=particlesGravity;
    if (vx * vx + vy * vy < 1) { 
      vx = random(-1, 1); 
      vy = random(-1, 1);
    } // make particles glitter when the slow down a lot
    life *= particlesLifeFactor; 
    if (life < 0.01) life = 0;
  } // fade out a bit (and kill if alpha == 0);
  void  display() {  
    // strokeWeight( life*particlesRenderSize);  
    noStroke();
    // stroke(life*(255),life*(255),255-life*100, life*200+55);
        
        tint(sprayColor, 126); 
    image(img, x, y);
    fill(sprayColor, 35);
    ellipse(x,y,2, 2);
    
    fill(sprayColor, 35);
    ellipse(x,y,5, 5);
    
    fill(sprayColor, 35);
    ellipse(x,y,7, 7);
    
    fill(sprayColor, 35);
    ellipse(x,y,9, 9);

    
    // image( cir, x, y);
    /// filter(BLUR,1);
    // stroke(sprayColor, life*200+55);
    //point(x, y);  
    // line(x-vx, y-vy, x, y);

  }
}

