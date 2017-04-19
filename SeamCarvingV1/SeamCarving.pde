
import java.util.PriorityQueue;
import java.util.Iterator;

class Seams {

  int pixWidth, pixHeight;
  int[] weights;
  byte[] pixTo; 
  
  private class Seam implements Comparable<Seam>{
    
    int weight;
    int index;
    public Seam(int w, int i) {
      weight = w;
      index = i;
    }
    
    public int compareTo(Seam other) {
       if (weight > other.weight) return 1;
       else if (weight < other.weight) return -1;
       else return 0;
    }
    
  }
  
  public Seams(color[] pix, int w, int h) {
    setWidth(w);
    setHeight(h);

    calcWeights(pix);
  }

  private void calcWeights(color[] pix) {
    
    weights = new int[pixWidth*pixHeight];
    pixTo = new byte[pixWidth*pixHeight];

    //loadPixels();
    
    // Set up the first row of weights with the gradient from black to the pixels color.
    for (int i = 0; i < pixWidth; i++) weights[i] = calcGrad(color(0,0,0), pix[i]);
    
    
    for (int y = 1; y < pixHeight; y++)
      for (int x = 0; x < pixWidth; x++) {
        int bestWeight = Integer.MAX_VALUE;
        int bestDir = 0;
        
        int _w = Integer.MAX_VALUE, w = Integer.MAX_VALUE, w_ = Integer.MAX_VALUE;
        
        
        if (x > 0) _w = calcGrad(pix[y*pixWidth + x], pix[(y-1)*pixWidth + x-1]) + weights[(y-1)*pixWidth + x-1];
        w = calcGrad(pix[y*pixWidth + x], pix[(y-1)*pixWidth + x]) + weights[(y-1)*pixWidth + x];
        if (x < pixWidth) w_ = calcGrad(pix[y*pixWidth + x], pix[(y-1)*pixWidth + x+1]) + weights[(y-1)*pixWidth + x+1];
        
        if (bestWeight > w) {
          bestWeight = w;
          bestDir = 0;
        }
        if (bestWeight > _w) {
           bestWeight = _w;
           bestDir = -1;
        }
        if (bestWeight > w_) {
          bestWeight = w_;
          bestDir = 1;
        }
        
        weights[y*pixWidth + x] = bestWeight;
        pixTo[y*pixWidth + x] = (byte) (bestDir*-1);
        /*
        switch(pixTo[y*pixWidth + x]) {
          case -1: pixels[y*pixWidth + x] = color(255,0,0); break;
          case 0: pixels[y*pixWidth + x] = color(0,255,0); break;
          case 1: pixels[y*pixWidth + x] = color(0,0,255); break;
        }
        */
      }
    
    PriorityQueue<Seam> q = new PriorityQueue<Seam>(10);
    
    for (int i = 0; i < pixWidth; i++) {
      q.add(new Seam(weights[pixWidth*(pixHeight-1) + i], pixWidth*(pixHeight-1) + i));
    }
    
    //Iterator<Seam> iter = q.iterator();
    
    int count = 0;
    while(count < 1) {
      count++;
      int x = q.poll().index;
      for (int y = pixHeight-1; y > -1 && x > 0; y--) {
        //pix[x] = color(255,0,0);
         shiftPixels(pix, x%pixWidth, x/pixWidth);
         x += pixTo[x];
         x -= pixWidth;
      }
    }
    //updatePixels();
        
  }

  private void shiftPixels(color[] pix, int x, int y) {
    if (x == pixWidth-1) pix[y*pixWidth + x] = color(255,0,0,0);
    else {
      pix[y*pixWidth + x] = pix[y*pixWidth + x+1];
      shiftPixels(pix, x+1, y);
    }
  }

  private int calcGrad(color p, color q) {
     int sum = (int) (abs(red(p) - red(q)) + abs(green(p) - green(q)) + abs(blue(p) - blue(q)));
     return (int) map(sum, 0, 255*3, 0, 255);
  }

  public void setWidth(int w) { 
    pixWidth = w;
  }
  public void setHeight(int h) { 
    pixHeight = h;
  }
}