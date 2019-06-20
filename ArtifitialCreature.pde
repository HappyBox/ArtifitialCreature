import processing.sound.*;
import processing.serial.*;

Serial myPort;
String[] sensorReading = {"3","1023","1023"};

SoundFile background;
SoundFile fadeaway;
SoundFile click;
SoundFile click2;
SinOsc sin;

CreatureSystem crs;

int soundInterval = 0;
ArrayList<SoundFile> sounds = new ArrayList<SoundFile>();

PImage img;
PImage img2;
PImage img3;

void setup() {
  size(1192, 670);
  
  //uncomment when you connect arduino
  //myPort = new Serial(this, Serial.list()[1], 9600); // instead of 5, choose what even serial port the Arduino connects to
  //myPort.bufferUntil('\n');
  
  background = new SoundFile(this, "background.mp3");
  fadeaway = new SoundFile(this, "fadeaway.mp3");
  click = new SoundFile(this, "squize.mp3");
  click2 = new SoundFile(this, "squize.mp3");
  background.loop();
  click.amp(0);
  click2.amp(0.5);
  
  sounds.add(new SoundFile(this, "1.mp3"));
  sounds.add(new SoundFile(this, "2.mp3"));
  sounds.add(new SoundFile(this, "3.mp3"));
  sounds.add(new SoundFile(this, "4.mp3"));
  //sounds.add(new SoundFile(this, "5.mp3"));
  
  img = loadImage("backgroun1.jpg");
  img2 = loadImage("eyeA.png");
  img3 = loadImage("eye3.png");
  
  crs = new CreatureSystem();
  for(int i = 0; i < 5; i++)
  {
    crs.addCreature(random(50, width/2-50), random(50, height-50));
  }
}

void draw() {
  background(img);
  fill(255, 100);
  noStroke();
  rect(0, 0, width, height);
  tint(255, 255);
  textSize(20);
  text("Sensor0 Reading: " + sensorReading[0], 150, 30);
  text("Sensor1 Reading: " + sensorReading[1], 150, 60);
  text("Sensor2 Reading: " + sensorReading[2], 150, 90);
  
  crs.runArray();
  
  if(mousePressed){
    //crs.clean();
    crs.addZombies(random(width/2, width-50), random(50, height-50));
  }
  
  
  if(keyPressed){
    if(key == 'm' || key == 'M'){
      //crs.addCreature(mouseX, mouseY);
      crs.mMode++;
      //sin.freq(200);
    }
    if(key == 'g' || key == 'G' ){
      //crs.addCreature(mouseX, mouseY);
      crs.addCreature(random(50, width/2-50), random(50, height-50));
    }
    if(key == 'z' || key == 'Z' ){
      //crs.addCreature(mouseX, mouseY);
      crs.cleanB();
    }
    if(key == 'x' || key == 'X' ){
      //crs.addCreature(mouseX, mouseY);
      crs.cleanW();
    }
    if(key == 'c' || key == 'C' ){
      //crs.addCreature(mouseX, mouseY);
      crs.clean();
    }
  }
  
  textSize(32);
  fill(255);
  text(crs.eyes.size(), 80, 40);
  image(img2, 40, 30, 50, 50);
  text(crs.zombies.size(), width-60, 40);
  image(img3, width-100, 30, 50, 50);
  
  playRandomInterval();
  displayErraser();
}

void displayErraser(){
  fill(255, 0, 0 , 50);
  noStroke();
  rect(1023-Float.parseFloat(sensorReading[1]), Float.parseFloat(sensorReading[2]), 100, 100);
}

//uncomment when you connect arduino
//void serialEvent (Serial myPort) {
//  //sensorReading = split(myPort.readStringUntil('\n'), ",");
  
//}

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
    for(int i = zombies.size()-1; i >= 0; i--) {
      Zombie e = zombies.get(i);
      e.run(deadEyes, zombies);
      
      //must be after e.run
      deadEyes = e.getFoodList();
      zombies = e.getZombies();
      
      if(e.position.x >= 1023-Float.parseFloat(sensorReading[1]) && 
         e.position.x <= 1023-Float.parseFloat(sensorReading[1])+100 &&
         e.position.y >= Float.parseFloat(sensorReading[2]) && 
         e.position.y <= Float.parseFloat(sensorReading[2])+100) {
        zombies.remove(i);
      } 
      
      if (e.health <= 0) {
        click.stop();
        click.play();
        zombies.remove(i);
      }
    }
    
    for (int i = eyes.size()-1; i >= 0; i--) {
      Creature e = eyes.get(i);
      e.mMode = mMode;
      e.gMode = gMode;

      eyes = e.senceEnvironment(eyes, i);
      e.run(eyes);
      e.eatZombies(zombies);
      e.dieIfCorpsesNear(deadEyes);
      
      if(e.position.x >= 1023-Float.parseFloat(sensorReading[1]) && 
         e.position.x <= 1023-Float.parseFloat(sensorReading[1])+50 &&
         e.position.y >= Float.parseFloat(sensorReading[2]) && 
         e.position.y <= Float.parseFloat(sensorReading[2])+50) {
        eyes.remove(i);
      }
      
      if (e.health <= 0 || e.countNeighbors(eyes) >= (int)Float.parseFloat(sensorReading[0])+2) {
        click2.stop();
        click2.play();
        eyes.remove(i);
        deadEyes.add(new Food(e.position));
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
  void cleanB() {
    for (int i = eyes.size()-1; i >= 0; i--) {
      eyes.remove(i);
    }
  }
  void cleanW() {
    for (int i = zombies.size()-1; i >= 0; i--) {
      zombies.remove(i);
    }
  }
}

void playRandomInterval(){
    if(soundInterval == 0){
      soundInterval = (int) random(500, 1200);
      fadeaway.play();
    }
    soundInterval--;
  }
