

class Image {

  PImage altImg, origImg;
  Seams seams;

  public Image(String filename) {
    origImg = loadImage(filename); 
    altImg = origImg.copy();
    altImg.loadPixels(); 
    seams = new Seams(altImg.width, altImg.height);
    
    seams.shrinkImage(altImg.pixels, 5000);

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