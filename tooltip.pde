


// Class to display a tooltip in a semi-transparent rectangle. 

class ToolTip{
  // main variables
  String mText; // text of the tooltip
  int x; // x coordinate
  int y; // y coordinate
  String lines[]; // lines in which the text is broken for the tooltip display
  
  boolean doClip = true; // ??? 
  int myWidth; // width of the text
  int fontSize = 12; // 16; size of the tooltip font
  int totalHeight = 0; // height of the text
  int rectWidthMargin; // margin in width
  int rectHeightMargin; // margin in height
  int shadowOffset = 8; // ??? 
  color tbackground = color(60, 60, 60, 10); // color(80,150,0,200);  
  PFont ttfont;
  
  PImage clip = null; int clipx; int clipy; // the background image and its coordinates
  
  // **** DEFINITION OF THE TOOLTIP OBJECT ****
  ToolTip(int _x, int _y, String tttext){
    x = _x; y = _y; mText = tttext;
    ttfont = createFont("SansSerif", 12, true); // createFont("Arial", 20, true); // textFont(ttfont,fontSize);
    // ttfont = loadFont("SansSerif-12.vlw"); 
    // textFont(ttfont);
    // Figure out text size... font metrics don't seem quite right, at least on Chrome
    // String lines[] = split(mText,"\n");
    lines = split_string_into_lines (mText, 50);
    int maxWidth = 0;
    totalHeight = 0;
    for(int i = 0; i < lines.length;i++){
      totalHeight += fontSize;
      String line = lines[i];
      myWidth = (int) textWidth(line);
      if (int(myWidth) > int(maxWidth)){maxWidth = myWidth;}
    }
    totalHeight += fontSize;
    myWidth = int(maxWidth);    
  }
  
  void setBackground(color c){
    tbackground = c;
  }
  
  void restoreClip(){
    imageMode(CORNER);
    image(clip,clipx,clipy);
  }
  
  void hide(){
    restoreClip();
  }
  
  // draw balloons with text
  void drawBalloon(int x, int y, int w, int h){
    w = int(w);
    h = int(h);
    rectWidthMargin = int(w*(10/64));
    rectHeightMargin = int(h*(10/64));

    fill(tbackground);
    noStroke();
    rectMode(CORNER);
    rect(x,y, w+rectWidthMargin, h+rectHeightMargin);
    fill(0);
    for (int i=0; i<lines.length; i++) {
      textAlign(LEFT); textFont(ttfont);
      text(lines[i],x,y+(i+1)*fontSize);
    }
  }
        
  void display(){ // display the tooltip  // STUDENT
    if (mText.equals("L'Angelo e l'Adele si incontrano intorno alla cava per amoreggiare e pianificare il matrimonio.")) {
      launch("/Users/vincenzolombardo/Documents/Processing3/sketch_Arialda_example/application.macosx/sketch_Arialda_example.app");
    }
    if (mText.equals("Il Lino e l'Eros si incontrano alla cava perché Eros deve informare Lino di qualcosa, ma finisce per mandarlo a casa.")) {
      inc02.play();
      imageMode(CENTER); image(inc02, width/2, height/2); 
    }

    if ((clip != null) && (doClip)){restoreClip();} 
    // x and y are mouse coordinates: determine where tip should be relative to mouse position              
    int bx = int(x+5);
    int by = int(y-totalHeight);    
    int rectRight = bx+myWidth ; //  +20;
    int rectTop = by-totalHeight; // +lines.length +30;
    
    rectWidthMargin = int(myWidth*(10/64));
    rectHeightMargin = int(totalHeight*(10/64));
    
    if (rectRight >= width){
      bx = int(x-5-myWidth-rectWidthMargin); 
    }      
    if (rectTop <= 0){
      by = int(y+totalHeight+rectHeightMargin);
    }  
        
    // Grab whatever is going to be behind our tooltip...
    imageMode(CORNER);
    clip = get(bx-20,by-20,myWidth+rectWidthMargin+60,totalHeight+rectHeightMargin+60);
    clipx = bx-20;
    clipy = by-20;    
    //bx = x+10;
    //by = y - totalHeight;
    drawBalloon(bx,by-fontSize,myWidth,totalHeight);  
    // }
  } // END METHOD display

} // END CLASS ToolTip

String[] split_string_into_lines (String s, int line_size) {
  println("s = " + s); 
  // extract all the original lines, according to RETURNs
  String original_lines[] = split(s,"\n");
  String actual_lines1[] = new String[s.length()];
  // count actual lines: for each line, split the string according to BLANKs, then split into words, count characters
  int line_count = 0; 
  for (int i = 0; i < original_lines.length; i++) {
    String[] words = split (original_lines[i], " "); 
    int j = 0; 
    // println("number of words = " + words.length);
    while (j < words.length) { 
      int total_chars = 0; String s_aux = "";
      while (j < words.length && total_chars + words[j].length() < line_size) {
        total_chars = total_chars + 2*words[j].length() +1 ; s_aux = s_aux + " " + words[j]; j++; s_aux = s_aux + " ";
      } // while char under single line size
      actual_lines1[line_count] = s_aux; line_count++;  
    } // END while all the words
  } // END for each line
  // fill actual lines to be returned
  String[] actual_lines = new String[line_count]; 
  for (int k = 0; k < line_count; k++) {
    actual_lines[k] = actual_lines1[k];
  } // END for each line
  return actual_lines; 
}