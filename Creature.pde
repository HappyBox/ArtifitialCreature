
public class Creature {
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
  int neighbors = 0;

  public Creature(PVector origin) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(1, 1);
    //friction = 2;
    position = origin.copy();
    setRandomDestination();
    setRandomLook();
  }

  void run(ArrayList<Creature> mates) {   
    
    group(mates);
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
    tint(255, health+155);
    image(img1, position.x, position.y, imgSize, imgSize);
  }

  //change eye movements
  void setRandomLook(){
    switch((int) random(4)) {
      case 0: 
        img1 = loadImage("eyeA.png");
        break;
      case 1: 
        img1 = loadImage("eyeB.png");
        break;
      case 2: 
        img1 = loadImage("eyeC.png");
        break;
      default:
        img1 = loadImage("eyeD.png");
        break;
    }
  }

  void group(ArrayList<Creature> others){
    
    
    setDir();
    checkDestination();
    
    if(destCount % 3 == 0 && destCount != 0){
      PVector frc = attract(others);
      applyForce(frc);
    }
  
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

  PVector attract(ArrayList<Creature> others){
    PVector steer = new PVector(0, 0);
    
    for(Creature cr : others){
      float dist = PVector.dist(cr.position, position);
      if(dist > 0 && dist < 200){
        //vector to neighbor
        PVector diff = PVector.sub(cr.position, position);
        diff.normalize();
        diff.div(dist);
        steer.add(diff);
      }
    }
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




  //create new creature when parent creature visit 3 destinations
  ArrayList<Creature> senceEnvironment(ArrayList<Creature> mates, int me){
    
    for(int i = 0; i < mates.size()-1; i++){
      if(i != me){
        //get distance between eyes
        PVector diff = PVector.sub(mates.get(i).position, position);
        float dist = diff.mag();
        
        mates = reproduce(mates, dist);
        
        
      }
    }
    return mates;
  }
  
  ArrayList<Creature> reproduce(ArrayList<Creature> mates, float dist){
    if(destCount % 3 == 0 && destCount != 0){
      if(dist < 10){
        //to stop reproduction 
        destCount = 0;
        println(me + " im near ");
        mates.add(new Creature(position));
        return mates;
      }
    }
    return mates;
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
      health-=10;
    }
    
    if(gMode % 2 == 0){
      if(dist < 10){
        setRandomVDestination();
      }
    }else{
      if(dist < 200){
        spread();
      }
    }
  }
  
  void spread(){
    //if(me != 0){
    //  destination = mates.get(me-1).position;
    //}else{
    //  setRandomVDestination();
    //}
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
