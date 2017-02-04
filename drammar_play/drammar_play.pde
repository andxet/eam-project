static final String data_folder = "../data/";
static final String xml_file = "inc_25.xml";
static final String sound_folder = "sound/";
static final String images_folder = "images/";
static final String music_folder = "music/";
static final String loop_name = "";
static final String background_name = "stireria.jpg";
static final int frameR = 60;
String[] sound_names = {
"",
"",
"",
"",
""
};

static drammar_play Instance;

int alphaValue = 0;
drammar_phrase phrase;

PImage background;

void setup()
{
  Instance = this;
  System.out.println("Hello!");
  size(1024, 768);//HD Ready
  background = loadImage(data_folder + images_folder + background_name);
  background.resize(1024,768);
  frameRate(frameR);
  phrase = new drammar_phrase("Arialda", "Ma ciao!!!\na capo", 100, 3);
}


void draw()
{
  background(background);
  phrase.Update();
  
  if (mousePressed)
  {
    phrase.FadeOut();
  }

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