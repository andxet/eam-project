static final String data_folder = "data/"; //<>//
static final String xml_file = "inc_25.xml";
static final String sound_folder = "sound/";
static final String images_folder = "images/";
static final String music_folder = "music/";
static final String loop_name = "";
static final String background_name = "stireria2_bak.jpg";
static float frameR = 0;
static int leftMargin;

import ddf.minim.*;

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

/*L’ARIALDA Destino? Ma se destino è, si tratta del destino porco che m'è venuto addosso da quando quella li ha avuto la bell'idea di mettermi al mondo!
 L’ALFONSINA Arialda!
 L'ARIALDA Arialda, cosa? Perché, a me, che regali m'ha mai fatto la vita da quando ho aperto gli occhi? Avanti! (Una pausa) Destino, sì! Ma chiamatelo calore, che è meglio! Almeno si sa prima di cominciare, dove si deve sbattere!
 L'ALFONSINA Arialda! Adesso, basta!
 L'ARlALDA Calore, cara la mia mamma! Calore! Mica a tutte capita d'aver come spasimante una pasta molle com'è capitato a me! Uno che ha cominciato a muoversi
 solo dopo che gli han dato i santissimi! Ci son anche quelli che bollono!
 L'ALFONSINA Ma, senti, Eros, te l'ha proprio detto chiaro?
 L'EROS Chiaro? Chiarissimo.
 L'ARIALDA E cosa t'aspettavi, le mezzemisure da quel maiale là, che quel che ha, e per cui gli giran intorno anche le vedove dell'Africa, se l'è fatto succhiando il sangue della povera gente come noi? La terrona! Sì, perché io avrò paura d'una povera scema come quella vedova là!
 L'ALFONSINA E che tipo è, poi?
 L'ARlALDA Sarà calda anche lei! Perché, qui, ormai, si va avanti a furia di gradi! (Avvicinandosi alla credenza e fissando la fotografia del Luigi) Ma se credi d'aver vinto la partita e d'essermi tornato addosso un'altra volta ... Senti, parlo conte! Ah, ecco! Se credi così, ti sbagli! Prima d'impalmare quella là, i conti, il Candidezza, dovrà farli con me! Capito? E va' pur avanti a ridere, che tanto 'sta faccia qui ce l'avevi anche quando i becchini t’han saldato il coperchio! Ah, ecco! Perché almeno quello lo saprò! "Pare che ride ... "; siccome, conciato com'eri, non potevano dire che parevi un angelo. Ma io, prima di tornar sotto la tua grinfia, quella porca là gliela strappo di mano con la mia. Capito? E non mi fermerò davanti a niente! E più tu andrai avanti a smangiarmi la coscienza e la carne, e più andrò avanti io! 
 L'ALFONSINA Arialda... 
 L'ARIALDA Beh? Cosa c'è da guardarmi con quella faccia lì? Cosa vi siete messi in testa, che son diventata matta? Volete vedere che valore do più, io, a un povero scemo come questo. (Getta a terra la fotografia): Zero! Zero assoluto!
 L'ALFONSINA Arialda…
 L'ARIALDA E adesso qui la scopa, qui la scopa che lo mandiamo fuori del tutto!*/


/////////////////////////////////////////
void setup()
{
  Instance = this;

  size(1024, 768);//HD Ready
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
  aScreen.AddPhrase("", "Ma se destino è, si tratta del destino porco che\nm'è venuto addosso da quando quella li ha avuto la bell'idea\ndi mettermi al mondo!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ALFONSINA", "Arialda!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 350);
  aScreen.AddPhrase("ARIALDA", "Arialda, cosa? Perché, a me, che regali m'ha mai fatto\nla vita da quando ho aperto gli occhi? Avanti!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(1, 400);
  aScreen.AddPhrase("", "(Una pausa)", null, true);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 300);
  aScreen.AddPhrase("ARIALDA", "Destino, sì! Ma chiamatelo calore, che è meglio!\nAlmeno si sa prima di cominciare, dove si deve sbattere!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ALFONSINA", "Arialda!  Adesso, basta!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(5, 350);
  aScreen.AddPhrase("ARlALDA", "Calore, cara la mia mamma! Calore!\nMica a tutte capita d'aver come spasimante\nuna pasta molle com'è capitato a me!\nUno che ha cominciato a muoversi solo\ndopo che gli han dato i santissimi!\nCi son anche quelli che bollono!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ALFONSINA", "Ma, senti, Eros, te l'ha proprio detto chiaro?", null);
  aScreen.AddPhrase("EROS", "Chiaro? Chiarissimo.", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ARIALDA", "E cosa t'aspettavi, le mezze misure da quel maiale là,\nche quel che ha, e per cui gli giran intorno\nanche le vedove dell'Africa,\nse l'è fatto succhiando il sangue della povera gente come noi?", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ARIALDA", "La terrona!", /*suono pugno*/null);
  aScreen.AddPhrase("", "Sì, perché io avrò paura d'una povera scema\ncome quella vedova là!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ALFONSINA", "E che tipo è, poi?\n", null);
  //screens.add(aScreen);

  //aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ARIALDA", "Sarà calda anche lei! Perché, qui, ormai,\nsi va avanti a furia di gradi!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 350);
  aScreen.AddPhrase("", "(Avvicinandosi alla credenza e fissando la fotografia del Luigi)", steps, true);
  aScreen.AddPhrase("ARIALDA", "Ma se credi d'aver vinto la partita\ne d'essermi tornato addosso un'altra volta...\nSenti, parlo con te!\nAh, ecco! Se credi così, ti sbagli!", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 400);
  aScreen.AddPhrase("ARIALDA", "Prima d'impalmare quella là, i conti,\nil Candidezza, dovrà farli con me!\nCapito?", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(5, 350);
  aScreen.AddPhrase("ARIALDA", "E va' pur avanti a ridere,\nche tanto 'sta faccia qui ce l'avevi\nanche quando i becchini t’han saldato il coperchio!", coffin);
  aScreen.AddPhrase("", "Ah, ecco! Perché almeno quello lo saprò!\n", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 350);
  aScreen.AddPhrase("ARIALDA", "\"Pare che ride ... \"; Siccome, conciato com'eri,\nnon potevano dire che parevi un angelo.\nMa io, prima di tornar sotto la tua grinfia,\nquella porca là gliela strappo di mano con la mia.", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(2, 300);
  aScreen.AddPhrase("ARIALDA", "Capito?\nE non mi fermerò davanti a niente!\nE più tu andrai avanti a smangiarmi la coscienza e la carne,\ne più andrò avanti io!", null);
  aScreen.AddPhrase("ALFONSINA", "Arialda...", null);
  screens.add(aScreen);

  aScreen = new DrammarScreen(5, 300);
  aScreen.AddPhrase("ARIALDA", "Beh?\nCosa c'è da guardarmi con quella faccia lì?\nCosa vi siete messi in testa,\nche son diventata matta?", /*suono matta*/laugh);
  aScreen.AddPhrase("", "Volete vedere che valore do più,\nio,\na un povero scemo come questo.", null);
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
void draw()
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
void NextScreen()
{
  currentScreen++;
  drammar_play.leftMargin = 0;
  if (currentScreen < screens.size())
    screens.get(currentScreen).start();
  else 
  exit();
}