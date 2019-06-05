CreatureSystem crs;

void setup() {
  size(900, 900);
  crs = new CreatureSystem();
  for(int i = 0; i < 100; i++)
  {
    crs.addCreature(random(900), random(900));
  }
}

void draw() {
  background(0);
  crs.runArray();
  
  if(mousePressed){
    crs.clean();
  }
}


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class CreatureSystem {
  ArrayList<Creature> particles;
  PVector origin;

  CreatureSystem() {
    //origin = position.copy();
    particles = new ArrayList<Creature>();
  }

  void addCreature(float x, float y) {
    PVector origin = new PVector(x,y);
    particles.add(new Creature(origin));
  }

  void runArray() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Creature c = particles.get(i);
      c.run();
      if (c.isDead()) {
        particles.remove(i);
      }
    }
  }
  
  void clean() {
    for (int i = particles.size()-1; i >= 0; i--) {
      particles.remove(i);
    }
  }
  
}
