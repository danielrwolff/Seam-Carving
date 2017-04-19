
Image img;

final int IMG_WIDTH = 1350;//1296
final int IMG_HEIGHT = 900;//864

void settings() {
  size(IMG_WIDTH, IMG_HEIGHT); 
}

void setup() {
  
  int now = millis();
  img = new Image("landscape.jpg");
  println(millis() - now);
}

void draw() {
  
  image(img.getAltImage(), 5, 5);
  
}