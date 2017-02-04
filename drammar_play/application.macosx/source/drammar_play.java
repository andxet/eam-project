import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 
import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class drammar_play extends PApplet {

static final String data_folder = "data/"; //<>//
static final String xml_file = "inc_25.xml";
static final String sound_folder = "sound/";
static final String images_folder = "images/";
static final String music_folder = "music/";
static final String loop_name = "";
static final String background_name = "stireria2_bak.jpg";
static float frameR = 0;
static int leftMargin;



Minim minim;
AudioPlayer loop;

AudioPlayer steps;
AudioPlayer punch;
AudioPlayer punch2;
AudioPlayer broom;
AudioPlayer coffin;
AudioPlayer laugh;
AudioPlayer photo;


ArrayList<DrammarScreen> screens = new ArrayList();
int currentScreen = 0;

float lastFrame = 0;
static drammar_play Instance;

int alphaValue = 0;
drammar_phrase phrase;

PImage background;

/*L\u2019ARIALDA Destino? Ma se destino \u00e8, si tratta del destino porco che m'\u00e8 venuto addosso da quando quella li ha avuto la bell'idea di mettermi al mondo!
 L\u2019ALFONSINA Arialda!
 L'ARIALDA Arialda, cosa? Perch\u00e9, a me, che regali m'ha mai fatto la vita da quando ho aperto gli occhi? Avanti! (Una pausa) Destino, s\u00ec! Ma chiamatelo calore, che \u00e8 meglio! Almeno si sa prima di cominciare, dove si deve sbattere!
 L'ALFONSINA Arialda! Adesso, basta!
 L'ARlALDA Calore, cara la mia mamma! Calore! Mica a tutte capita d'aver come spasimante una pasta molle com'\u00e8 capitato a me! Uno che ha cominciato a muoversi
 solo dopo che gli han dato i santissimi! Ci son anche quelli che bollono!
 L'ALFONSINA Ma, senti, Eros, te l'ha proprio detto chiaro?
 L'EROS Chiaro? Chiarissimo.
 L'ARIALDA E cosa t'aspettavi, le mezzemisure da quel maiale l\u00e0, che quel che ha, e per cui gli giran intorno anche le vedove dell'Africa, se l'\u00e8 fatto succhiando il sangue della povera gente come noi? La terrona! S\u00ec, perch\u00e9 io avr\u00f2 paura d'una povera scema come quella vedova l\u00e0!
 L'ALFONSINA E che tipo \u00e8, poi?
 L'ARlALDA Sar\u00e0 calda anche lei! Perch\u00e9, qui, ormai, si va avanti a furia di gradi! (Avvicinandosi alla credenza e fissando la fotografia del Luigi) Ma se credi d'aver vinto la partita e d'essermi tornato addosso un'altra volta ... Senti, parlo conte! Ah, ecco! Se credi cos\u00ec, ti sbagli! Prima d'impalmare quella l\u00e0, i conti, il Candidezza, dovr\u00e0 farli con me! Capito? E va' pur avanti a ridere, che tanto 'sta faccia qui ce l'avevi anche quando i becchini t\u2019han saldato il coperchio! Ah, ecco! Perch\u00e9 almeno quello lo sapr\u00f2! "Pare che ride ... "; siccome, conciato com'eri, non potevano dire che parevi un angelo. Ma io, prima di tornar sotto la tua grinfia, quella porca l\u00e0 gliela strappo di mano con la mia. Capito? E non mi fermer\u00f2 davanti a niente! E pi\u00f9 tu andrai avanti a smangiarmi la coscienza e la carne, e pi\u00f9 andr\u00f2 avanti io! 
 L'ALFONSINA Arialda... 
 L'ARIALDA Beh? Cosa c'\u00e8 da guardarmi con quella faccia l\u00ec? Cosa vi siete messi in testa, che son diventata matta? Volete vedere che valore do pi\u00f9, io, a un povero scemo come questo. (Getta a terra la fotografia): Zero! Zero assoluto!
 L'ALFONSINA Arialda\u2026
 L'ARIALDA E adesso qui la scopa, qui la scopa che lo mandiamo fuori del tutto!*/


/////////////////////////////////////////
public void setup()
{
  Instance = this;

  //HD Ready
  background = loadImage(data_folder + images_folder + background_name);

  minim = new Minim(this);

  loop = minim.loadFile(music_folder + "loop.wav");
  steps = minim.loadFile(sound_folder + "steps.wav");
  punch = minim.loadFile(sound_folder + "pugno.wav");
  punch2 = minim.loadFile(sound_folder + "pugno.wav");//dumb way to play this sound two times (i have no more time)
  broom = minim.loadFile(sound_folder + "broom-sweeping.wav");
  coffin = minim.loadFile(sound_folder + "closing-coffin.wav");
  laugh = minim.loadFile(sound_folder + "woman-laugh.wav");
  photo = minim.loadFile(sound_folder + "photo-throwing.wav");

  tint(255, 126);
  background.resize(1024, 768);

  DrammarScreen aScreen = new DrammarScreen(5, 300);
  aScreen.AddPhrase("", "L'Arialda\n\n\n\n\n", null, true);
  aScreen.AddPhrase("Scena INC_25", "L'Arialda fa una filippica contro il mondo e giura vendetta.", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(5, 350);
  aScreen.AddPhrase("ARIALDA", "Destino?", /*suono pugno*/punch);
  aScreen.AddPhrase("", "Ma se destino \u00e8, si tratta del destino porco che\nm'\u00e8 venuto addosso da quando quella li ha avuto la bell'idea\ndi mettermi al mondo!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ALFONSINA", "Arialda!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 350);
  aScreen.AddPhrase("ARIALDA", "Arialda, cosa? Perch\u00e9, a me, che regali m'ha mai fatto\nla vita da quando ho aperto gli occhi? Avanti!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(1, 400);
  aScreen.AddPhrase("", "(Una pausa)", null, true);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 300);
  aScreen.AddPhrase("ARIALDA", "Destino, s\u00ec! Ma chiamatelo calore, che \u00e8 meglio!\nAlmeno si sa prima di cominciare, dove si deve sbattere!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ALFONSINA", "Arialda!  Adesso, basta!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(5, 350);
  aScreen.AddPhrase("ARlALDA", "Calore, cara la mia mamma! Calore!\nMica a tutte capita d'aver come spasimante\nuna pasta molle com'\u00e8 capitato a me!\nUno che ha cominciato a muoversi solo\ndopo che gli han dato i santissimi!\nCi son anche quelli che bollono!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ALFONSINA", "Ma, senti, Eros, te l'ha proprio detto chiaro?", null);
  aScreen.AddPhrase("EROS", "Chiaro? Chiarissimo.", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ARIALDA", "E cosa t'aspettavi, le mezze misure da quel maiale l\u00e0,\nche quel che ha, e per cui gli giran intorno\nanche le vedove dell'Africa,\nse l'\u00e8 fatto succhiando il sangue della povera gente come noi?", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ARIALDA", "La terrona!", /*suono pugno*/null);
  aScreen.AddPhrase("", "S\u00ec, perch\u00e9 io avr\u00f2 paura d'una povera scema\ncome quella vedova l\u00e0!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ALFONSINA", "E che tipo \u00e8, poi?\n", null);
  //screens.add(aScreen);

  //aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ARIALDA", "Sar\u00e0 calda anche lei! Perch\u00e9, qui, ormai,\nsi va avanti a furia di gradi!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 350);
  aScreen.AddPhrase("", "(Avvicinandosi alla credenza e fissando la fotografia del Luigi)", steps, true);
  aScreen.AddPhrase("ARIALDA", "Ma se credi d'aver vinto la partita\ne d'essermi tornato addosso un'altra volta...\nSenti, parlo con te!\nAh, ecco! Se credi cos\u00ec, ti sbagli!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ARIALDA", "Prima d'impalmare quella l\u00e0, i conti,\nil Candidezza, dovr\u00e0 farli con me!\nCapito?", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(5, 350);
  aScreen.AddPhrase("ARIALDA", "E va' pur avanti a ridere,\nche tanto 'sta faccia qui ce l'avevi\nanche quando i becchini t\u2019han saldato il coperchio!", coffin);
  aScreen.AddPhrase("", "Ah, ecco! Perch\u00e9 almeno quello lo sapr\u00f2!\n", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 350);
  aScreen.AddPhrase("ARIALDA", "\"Pare che ride ... \"; Siccome, conciato com'eri,\nnon potevano dire che parevi un angelo.\nMa io, prima di tornar sotto la tua grinfia,\nquella porca l\u00e0 gliela strappo di mano con la mia.", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 300);
  aScreen.AddPhrase("ARIALDA", "Capito?\nE non mi fermer\u00f2 davanti a niente!\nE pi\u00f9 tu andrai avanti a smangiarmi la coscienza e la carne,\ne pi\u00f9 andr\u00f2 avanti io!", null);
  aScreen.AddPhrase("ALFONSINA", "Arialda...", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(5, 300);
  aScreen.AddPhrase("ARIALDA", "Beh?\nCosa c'\u00e8 da guardarmi con quella faccia l\u00ec?\nCosa vi siete messi in testa,\nche son diventata matta?", /*suono matta*/laugh);
  aScreen.AddPhrase("", "Volete vedere che valore do pi\u00f9,\nio,\na un povero scemo come questo.", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(5, 400);
  aScreen.AddPhrase("", "(Getta a terra la fotografia)", /*suono fotografia*/photo, true);
  aScreen.AddPhrase("ARIALDA", "Zero! Zero assoluto!", /*suono pugno*/punch2);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ALFONSINA", "Arialda...", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(5, 400);
  aScreen.AddPhrase("ARIALDA", "E adesso qui la scopa,\nqui la scopa che lo mandiamo fuori del tutto!", broom/*suono scopa*/);
  screens.add(aScreen);

  /*aScreen = new DrammarScreen(5, 400);
   aScreen.AddPhrase("", "", null);
   screens.add(aScreen);*/

  aScreen.start();  
  lastFrame = millis();
  loop.loop();
}



/////////////////////////////////////////
public void draw()
{
  float deltaTime = millis();
  frameR = (deltaTime - lastFrame) /1000;
  lastFrame = deltaTime;
  background(background);
  screens.get(currentScreen).Update();

  /*if (mousePressed)
   {
   phrase.FadeOut();
   }*/

  /*//stroke(175);
   line(width/2,0,width/2,height);
   
   textFont(f);       
   fill(0);
   
   fill(255,0,0, alphaValue);
   text("Fade", 180, 180);
   if (alphaValue < 255) {
   alphaValue++;
   }
   textAlign(CENTER);
   text("This text is centered.",width/2,60); 
   
   textAlign(LEFT);
   text("This text is left aligned.",width/2,100); 
   
   textAlign(RIGHT);
   text("This text is right aligned.",width/2,140); */
}


/////////////////////////////////////////
public void NextScreen()
{
  currentScreen++;
  drammar_play.leftMargin = 0;
  if (currentScreen < screens.size())
    screens.get(currentScreen).start();
  else 
  exit();
}
class DrammarScreen {
  ArrayList<drammar_phrase> phrases;
  float currentTime;
  float timeBetweenPhrases = 5;
  int currentPhraseIndex = 0;
  drammar_phrase currentPhrase; 
  boolean start = false;
  int ypos = 0;

  int state = 0;//0 = fade in, 1 = mantain, 2 = fade out

  //Constructor
  DrammarScreen(float duration, int ypos) {
    this.ypos = ypos;
    timeBetweenPhrases = duration;
    phrases = new ArrayList();  
    currentTime = 0;
    start = false;
  }

  ////////////////////////////////////
  public void AddPhrase(drammar_phrase aPhrase)
  {
    phrases.add(aPhrase);
  }

  public void AddPhrase(String Name, String text, AudioPlayer audioFile)
  {
    AddPhrase( Name, text, audioFile, false);
  }

  ////////////////////////////////////
  public void AddPhrase(String Name, String text, AudioPlayer audioFile, boolean centered)
  {
    drammar_phrase createdPhrase = null;
    for (String phrase : text.split("\n"))
    {      
      createdPhrase = new drammar_phrase(this, Name, phrase, ypos, 2, null, centered);
      phrases.add(createdPhrase);
      Name = "";//reset the name, so that it appear only in the first phrase
      ypos += 35;
    }
    if (audioFile != null && createdPhrase != null)
      createdPhrase.sound = audioFile;
  }

  //////////////////////////////////
  public void start()
  {
    if (phrases.size() == 0)
      println("The phrases array is empty!");
    else {
      currentPhrase = phrases.get(0);
      start = true;
    }
  }

  ///////////////////////////////////
  public void Update()
  {
    if (state == 0)
    {
      int max = currentPhraseIndex;
      for (int i = 0; i <= max; i++)
        phrases.get(i).Update();
    } else if (state == 1)    
    {
      for (int i = 0; i < phrases.size(); i++)
        phrases.get(i).Update();
      currentTime += drammar_play.frameR;
      if (currentTime > timeBetweenPhrases)
      {
        for (int i = 0; i < phrases.size(); i++)
          phrases.get(i).FadeOut();
        state++;
      }
    } else if (state == 2)
    {
      for (int i = 0; i < phrases.size(); i++)
        phrases.get(i).Update();
    }
  }

  /////////////////////////////////////////
  public void EndFadeIn()
  {
    currentPhraseIndex++;
    if (currentPhraseIndex < phrases.size())
      currentPhrase = phrases.get(currentPhraseIndex);
    else
      state++;
  }

  //////////////////////////////////////
  public void EndFadeOut()
  {
    currentPhraseIndex--;
    if (currentPhraseIndex == 0)
      drammar_play.Instance.NextScreen();
  }
}

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

  
  AudioPlayer sound;

  //Constructor//////////////////
  drammar_phrase(DrammarScreen screen, String name, String text, int verticalPosition, float fadeTime, AudioPlayer soundFile)
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
  drammar_phrase(DrammarScreen screen, String name, String text, int verticalPosition, float fadeTime, AudioPlayer soundFile, boolean centered)
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
  public void Update()
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
  public void FadeOut()
  {
    multiplier = -1;
  }
}
  public void settings() {  size(1024, 768); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "drammar_play" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
