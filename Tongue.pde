
public class Tongue {
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector destination;
  PImage img1;
  int imgSize = 32;
  int r = 32;
  int animSpeed = 3;
  int animCount = (int) random(animSpeed);
  int destCount = 0;

  public Tongue(PVector origin) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(1, 1);
    //friction = 2;
    position = origin.copy();
    setRandomDestination();
    setRandomLook();
  }

  void run(ArrayList<Food> targets) {   
    
    if(targets.size() > 0){
      find(targets);
    }else{
      setDir();
      checkDestination();
    }
    update();
    //borders();
    display();
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(10);
 
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
    switch((int) random(2)) {
      case 0: 
        img1 = loadImage("eye4.png");
        break;   
      default:
        img1 = loadImage("eye4.png");
        break;
    }
  }

  void find(ArrayList<Food> targets){
    
    PVector frc = attract(targets);
    applyForce(frc);
  
  }

  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  void applyForce(PVector force){
    acceleration.add(force);
  }

  PVector attract(ArrayList<Food> targets){
    Food cr = targets.get((int)random(targets.size()));
    //float dist = PVector.dist(cr.position, position);
    PVector diff = PVector.sub(cr.position, position); //vector poiting from position
    diff.normalize();
    diff.mult(3);
    if (diff.mag() > 0) {
        // First two lines of code below could be condensed with new PVector setMag() method
        // Not using this method until Processing.js catches up
        // steer.setMag(maxspeed);
  
        // Implement Reynolds: Steering = Desired - Velocity
        //steer.normalize();
        diff.sub(velocity);
    }

    return diff;
  }

  void setDir(){
    //get direction of destination
    PVector diff = PVector.sub(destination, position);
    //float dist = diff.mag();
    
    //different movements on 
    
    diff.normalize();
    diff.mult(3);
    velocity = diff;
    
    ellipse( destination.x, destination.y, 8, 8);
    println(destination);
  }
  
  void checkDestination(){
    PVector diff = PVector.sub(destination, position);
    float dist = diff.mag();
    if(dist < 10){
      destCount++;
      setRandomVDestination();
    }
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

  ArrayList<Creature> reproduce(ArrayList<Creature> mates, float dist){
    if(destCount % 3 == 0 && destCount != 0){
      if(dist < 10){
        //to stop reproduction 
        destCount = 0;
        println( " im near ");
        mates.add(new Creature(position));
        return mates;
      }
    }
    return mates;
  }
  
  boolean isInArea(float x1, float x2, float y1, float y2){
    if(position.x > x1 && position.x < x2 && position.y > y1 || position.y < y2){
      return true;
    }
    return false;
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
