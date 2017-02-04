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

  import processing.sound.*;
  SoundFile sound;

  drammar_phrase(DrammarScreen screen, String name, String text, int verticalPosition, float fadeTime, SoundFile soundFile)
  {
    f = loadFont("data/" + font_name);
    this.screen = screen;
    this.name = name + ": ";
    this.text = text;
    this.verticalPosition = verticalPosition;  
    this.fadeTime = fadeTime;
    this.sound = soundFile;
  }

  void Update()
  {
    textFont(f);
    stroke(230, 230, 230);
    textAlign(LEFT);

    if (name.length() > 2)
    {
      fill(230, 30, 30, alpha);
      text(name, 10, verticalPosition);
    }

    fill(0, 0, 0, alpha);
    text(text, textWidth(name) + 15, verticalPosition);
    println(alpha);
    if ((multiplier > 0 && alpha == 255) || (multiplier < 0 && alpha == 0))
      return;
    if (alpha <= 255 && alpha >= 0) {
      float prealpha = alpha;
      alpha += multiplier * (drammar_play.frameR * 255 / fadeTime);
      println(alpha - prealpha);
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

  void FadeOut()
  {
    multiplier = -1;
  }
}