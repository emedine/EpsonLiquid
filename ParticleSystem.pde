//////////////////////THE ParticleSystem////////////

class ParticleSystem {
  int pNum; 
  color tColor;

  PVector emitPos = new PVector(0,0);
  Particle[] particles;
  ParticleSystem(color theColor) {
    tColor = theColor;
    particles = new Particle[maxParticles]; 
    for (int i=0; i<maxParticles; i++) particles[i] = new Particle(); 
    pNum = 0;
  }

  void updateAndDraw() {
    //  if(mMousePressed){ emitter(mMouseX, mMouseY, 10,10); }
    
    
    for (int i=0; i<maxParticles; i++) { 
      if (particles[i].life > 0) { 
        particles[i].update(); 
        particles[i].display();
      }
    }
  }
  ///
  void emitter(float x, float y, int count, int emitterSize ) { 
    /// emitPos
    // for (int i=0; i<count; i++) makeParticle(emitPos.x + random(-emitterSize, emitterSize), emitPos.y + random(-emitterSize, emitterSize));
    for (int i=0; i<count; i++) makeParticle(x + random(-emitterSize, emitterSize), y + random(-emitterSize, emitterSize));
  }
  void makeParticle(float x, float y) { 
    particles[pNum].init(x, y, tColor); 
    pNum++; 
    if (pNum >= maxParticles) pNum = 0;
  }

 
}





