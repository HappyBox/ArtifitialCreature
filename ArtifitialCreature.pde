import processing.sound.*;
Sound s;
SinOsc sin;
CreatureSystem crs;

void setup() {
  size(1500, 900);
  
  //sin = new SinOsc(this);
  //sin.play(200, 0.2);
  //sin = new SinOsc(this);
  //sin.play(205, 0.2);

  // Create a Sound object for globally controlling the output volume.
  s = new Sound(this);
  
  crs = new CreatureSystem();
  for(int i = 0; i < 5; i++)
  {
    crs.addCreature(random(50, width-50), random(50, height-50));
  }
}

void draw() {
  s.volume(1);
  background(255, 245, 206);
  crs.runArray();
  
  if(mousePressed){
    //crs.clean();
    crs.addZombies(random(50, width-50), random(50, height-50));
  }
  if(keyPressed){
    if(key == 'm' || key == 'M'){
      //crs.addCreature(mouseX, mouseY);
      crs.mMode++;
      //sin.freq(200);
    }
    if(key == 'g' || key == 'G'){
      //crs.addCreature(mouseX, mouseY);
      crs.gMode++;
    }
  }
  
  textSize(32);
  fill(0, 102, 153);
  text(crs.eyes.size(), 10, 40);
  text(crs.zombies.size(), width-50, 40);
}


// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class CreatureSystem {
  ArrayList<Creature> eyes;
  ArrayList<Food> deadEyes;
  ArrayList<Zombie> zombies;
  PVector origin;
  int mMode = 0;
  int gMode = 0;

  CreatureSystem() {
    //origin = position.copy();
    eyes = new ArrayList<Creature>();
    deadEyes = new ArrayList<Food>();
    zombies = new ArrayList<Zombie>();
    //tongs = new ArrayList<Creature>();
    //aliens = new ArrayList<Creature>();
  }

  void addCreature(float x, float y) {
    PVector origin = new PVector(x,y);
    eyes.add(new Creature(origin));
  }
  
  void addZombies(float x, float y) {
    PVector origin = new PVector(x,y);
    zombies.add(new Zombie(origin));
  }

  void runArray() {
    for(Food e : deadEyes) {
      e.run();
    }
    for (int i = eyes.size()-1; i >= 0; i--) {
      Creature e = eyes.get(i);
      e.mMode = mMode;
      e.gMode = gMode;
      
      eyes = e.senceEnvironment(eyes, i);
      e.run(eyes);
      e.eatZombies(zombies);
      if (e.health <= 0 || e.countNeighbors(eyes) >= 5) {
        eyes.remove(i);
        deadEyes.add(new Food(e.position));
      }
    }
    for(int i = 0; i < zombies.size()-1; i++) {
      Zombie e = zombies.get(i);
      e.run(deadEyes, zombies);
      
      //must be after e.run
      deadEyes = e.getFoodList();
      zombies = e.getZombies();
      
      if (e.health <= 0) {
        zombies.remove(i);
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
    for (int i = deadEyes.size()-1; i >= 0; i--) {
      deadEyes.remove(i);
    }
  }
  
}
