class CMYK_Colour {

 color cmykConvert(float c, float m, float y, float k){
    c = c/100.0;
    m = m/100.0;
    y = y/100.0;
    k = k/100.0;
   
    float nc = (c * (1-k) + k);
    float nm = (m * (1-k) + k);
    float ny = (y * (1-k) + k);
   
    //println(nc+"\t"+nm+"\t"+ny);
   
    float r = (1-nc) * 255;
    float g = (1-nm) * 255;
    float b = (1-ny) * 255;
   
    //println(r+"\t"+g+"\t"+b);
    return color(r, g, b);
  }

}       

