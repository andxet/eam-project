class DrammarScreen {
  ArrayList<drammar_phrase> phrases;
  float currentTime;
  float timeBetweenPhrases = 5;
  int currentPhraseIndex = 0;
  drammar_phrase currentPhrase; 
  boolean start = false;

  int state = 0;//0 = fade in, 1 = mantain, 2 = fade out

  DrammarScreen(float duration) {
    timeBetweenPhrases = duration;
    phrases = new ArrayList();  
    currentTime = 0;
    start = false;
  }

  void AddPhrase(drammar_phrase aPhrase)
  {
    phrases.add(aPhrase);
  }

  void AddPhrase(String Name, String text, int yPos, SoundFile audioFile)
  {
    phrases.add(new drammar_phrase(this, Name, text, yPos, 1, audioFile));
  }

  void start()
  {
    if (phrases.size() == 0)
      println("The phrases array is empty!");
    else {
      currentPhrase = phrases.get(0);
      start = true;
    }
  }

  void Update()
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

  void EndFadeIn()
  {
    currentPhraseIndex++;
    if (currentPhraseIndex < phrases.size())
      currentPhrase = phrases.get(currentPhraseIndex);
    else
      state++;
  }

  void EndFadeOut()
  {
    currentPhraseIndex--;
    if(currentPhraseIndex == 0)
      drammar_play.Instance.NextScreen();
  }
}