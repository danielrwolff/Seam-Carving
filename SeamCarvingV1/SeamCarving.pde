
import java.util.PriorityQueue;
import java.util.Stack;

class Seams {

  int pixWidth, pixHeight;
  int[] weights;
  byte[] pixTo; 

  PriorityQueue<Seam> q;
  Stack<Seam> seamsRemoved;

  private class Seam implements Comparable<Seam> {

    int weight, start, end;

    public Seam(int w, int s, int e) {
      weight = w;
      start = s;
      end = e;
    }

    public int compareTo(Seam other) {
      if (weight > other.weight) return 1;
      else if (weight < other.weight) return -1;
      else return 0;
    }

    public boolean collidesWith(Seam other) {
      return start == other.start || end == other.end;
    }
    
    public String toString() { return "WEIGHT: " + weight + "\t START: " + start + " ("+ (start%pixWidth) + ")\t END: " + end; }
  }

  public Seams(int w, int h) {
    setWidth(w);
    setHeight(h);

    q = new PriorityQueue<Seam>();
    seamsRemoved = new Stack<Seam>();
  }

  private void calcWeights(color[] pix) {

    weights = new int[pixWidth*pixHeight];
    pixTo = new byte[pixWidth*pixHeight];

    //loadPixels();

    // Set up the first row of weights with the gradient from black to the pixels color.
    for (int i = 0; i < pixWidth; i++) weights[i] = calcGrad(color(0, 0, 0), pix[i]);

    for (int y = 1; y < pixHeight; y++)
      for (int x = 0; x < pixWidth; x++) {
        int bestWeight = calcGrad(pix[y*pixWidth + x], pix[(y-1)*pixWidth + x]) + weights[(y-1)*pixWidth + x];
        int bestDir = 0;

        int _w = Integer.MAX_VALUE, w_ = Integer.MAX_VALUE;

        if (x > 0) _w = calcGrad(pix[y*pixWidth + x], pix[(y-1)*pixWidth + x-1]) + weights[(y-1)*pixWidth + x-1];
        if (x < pixWidth-1) w_ = calcGrad(pix[y*pixWidth + x], pix[(y-1)*pixWidth + x+1]) + weights[(y-1)*pixWidth + x+1];

        if (bestWeight > _w) {
          bestWeight = _w;
          bestDir = -1;
        }
        if (bestWeight > w_) {
          bestWeight = w_;
          bestDir = 1;
        }

        weights[y*pixWidth + x] = bestWeight;
        pixTo[y*pixWidth + x] = (byte) bestDir;
        /*
        switch(pixTo[y*pixWidth + x]) {
         case -1: pixels[y*pixWidth + x] = color(255,0,0); break;
         case 0: pixels[y*pixWidth + x] = color(0,255,0); break;
         case 1: pixels[y*pixWidth + x] = color(0,0,255); break;
         }
         */
      }

    // Add the seams to the priority queue for processing.
    for (int i = 0; i < pixWidth; i++) {
      q.add(new Seam(weights[pixWidth*(pixHeight-1) + i], pixWidth*(pixHeight-1) + i, findEndofSeam(pixWidth*(pixHeight-1) + i)));
    }

    /*
    Seam s = q.poll();
     int x = s.start;
     for (int y = pixHeight-1; y > -1 && x > 0; y--) {
     pix[x] = color(255,0,0);
     x += pixTo[x];
     x -= pixWidth;
     }
     pix[s.end] = color(0,255,0);
     */
  }

  public void shrinkImage(color[] pix, int r) {
    seamsRemoved.clear();

    int numRemovals = r;

    while (r > 0) {
      if (q.isEmpty()) {
        println("RECALCULATING");
        calcWeights(pix);
        seamsRemoved.clear();
      }
      
      Seam cur = q.poll();
      boolean skip = false;
      for (Seam s : seamsRemoved) 
        if (cur.collidesWith(s)) {
          skip = true;
          break;
        }
        
      if (!skip) {
        println(r + " : " + cur);
        seamsRemoved.push(cur);
        deletePixels(pix, cur);
        r--;
      }
    }
  }

  private void deletePixels(color[] pix, Seam s) {
    int x = s.start;
    for (int y = pixHeight-1; y > -1 && x > 0; y--) {
      
      int shift = x%pixWidth;
      while (shift < pixWidth) {
        if (shift == pixWidth-1) pix[y*pixWidth + shift] = color(255, 0, 0, 0);
        else pix[y*pixWidth + shift] = pix[y*pixWidth + shift+1];
        shift++;
      }
      
      //pix[x] = color(255,0,0);
      x += pixTo[x];
      x -= pixWidth;
    }
    //setWidth(pixWidth-1);
  }

  private int findEndofSeam(int start) {
    for (int y = pixHeight-1; y > -1; y--) {
      if (start - pixWidth > 0) {
        start += pixTo[start];
        start -= pixWidth;
      } else break;
    }
    return start;
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