
public class Creature {
  PVector position;
  PVector velocity;
  PVector acceleration;
  float lifespan;

  public Creature(PVector origin) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(1, 1);
    position = origin.copy();
    lifespan = 150.0;
  }

  void run() {
    update();
    display();
    if(position.x <= 0 || position.x >= width){
      velocity.x = -velocity.x;
    }
    if(position.y <= 0 || position.y >= height){
      velocity.y = -velocity.y;
    }
  }

  // Method to update position
  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    //lifespan -= 1.0;
  }

  // Method to display
  void display() {
    stroke(255, lifespan);
    fill(255, lifespan);
    ellipse(position.x, position.y, 8, 8);
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
