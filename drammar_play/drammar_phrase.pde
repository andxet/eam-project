 //<>//
class drammar_phrase {
  static final String font_name = "HelveticaNeue-30.vlw";
  PFont f;
  DrammarScreen screen;
  String name;
  String text;
  int verticalPosition;
  float alpha = 0;
  float fadeTime;
  float multiplier = 1;
  boolean centered = false;

  import processing.sound.*;
  SoundFile sound;

  //Constructor//////////////////
  drammar_phrase(DrammarScreen screen, String name, String text, int verticalPosition, float fadeTime, SoundFile soundFile)
  {
    f = loadFont("data/" + font_name);
    this.screen = screen;
    if (name.length() > 0)
      this.name = name + ": ";
    this.text = text;
    this.verticalPosition = verticalPosition;  
    this.fadeTime = fadeTime;
    this.sound = soundFile;
  }

  //centered
  drammar_phrase(DrammarScreen screen, String name, String text, int verticalPosition, float fadeTime, SoundFile soundFile, boolean centered)
  {
    f = loadFont("data/" + font_name);
    this.screen = screen;
    if (name.length() > 0)
      this.name = name + ": ";
    this.text = text;
    this.verticalPosition = verticalPosition;  
    this.fadeTime = fadeTime;
    this.sound = soundFile;
    this.centered = centered;
  }

  //////////////////////////////
  void Update()
  {
    //Set the lenght of the name in a static variable so that next phrases can use it
    if (this.name != null && this.name.length() > 0)
    {
      drammar_play.leftMargin = (int)textWidth(this.name);
    }    

    textFont(f);
    stroke(230, 230, 230);
    if (centered)    
      textAlign(CENTER);
    else
      textAlign(LEFT);

    //Show the name if present
    if (name != null)
    {
      fill(230, 30, 30, alpha);
      text(name, 10, verticalPosition);
    }

    //Show the phrase
    fill(0, 0, 0, alpha);
    if (centered)    
      text(text, width/2, verticalPosition);
    else
      text(text, drammar_play.leftMargin + 15, verticalPosition);

    //Manage the fade in/out
    if ((multiplier > 0 && alpha == 255) || (multiplier < 0 && alpha == 0))
      return;
    //if is fading...
    if (alpha <= 255 && alpha >= 0) {
      alpha += multiplier * (drammar_play.frameR * 255 / fadeTime);
      if (alpha > 255)
      {
        alpha = 255;
        screen.EndFadeIn();
        if (sound != null)
          sound.play();
      }
      if (alpha < 0)
      {
        alpha = 0;  
        screen.EndFadeOut();
      }
    }
  }

  /////////////////////////////
  void FadeOut()
  {
    multiplier = -1;
  }
}