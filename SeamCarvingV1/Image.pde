

class Image {

  PImage altImg, origImg;
  Seams seams;

  public Image(String filename) {
    origImg = loadImage(filename); 
    altImg = origImg.copy();
    altImg.loadPixels(); 
    seams = new Seams(altImg.pixels, altImg.width, altImg.height);
    altImg.updatePixels();
  }

  public void update() {
    altImg.updatePixels();
  }




  // Return the altered image.
  public PImage getAltImage() { 
    return altImg;
  }
  
  // Return the original image.
  public PImage getOrigImage() { 
    return origImg;
  }
}