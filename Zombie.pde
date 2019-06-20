
public class Zombie {
  PVector position;
  PVector destination;
  PVector velocity;
  PVector acceleration;
  PImage img1;
  int imgSize = 32;
  int animSpeed = 50;
  int animCount = (int) random(animSpeed);
  int destCount = 0;
  int health = 100;
  int mMode = 1;
  int gMode = 0;
  int me; //my index in mates list
  int born = 0;
  ArrayList<Zombie> others;
  ArrayList<Food> deadEyes;
  int time = 0;

  public Zombie(PVector origin) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(1, 1);
    //friction = 2;
    position = origin.copy();
    setRandomDestination();
    setRandomLook();
  }

  void run(ArrayList<Food> deadEyes, ArrayList<Zombie> others) {   
    this.others = others;
    this.deadEyes = deadEyes;
    
    group(deadEyes);
    update();
    display();
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(10);
    
    boounceOffWalls();
    position.add(velocity);
    
    acceleration.mult(0);
  }

  void display() {
    imageMode(CENTER);
    animCount++;
    if(animCount == animSpeed){
      setRandomLook();
      animCount = 0;
    }
    //tint(255, health+155);
    image(img1, position.x, position.y, imgSize, imgSize);
  }

  //change eye movements
  void setRandomLook(){
    switch((int) random(5)) {
      case 0: 
        img1 = loadImage("eye1.png");
        break;
      case 1: 
        img1 = loadImage("eye2.png");
        break;
      case 2: 
        img1 = loadImage("eye3.png");
        break;
      case 3: 
        img1 = loadImage("eye4.png");
        break;
      default:
        img1 = loadImage("eye5.png");
        break;
    }
  }

  void group(ArrayList<Food> deadEyes){
    
    setDir();
    checkDestination();
    
    //if(destCount % 3 == 0 && destCount != 0){
    PVector frc = attract(deadEyes);
    applyForce(frc);
    //}
    //addTeamMates();
  }

  void addTeamMates(){
    for(int i = 0; i < born; i++){
      others.add(new Zombie(position));
    }
  }
  
  void addTeamMate(){
    others.add(new Zombie(position));
  }
  
  ArrayList<Zombie> getZombies(){
    return others;
  }
  
  ArrayList<Food> getFoodList(){
    return deadEyes;
  }
  
  //void borders() {
  //  if (position.x < -r) position.x = width+r;
  //  if (position.y < -r) position.y = height+r;
  //  if (position.x > width+r) position.x = -r;
  //  if (position.y > height+r) position.y = -r;
  //}

  void applyForce(PVector force){
    acceleration.add(force);
  }

  PVector attract(ArrayList<Food> deadEyes){
    PVector steer = new PVector(0, 0);
    ArrayList<Food> remove = new ArrayList<Food>();
    born = 0;
    
    //SoundFile randomSound = sounds.get((int)random(sounds.size()));
    
    for(Food cr : deadEyes){
      float dist = PVector.dist(cr.position, position);
      if(dist > 0 && dist < 100){
        //vector to neighbor
        PVector diff = PVector.sub(cr.position, position);
        diff.normalize();
        diff.div(dist);
        steer.add(diff);
      }
      if(dist < 10){
        remove.add(cr);
        //born++;
        addTeamMate();
        //randomSound.stop();
        //randomSound.play();
        health-=5;                                                                          //Heath adjucement
      }
    }
    
    deadEyes.removeAll(remove);                                                                          //Remove corpses
    
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.sub(velocity);
    }
    return steer;
  }
  
  //goal for a creature to move
  void setDir(){
    //get direction of destination
    PVector diff = PVector.sub(destination, position);
    //float dist = diff.mag();
    
    //different movements on 
    if(mMode % 2 == 0){
      diff.normalize();
      diff.mult(3);
    }else {
      diff.div(100);
    }
    
    velocity = diff;
    
    
    //to see destination points
    //ellipse( destination.x, destination.y, 8, 8);
  }
  
  //check distance to the goal
  void checkDestination(){
    PVector diff = PVector.sub(destination, position);
    float dist = diff.mag();
    if(dist < 10){
      destCount++;
      health-=10;                                                                          //Heath adjucement
    }
    if(dist < 10){
      setRandomVDestination();
      imgSize++;
    }
  }
  
  void boounceOffWalls(){
    if(position.x < 0 || position.x > width-9){
      velocity.x = -velocity.x;
      setRandomDestination();
    }
    if(position.y < 0 || position.y > height-9){
      velocity.y = -velocity.y;
      setRandomDestination();
    }
  }
  
  void boounceOffArea(float x1, float x2, float y1, float y2){
    if(isInArea( x1, x2, y1, y2)){
      velocity.x = -velocity.x;
      velocity.y = -velocity.y;
      
      //choose new location that is in boundaries
      setRandomDestination();
    }
  }
  
  boolean isInArea(float x1, float x2, float y1, float y2){
    if(position.x > x1 && position.x < x2 && position.y > y1 || position.y < y2){
      return true;
    }
    return false;
  }
  
  void setRandomVDestination(){
    destination = new PVector(random(-50, 50), random(-50, 50));
    destination.normalize();
    destination.mult(250);
    destination = PVector.add(position, destination);
  }
  
  void setRandomDestination(){
    destination = new PVector(random(50, width-50), random(50, height-50));
  }
  
  void setDestination(int x, int y){
    destination = new PVector(x, y);
  }
  
  int countNeighbors(ArrayList<Creature> others){
    int count = 0;
    for(Creature cr : others){
      float dist = PVector.dist(cr.position, position);
      if(dist > 0 && dist < 100){
        count++;
      }
    }
    return count;
  }
}
