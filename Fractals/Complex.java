/* Copyright (c) 2009 the authors listed at the following URL, and/or
the authors of referenced articles or incorporated external code:
http://en.literateprograms.org/Complex_numbers_(Java)?action=history&offset=20090126143509

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Retrieved from: http://en.literateprograms.org/Complex_numbers_(Java)?oldid=16044
*/

public class Complex {
    public Complex () {
      this.re = 0;
      this.im = 0;
    }
    
    public Complex(double re, double im) {
      this.re = re;
      this.im = im;
    }
    
    public Complex(Complex input) {
      this.re = input.getRe();
      this.im = input.getIm();
    }

    public double getRe() {
      return this.re;
    }
    
    public double getIm() {
      return this.im;
    }

    public void setRe(double re) {
      this.re = re;
    }
    
    public void setIm(double im) {
      this.im = im;
    }   

    public Complex add(Complex op) {
      Complex result = new Complex();
      result.setRe(this.re + op.getRe());
      result.setIm(this.im + op.getIm());
      return result;
    }
    
    public Complex sub(Complex op) {
      Complex result = new Complex();
      result.setRe(this.re - op.getRe());
      result.setIm(this.im - op.getIm());
      return result;
    }
    
    public Complex mul(Complex op) {
      Complex result = new Complex();
      result.setRe(this.re * op.getRe() - this.im * op.getIm());
      result.setIm(this.re * op.getIm() + this.im * op.getRe());
      return result;
    }

    public Complex div(Complex op) {
      Complex result = new Complex(this);
      result = result.mul(op.getConjugate());
     double opNormSq = op.getRe()*op.getRe()+op.getIm()*op.getIm();
      result.setRe(result.getRe() / opNormSq);
      result.setIm(result.getIm() / opNormSq);
      return result;
    }

    public Complex fromPolar(double magnitude, double angle) {
      Complex result = new Complex();
      result.setRe(magnitude * Math.cos(angle));
      result.setIm(magnitude * Math.sin(angle));
      return result;
    }

    public double getNorm() {
      return Math.sqrt(this.re * this.re + this.im * this.im);
    }
    
    public double getAngle() {
      return Math.atan2(this.im, this.re);
    }

    public Complex getConjugate() {
      return new Complex(this.re, this.im * (-1));
    }
  
    public String toString() {
      if (this.re == 0) {
        if (this.im == 0) {
          return "0";
        } else {
          return (this.im + "i");
        }
      } else {
        if (this.im == 0) {
          return String.valueOf(this.re);
        } else if (this.im < 0) {
          return(this.re + " " + this.im + "i");
        } else {
          return(this.re + " +" + this.im + "i");
        }
      }
    }

    private double re;
    private double im;

    public static void main(String argv[]) {
      Complex a = new Complex(3, 4);
      Complex b = new Complex(1, -100);
      System.out.println(a.getNorm());
      System.out.println(b.getAngle());
      System.out.println(a.mul(b));
      System.out.println(a.div(b));
      System.out.println(a.div(b).mul(b));
    }

}

