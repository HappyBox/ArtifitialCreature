
public class Food {
  PVector position;
  PImage img1;
  int imgSize = 20;

  public Food(PVector origin) {
    position = origin.copy();
    img1 = loadImage("eyeD.png");
  }

  void run() {   
    display();
  }
  
  void display() {
    imageMode(CENTER);
    tint(255, 155);
    image(img1, position.x, position.y, imgSize, imgSize);
    tint(255, 255);  //apply tint just to this
  }
}
