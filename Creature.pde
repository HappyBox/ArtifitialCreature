
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
  int age = 255;
  int mMode = 0;
  int gMode = 0;
  ArrayList<Creature> mates;
  int me; //my index in mates list

  public Creature(PVector origin) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(1, 1);
    //friction = 2;
    position = origin.copy();
    setRandomDestination();
    
    setRandomLook();
  }

  void run() {
    calcDir();
    
    //set new random destination if near destination
    checkDestination();
    update();
    display();
  }
  
  //create new creature when parent creature visit 3 destinations
  ArrayList<Creature> senceEnvironment(ArrayList<Creature> mates, int me){
    
    for(int i = 0; i < mates.size()-1; i++){
      if(i != me){
        //get distance
        PVector diff = PVector.sub(mates.get(i).position, position);
        float dist = diff.mag();
        
        //if(dist < 300 && dist > 100){
        //  //to stop reproduction 
        //  destination = mates.get(i).position;
        //} else if(dist <= 100) {
        //  //dont move
        //  //destination = position;
        //}else{
        //  setRandomDestination();
        //}
        
        if(destCount % 3 == 0 && destCount != 0){
          if(dist < 10){
            //to stop reproduction 
            destCount = 0;
            println(me + " im near " + i);

            mates.add(new Creature(position));
            return mates;
          }
        }
      }
    }
    return mates;
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
  
  void updateMatesList(ArrayList<Creature> mates, int me){
    this.mates = mates;
    this.me = me;
  }
  
  //goal for a creature to move
  void calcDir(){
    
    //get direction of destination
    PVector diff = PVector.sub(destination, position);
    float dist = diff.mag();
    if(mMode % 2 == 0){
      diff.normalize();
      diff.mult(3);
    }else {
      diff.div(100);
    }
    //diff.div(100);
    velocity = diff;
    
    
    //to see destination points
    //ellipse( destination.x, destination.y, 8, 8);
  }
  
  //check distance to the goal
  void checkDestination(){
    PVector diff = PVector.sub(destination, position);
    float dist = diff.mag();
    if(dist < 10){
      if(gMode % 2 == 0){
        setRandomVDestination();
      }else{
        //goInline();
      }
      destCount++;
      age-=40;
    }
  }
  
  void goInline(){
    if(me != 0){
      destination = mates.get(me-1).position;
    }else{
      setRandomVDestination();
    }
  }
  // Method to update position
  void update() {
    
    velocity.add(acceleration);
    if(position.x < 0 || position.x > width-9){
      velocity.x = -velocity.x;
      setRandomDestination();
    }
    if(position.y < 0 || position.y > height-9){
      velocity.y = -velocity.y;
      setRandomDestination();
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
    //tint(255 - age, 255 - age, 255 - age);
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
