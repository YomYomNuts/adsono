import processing.serial.*;
import cc.arduino.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


// GD can change this value
final int spaceTimeGetInput = 2000; // Give a value that can divide by 2 in millisecond
final int numberInputByMesure = 2;
final int timerBetweenChangementPlayer = 5000; // Timer in millisecond
final int timerLaunchRumbleDuringChangementPlayer = 3; // Timer in frame
final int timerChrismasTree = 500; // Timer in millisecond
final int timerAudioTalk = 1200;

// State game
final int stateReproductP1 = 0;
final int stateRecordP1 = 1;
final int stateReproductP2 = 2;
final int stateRecordP2 = 3;
final int stateChangePlayerP1toP2 = 4;
final int stateChangePlayerP2toP1 = 5;
final int stateFailReproductP1 = 6;
final int stateFailReproductP2 = 7;

// Correlation input
final int blankInput = 0;
final int buttonArmRight = 1;
final int buttonArmLeft = 2;
final int buttonBoobs = 3;
final int buttonStomach = 4;
final int buttonThighRight = 5;
final int buttonThighLeft = 6;
final int numberInputs = 7;

// Input player 1
final char buttonArmRightP1 = 'a';
final char buttonArmLeftP1 = 'z';
final char buttonBoobsP1 = 'e';
final char buttonStomachP1 = 'r';
final char buttonThighRightP1 = 't';
final char buttonThighLeftP1 = 'y';

// Input player 2
final char buttonArmRightP2 = 'q';
final char buttonArmLeftP2 = 's';
final char buttonBoobsP2 = 'd';
final char buttonStomachP2 = 'f';
final char buttonThighRightP2 = 'g';
final char buttonThighLeftP2 = 'h';

// State input press
final int stateFailPress = 0;
final int stateGoodPress = 1;
final int stateFinishPress = 2;

// Rumble pin
final int rumbleArmRight = 28;
final int rumbleArmLeft = 29;
final int rumbleBoobs = 30;
final int rumbleStomach = 31;
final int rumbleThighRight = 32;
final int rumbleThighLeft = 33;

// Led pin
final int ledArmRight = 8;
final int ledArmLeft = 9;
final int ledBoobs = 10;
final int ledStomach = 11;
final int ledThighRight = 12;
final int ledThighLeft = 13;

// arduino id
final int PLAYER1 = 1;
final int PLAYER2 = 2;

// Led tempo pin
final int ledTempo[] = { 22, 23, 24, 25, 26, 27 };

final int BPM[] = {30,40,50,60,69,92,100};

// Varibles game
Arduino arduinoP1;
Arduino arduinoP2;
// Game state
int currentState;
IntList listInputs;
boolean canGetInput;
boolean waitNextTempo;
int currentInput;
int current_bpm_index;
int playerStartGame;
// Tempo
Minim minim;

ArrayList<ArrayList<AudioPlayer>> audioRythmes;
AudioPlayer audioPlayer1 , audioPlayer2;
AudioPlayer audioNextPlayer;
AudioPlayer audioImpro;
AudioPlayer audioWin;


int prevTime;
int currentTime;
int tempo;
int delta;

void setup()
{
  // Init the arduinos
  println(Arduino.list());
  arduinoP1 = new Arduino(this, Arduino.list()[0]);
  arduinoP2 = new Arduino(this, Arduino.list()[1]);
  
  // Init var game
  listInputs = new IntList();
  initGame();
  playerStartGame = PLAYER1;
  
  // Sound
  minim = new Minim(this);
  audioRythmes = new ArrayList<ArrayList<AudioPlayer>>();
  ArrayList<AudioPlayer> temp =  new ArrayList<AudioPlayer>();
  audioRythmes.add(temp);
  //temp.add(minim.loadFile("Music/RythmeWAV/BASS_060.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/INTER_060.wav"));
  temp.add(minim.loadFile("Music/RythmeWAV/METRO_060.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/RIFF_060.wav"));
  temp =  new ArrayList<AudioPlayer>();
  audioRythmes.add(temp);
  //temp.add(minim.loadFile("Music/RythmeWAV/BASS_080.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/INTER_080.wav"));
  temp.add(minim.loadFile("Music/RythmeWAV/METRO_080.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/RIFF_080.wav"));
  temp =  new ArrayList<AudioPlayer>();
  audioRythmes.add(temp);
  //temp.add(minim.loadFile("Music/RythmeWAV/BASS_100.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/INTER_100.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/METRO_100.wav"));
  temp.add(minim.loadFile("Music/RythmeWAV/RIFF_100.wav"));
  temp =  new ArrayList<AudioPlayer>();
  audioRythmes.add(temp);
  //temp.add(minim.loadFile("Music/RythmeWAV/BASS_138.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/INTER_138.wav"));
  temp.add(minim.loadFile("Music/RythmeWAV/METRO_138.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/RIFF_138.wav"));
  temp =  new ArrayList<AudioPlayer>();
  audioRythmes.add(temp);
  //temp.add(minim.loadFile("Music/RythmeWAV/BASS_184.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/INTER_184.wav"));
  temp.add(minim.loadFile("Music/RythmeWAV/METRO_184.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/RIFF_184.wav"));
  temp =  new ArrayList<AudioPlayer>();
  audioRythmes.add(temp);
  //temp.add(minim.loadFile("Music/RythmeWAV/BASS_200.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/INTER_200.wav"));
  temp.add(minim.loadFile("Music/RythmeWAV/METRO_200.wav"));
  //temp.add(minim.loadFile("Music/RythmeWAV/RIFF_200.wav"));
  
  audioPlayer1 = minim.loadFile("Music/VoixWAV/PLAYER1_PLAY.wav") ; 
  audioPlayer2 = minim.loadFile("Music/VoixWAV/PLAYER2_PLAY.wav") ;
  audioNextPlayer = minim.loadFile("Music/VoixWAV/NEXTPLAYER.wav") ;
  audioImpro = minim.loadFile("Music/VoixWAV/IMPRO.wav") ;
  audioWin = minim.loadFile("Music/VoixWAV/WIN.wav") ;
  
}

void initGame()
{
  // Init var game
  currentState = stateReproductP1;
  canGetInput = false;
  waitNextTempo = false;
  currentInput = 0;
  // Add the first input
  listInputs.clear();
  listInputs.append((int)random(numberInputs));
  listInputs.append((int)random(numberInputs));
  println(listInputs);
  
  // Sound
  prevTime = millis();
  currentTime = 0;
  current_bpm_index = 0;
  setBPM(BPM[current_bpm_index]);
  
  // Stop all led of tempo
  for(int i = 0 ; i < ledTempo.length ; ++i)
  {
    setPinState(PLAYER1,ledTempo[i],Arduino.HIGH);
    setPinState(PLAYER2,ledTempo[i],Arduino.HIGH);
  }
}

void draw()
{
  switch(currentState)
  {
    case stateReproductP1:
    case stateReproductP2:
    case stateRecordP1:
    case stateRecordP2:
    {
      giveTempo();
    } break;
    case stateChangePlayerP1toP2:
    {
      println("Wait next player");
      audioNextPlayer.rewind();
      audioNextPlayer.play();
      delay(timerAudioTalk);
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER2,rumbleThighRight,Arduino.HIGH);
      setPinState(PLAYER2,rumbleThighLeft,Arduino.HIGH);
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER2,rumbleBoobs,Arduino.HIGH);
      setPinState(PLAYER2,rumbleStomach,Arduino.HIGH);
      
      audioPlayer1.rewind();
      audioPlayer1.play();
      
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER2,rumbleArmRight,Arduino.HIGH);
      setPinState(PLAYER2,rumbleArmLeft,Arduino.HIGH);
      delay(timerLaunchRumbleDuringChangementPlayer);
      stopAllRumble(PLAYER2);
      stopAllLED(PLAYER2);
      delay(timerBetweenChangementPlayer);
      
      println("Player 2");
      canGetInput = false;
      waitNextTempo = false;
      currentState = stateReproductP2;
      currentTime = 0;
      prevTime = millis();
    } break;
    case stateChangePlayerP2toP1:
    {
      println("Wait next player");
      audioNextPlayer.rewind();
      audioNextPlayer.play();
      delay(timerAudioTalk);
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER1,rumbleThighRight,Arduino.HIGH);
      setPinState(PLAYER1,rumbleThighLeft,Arduino.HIGH);
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER1,rumbleBoobs,Arduino.HIGH);
      setPinState(PLAYER1,rumbleStomach,Arduino.HIGH);
      
      audioPlayer2.rewind();
      audioPlayer2.play();
      
      
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER1,rumbleArmRight,Arduino.HIGH);
      setPinState(PLAYER1,rumbleArmLeft,Arduino.HIGH);
      stopAllRumble(PLAYER1);
      stopAllLED(PLAYER1);
      delay(timerBetweenChangementPlayer);
      
      println("Player 1");
      canGetInput = false;
      waitNextTempo = false;
      currentState = stateReproductP1;
      currentTime = 0;
      prevTime = millis();
      
      current_bpm_index ++;
      if(current_bpm_index >= BPM.length)
      {
        current_bpm_index = BPM.length - 1;
      }
      setBPM(BPM[current_bpm_index]);
      setLedTempo(current_bpm_index);
      
      stopAllRumble(PLAYER2);
    } break;
    case stateFailReproductP1:
    {
      println("P1 lose");
      sequenceEndRound(PLAYER2,PLAYER1);
      endRound();
    } break;
    case stateFailReproductP2:
    {
      println("P2 lose");
      sequenceEndRound(PLAYER1,PLAYER2);
      endRound();
    } break;
  }
}

void endRound()
{
  initGame();
  println(listInputs);
  if (playerStartGame == PLAYER1)
  {
    playerStartGame = PLAYER2;
    currentState = stateReproductP2;
    println("Player 2");
  }
  else
  {
    playerStartGame = PLAYER1;
    currentState = stateReproductP1;
    println("Player 1");
  }
}

void sequenceEndRound(int winner,int looser)
{
    audioImpro.pause();
    audioWin.rewind();
    audioWin.play();
      
    stopAllLED(PLAYER1);
    stopAllLED(PLAYER2);
    stopAllRumble(PLAYER1);
    stopAllRumble(PLAYER2);
    fireAllLED(winner);
    setPinState(looser,rumbleArmRight,Arduino.HIGH);
    setPinState(looser,rumbleArmLeft,Arduino.HIGH);
    setPinState(looser,ledArmRight,Arduino.HIGH);
    setPinState(looser,ledArmLeft,Arduino.HIGH);
    delay(timerChrismasTree);
    stopAllLED(winner);
    setPinState(looser,rumbleArmRight,Arduino.LOW);
    setPinState(looser,rumbleArmLeft,Arduino.LOW);
    setPinState(looser,ledArmRight,Arduino.LOW);
    setPinState(looser,ledArmLeft,Arduino.LOW);
    delay(timerChrismasTree);
    fireAllLED(winner);
    setPinState(looser,rumbleBoobs,Arduino.HIGH);
    setPinState(looser,rumbleStomach,Arduino.HIGH);
    setPinState(looser,ledBoobs,Arduino.HIGH);
    setPinState(looser,ledStomach,Arduino.HIGH);
    delay(timerChrismasTree);
    stopAllLED(winner);
    setPinState(looser,rumbleBoobs,Arduino.LOW);
    setPinState(looser,rumbleStomach,Arduino.LOW);
    setPinState(looser,ledBoobs,Arduino.LOW);
    setPinState(looser,ledStomach,Arduino.LOW);
    delay(timerChrismasTree);
    fireAllLED(winner);
    setPinState(looser,rumbleThighRight,Arduino.HIGH);
    setPinState(looser,rumbleThighLeft,Arduino.HIGH);
    setPinState(looser,ledThighRight,Arduino.HIGH);
    setPinState(looser,ledThighLeft,Arduino.HIGH);
    delay(timerChrismasTree);
    stopAllLED(winner);
    setPinState(looser,rumbleThighRight,Arduino.LOW);
    setPinState(looser,rumbleThighLeft,Arduino.LOW);
    setPinState(looser,ledThighRight,Arduino.LOW);
    setPinState(looser,ledThighLeft,Arduino.LOW);
}

void giveTempo()
{
  // Give the tempo
  delta = millis() -  prevTime;
  currentTime += delta;
  if (!canGetInput && !waitNextTempo && currentTime >= tempo - spaceTimeGetInput/2 && currentTime <= tempo + spaceTimeGetInput/2)
  {
    canGetInput = true;
    println("Press");
    // Tempo player
    if (currentState == stateReproductP1 || currentState == stateRecordP1)
    {
      for(int i = 0 ; i < audioRythmes.get(current_bpm_index).size();++i)
      { 
        audioRythmes.get(current_bpm_index).get(i).rewind();
        audioRythmes.get(current_bpm_index).get(i).play();
      }
     
      
      
      if(currentState == stateReproductP1 && listInputs.get(currentInput) != blankInput)
      {
        setPinState(PLAYER1,getLedPin(listInputs.get(currentInput)),Arduino.HIGH);
        setPinState(PLAYER1,getRumblePin(listInputs.get(currentInput)),Arduino.HIGH);
      }
    }
    else
    {
      audioRythmes.get(current_bpm_index).get(0).rewind();
      audioRythmes.get(current_bpm_index).get(0).play();
      
      
      if(currentState == stateReproductP2 && listInputs.get(currentInput) != blankInput)
      {
        setPinState(PLAYER2,getLedPin(listInputs.get(currentInput)),Arduino.HIGH);
        setPinState(PLAYER2,getRumblePin(listInputs.get(currentInput)),Arduino.HIGH);
      }
    }
  }
  if (currentTime > tempo + spaceTimeGetInput/2)
  {
    println("Stop Press");
    if (canGetInput)
    {
      // Check blank
      switch(currentState)
      {
        case stateReproductP1:
        case stateReproductP2:
        {
          // Get final state
          int stateFail, stateFinish;
          if (currentState == stateReproductP1)
          {
            stateFail = stateFailReproductP1;
            stateFinish = stateRecordP1;
            audioImpro.rewind();
            audioImpro.play();
          }
          else
          {
            stateFail = stateFailReproductP2;
            stateFinish = stateRecordP2;
            audioImpro.rewind();
            audioImpro.play();
          }
          // Check key
          switch(checkKey(blankInput))
          {
            case stateFailPress:
            {
              currentState = stateFail;
            } break;
            case stateFinishPress:
            {
              currentState = stateFinish;
            } break;
            case stateGoodPress:
            {
              // If we arrive here, do nothing because it's not finish
            } break;
          }
        } break;
        case stateRecordP1:
        case stateRecordP2:
        {
          // Add blank
          listInputs.append(blankInput);
          
          // Finish record
          if (listInputs.size() == currentInput + numberInputByMesure)
          {
            currentInput = 0;
            if (currentState == stateRecordP1)
            {
              currentState = stateChangePlayerP1toP2;
            }
            else
            {
              currentState = stateChangePlayerP2toP1;
            }
          }
        } break;
      }
      println(listInputs);
    }
    canGetInput = false;
    waitNextTempo = false;
    currentTime = currentTime - tempo;
  }
  prevTime = millis();
}

void keyPressed()
{
  println(key);
  int currentGeneralInputPress = getGeneralInput(key, ((currentState == stateReproductP1 || currentState == stateRecordP1) ? PLAYER1 : PLAYER2));
  if (canGetInput && currentGeneralInputPress != -1)
  {
    canGetInput = false; // Now we can't do an other input
    waitNextTempo = true;
    
    switch(currentState)
    {
      case stateReproductP1:
        stopAllRumble(PLAYER1);
        stopAllLED(PLAYER1);
      case stateReproductP2:
      {
        // Get final state
        // TODO stop the rumble and the leds of this action
        
        stopAllRumble(PLAYER2);
        stopAllLED(PLAYER2);
        
        int stateFail, stateFinish;
        if (currentState == stateReproductP1)
        {
          stateFail = stateFailReproductP1;
          stateFinish = stateRecordP1;
        }
        else
        {
          stateFail = stateFailReproductP2;
          stateFinish = stateRecordP2;
        }
        // Check key
        switch(checkKey(currentGeneralInputPress))
        {
          case stateFailPress:
          {
            currentState = stateFail;
          } break;
          case stateFinishPress:
          {
            currentState = stateFinish;
          } break;
          case stateGoodPress:
          {
            // If we arrive here, do nothing because it's not finish
          } break;
        }
      } break;
      case stateRecordP1:
      case stateRecordP2:
      {
        println("Record");
        // Add the input
        listInputs.append(currentGeneralInputPress);
        
        
        int pin = getLedPin(currentGeneralInputPress);
        setPinState(PLAYER1,pin,Arduino.HIGH);
        setPinState(PLAYER2,pin,Arduino.HIGH);
        
        
        // Finish record
        if (listInputs.size() == currentInput + numberInputByMesure)
        {
          currentInput = 0;
          if (currentState == stateRecordP1)
          {
            currentState = stateChangePlayerP1toP2;
          }
          else
          {
            currentState = stateChangePlayerP2toP1;
          }
        }
      } break;
    }
    println(listInputs);
  }
}

int getGeneralInput(char keyPress, int player)
{
  if (player == PLAYER1)
  {
    switch(key)
    {
      case buttonArmRightP1:
      {
        return buttonArmRight;
      }
      case buttonArmLeftP1:
      {
        return buttonArmLeft;
      }
      case buttonBoobsP1:
      {
        return buttonBoobs;
      }
      case buttonStomachP1:
      {
        return buttonStomach;
      }
      case buttonThighRightP1:
      {
        return buttonThighRight;
      }
      case buttonThighLeftP1:
      {
        return buttonThighLeft;
      }
    }
  }
  else
  {
    switch(key)
    {
      case buttonArmRightP2:
      {
        return buttonArmRight;
      }
      case buttonArmLeftP2:
      {
        return buttonArmLeft;
      }
      case buttonBoobsP2:
      {
        return buttonBoobs;
      }
      case buttonStomachP2:
      {
        return buttonStomach;
      }
      case buttonThighRightP2:
      {
        return buttonThighRight;
      }
      case buttonThighLeftP2:
      {
        return buttonThighLeft;
      }
    }
  }
  return -1;
}

int getLedPin(int input)
{
  switch (input)
  {
     case buttonArmRight : 
       return ledArmRight;
     case buttonArmLeft : 
       return ledArmLeft;
     case buttonBoobs : 
       return ledBoobs;
     case buttonStomach : 
       return ledStomach;
     case buttonThighRight : 
       return ledThighRight;
     case buttonThighLeft : 
       return ledThighLeft;
   }
   return 0;
}
int getRumblePin(int input)
{
  switch (input)
  {
     case buttonArmRight : 
       return rumbleArmRight;
     case buttonArmLeft : 
       return rumbleArmLeft;
     case buttonBoobs : 
       return rumbleBoobs;
     case buttonStomach : 
       return rumbleStomach;
     case buttonThighRight : 
       return rumbleThighRight;
     case buttonThighLeft : 
       return rumbleThighLeft;
  }
  return 0;
}

void stopAllRumble(int player)
{
  setPinState(player,rumbleArmRight,Arduino.LOW);
  setPinState(player,rumbleArmLeft,Arduino.LOW);
  setPinState(player,rumbleBoobs,Arduino.LOW);
  setPinState(player,rumbleStomach,Arduino.LOW);
  setPinState(player,rumbleThighRight,Arduino.LOW);
  setPinState(player,rumbleThighLeft,Arduino.LOW);
}

void stopAllLED(int player)
{
  setPinState(player,ledArmRight,Arduino.LOW);
  setPinState(player,ledArmLeft,Arduino.LOW);
  setPinState(player,ledBoobs,Arduino.LOW);
  setPinState(player,ledStomach,Arduino.LOW);
  setPinState(player,ledThighRight,Arduino.LOW);
  setPinState(player,ledThighLeft,Arduino.LOW);
}

void fireAllLED(int player)
{
  setPinState(player,ledArmRight,Arduino.HIGH);
  setPinState(player,ledArmLeft,Arduino.HIGH);
  setPinState(player,ledBoobs,Arduino.HIGH);
  setPinState(player,ledStomach,Arduino.HIGH);
  setPinState(player,ledThighRight,Arduino.HIGH);
  setPinState(player,ledThighLeft,Arduino.HIGH);
}

int checkKey(int keyPress)
{
  if (listInputs.get(currentInput) == keyPress)
  {
    ++currentInput;
    if (listInputs.size() == currentInput)
    {
      // Finish the reproduction
      return stateFinishPress;
    }
    else
    {
      // Good the reproduction
      return stateGoodPress;
    }
  }
  else
  {
    // Fial the reproduction
    return stateFailPress;
  }
}

void keyReleased()
{
  switch(currentState)
  {
    case stateRecordP1:
    case stateRecordP2:
    case stateChangePlayerP1toP2:
    case stateChangePlayerP2toP1:
    {
      stopAllLED(PLAYER1);
      stopAllLED(PLAYER2);
    } break;
  }
}

void setPinState(int player,int pin,int value)
{
  switch (player)
  {
    case PLAYER1:
      arduinoP1.digitalWrite(pin, value);
      break;
    case PLAYER2:
      arduinoP2.digitalWrite(pin, value);
      break;
  }
}

void setBPM(int bpm)
{
  tempo = 60000 / bpm;
}

void setLedTempo(int tempoLevel)
{
  for(int i = 0 ; i < ledTempo.length ; ++i)
  {
    int l = Arduino.LOW;
    if(tempoLevel - 1 < i)
    {
      l = Arduino.HIGH;
    }
    setPinState(PLAYER1,ledTempo[i],l);
    setPinState(PLAYER2,ledTempo[i],l);
  }
}

void stop()
{
  for(int i = 0 ; i < audioRythmes.size();++i)
  {
    for(int j = 0 ; j < audioRythmes.get(i).size(); ++j)
    {
       audioRythmes.get(i).get(j).close();
    }
  }
  // the AudioInput you got from Minim.getLineIn()
  minim.stop();
 
  // this calls the stop method that 
  // you are overriding by defining your own
  // it must be called so that your application 
  // can do all the cleanup it would normally do
  super.stop();
}
