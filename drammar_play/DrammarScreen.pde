class DrammarScreen {
  ArrayList<drammar_phrase> phrases;
  int currentTime;
  float timeBetweenPhrases = 5;
  int currentPhraseIndex = 0;
  drammar_phrase currentPhrase; 

  int state = 0;//0 = fade in, 1 = mantain, 2 = fade out

  DrammarScreen(ArrayList<drammar_phrase> phrases) {
    this.phrases = phrases;
    timeBetweenPhrases *= drammar_play.frameR; //Mul by the frame per second so we can increment the counter every frame
    if (phrases.size() == 0)
      println("The phrases array is empty!");
    else
      currentPhrase = phrases.get(0);
    currentTime = 0;
  }

  void Update()
  {
    if (state == 0)
      currentPhrase.Update();
    else if (state == 1)
    {
      currentTime++;
      if(currentTime > timeBetweenPhrases)
        state++;
    }
    else if(state == 2)
    {
      
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
  }
}