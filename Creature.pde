
public class Creature {
  PVector position;
  PVector destination;
  PVector velocity;
  PVector acceleration;
  int friction;
  float lifespan;
  PImage img1;
  int imgSize = 32;
  int animSpeed = 50;
  int animCount = (int) random(animSpeed);
  int destCount = 0;
  int age = 0;

  public Creature(PVector origin) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(1, 1);
    //friction = 2;
    position = origin.copy();
    setRandomDestination();
    
    setRandomLook();
  }

  void run() {
    destination();
    checkDistToDest();
    update();
    display();
  }
  
  //create new creature when parent creature visit 3 destinations
  ArrayList<Creature> reproduceIfNear(ArrayList<Creature> mates, int me){
    if(destCount % 3 == 0 && destCount != 0){
      destCount = 0;
      for(int i = 0; i < mates.size()-1; i++){
        if(i != me){
          PVector diff = PVector.sub(mates.get(i).position, position);
          float dist = diff.mag();
          if(dist < 100){
            println(i + " im near");
            mates.add(new Creature(position));
            return mates;
          }
        }
      }
    }
    return mates;
  }
  
  void setRandomDestination(){
    destination = new PVector(random(50, width-50), random(50, height-50));
  }
  
  //goal for a creature to move
  void destination(){
    PVector diff = PVector.sub(destination, position);
    //float dist = diff.mag();
    diff.div(100);
    velocity = diff;
    //to see destination points
    //ellipse( destination.x, destination.y, 8, 8);
  }
  
  //check distance to the goal
  void checkDistToDest(){
    PVector diff = PVector.sub(destination, position);
    float dist = diff.mag();
    if(dist < 10){
      setRandomDestination();
      destCount++;
      age++;
    }
  }
  
  // Method to update position
  void update() {
    //velocity.add(acceleration);
    if(position.x < 0 || position.x > width-9){
      velocity.x = -velocity.x;
    }
    if(position.y < 0 || position.y > height-9){
      velocity.y = -velocity.y;
    }
    position.add(velocity);
    //lifespan -= 1.0;
  }

  // Method to display
  void display() {
    imageMode(CENTER);
    animCount++;
    if(animCount == animSpeed){
      setRandomLook();
      animCount = 0;
    }
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

  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
