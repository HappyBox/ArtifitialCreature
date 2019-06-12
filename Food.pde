
public class Food {
  PVector position;
  PImage img1;
  int imgSize = 20;

  public Food(PVector origin) {
    position = origin.copy();
    img1 = loadImage("eye3.png");
  }

  void run() {   
    display();
  }
  
  void display() {
    imageMode(CENTER);
    image(img1, position.x, position.y, imgSize, imgSize);
  }
}
