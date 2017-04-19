
Image img;

final int IMG_WIDTH = 965;//415
final int IMG_HEIGHT = 390;//250

void settings() {
  size(IMG_WIDTH, IMG_HEIGHT); 
}

void setup() {
  
  int now = millis();
  //img = new Image("landscape2.png");
  //img = new Image("landscape3.png");
  img = new Image("beach.png");
  println(millis() - now);
}

void draw() {
  
  image(img.getAltImage(), 0, 0);
  
}