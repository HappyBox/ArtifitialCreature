
CreatureSystem crs;

void setup() {
  size(1500, 900);
  crs = new CreatureSystem();
  for(int i = 0; i < 10; i++)
  {
    crs.addCreature(random(width-100)+50, random(height-100)+50);
  }
}

void draw() {
  background(100, 150, 150);
  crs.runArray();
  
  if(mousePressed){
    crs.clean();
  }
  if(keyPressed == true){
    //crs.reproduce();
  }
}


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class CreatureSystem {
  ArrayList<Creature> eyes;
  ArrayList<Creature> tongs;
  ArrayList<Creature> aliens;
  PVector origin;

  CreatureSystem() {
    //origin = position.copy();
    eyes = new ArrayList<Creature>();
    tongs = new ArrayList<Creature>();
    aliens = new ArrayList<Creature>();
  }

  void addCreature(float x, float y) {
    PVector origin = new PVector(x,y);
    eyes.add(new Creature(origin));
  }

  void runArray() {
    for (int i = eyes.size()-1; i >= 0; i--) {
      Creature e = eyes.get(i);
      eyes = e.reproduceIfNear(eyes, i);
      e.run();
      if (e.age == 10) {
        eyes.remove(i);
      }
    }
  }
  
  //void reproduce() {
  //  for (int i = particles.size()-1; i >= 0; i--) {
  //    Creature c = particles.get(i);
  //    particles = c.reproduceIfNear(particles, i);
  //    c.run();
  //    if (c.isDead()) {
  //      particles.remove(i);
  //    }
  //  }
  //}
  
  void clean() {
    for (int i = eyes.size()-1; i >= 0; i--) {
      eyes.remove(i);
    }
  }
  
}
