import processing.serial.*;
import cc.arduino.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


// GD can change this values
final int spaceBlackGetInput = 10; // Timer in millisecond
final int numberInputByMesure = 2;
final int timerLaunchRumbleDuringChangementPlayer = 3; // Timer in frame
final int timerChrismasTree = 500; // Timer in millisecond
final int BPM[] = {30,45,60,90};
final int spaceTimeGetInput[] = {750,600,450,300}; // Timer in millisecond
final int timerLEDHighDuringRecord = 200; // Timer in millisecond
final int timerLEDHighDuringComputerRandom = 500; // Timer in millisecond
final int timerLEDLowDuringComputerRandom = 500; // Timer in millisecond
final int numberBlinkVictory = 3;

// Sounds
final String BGSound = "Music/background.wav";
final String buttonArmRightYellowSound = "Music/inputs/Fx_input (1).wav";
final String buttonArmLeftGreenSound = "Music/inputs/Fx_input (2).wav";
final String buttonBoobsRedSound = "Music/inputs/Fx_input (3).wav";
final String buttonStomachBlueSound = "Music/inputs/Fx_input (4).wav";
final String buttonThighRightPinkSound = "Music/inputs/Fx_input (5).wav";
final String buttonThighLeftOrangeSound = "Music/inputs/Fx_input (6).wav";
final String metronomeJ1Sound = "Music/metroJ1.wav";
final String metronomeJ2Sound = "Music/metroJ2.wav";
final String introSound = "Music/voices/impro.wav";
final String winSound = "Music/voices/win.wav";
final int timerWinSound = 1680; // Timer in millisecond
final String areYouReadySound = "Music/voices/ready.wav";
final int timerAreYouReadySound = 1500; // Timer in millisecond
final String startSound = "Music/voices/start.wav";
final int timerStartSound = 1130; // Timer in millisecond
final String speedUpSound = "Music/voices/speedup.wav";
final int timerSpeedUpSound = 768; // Timer in millisecond
final String fillSound = "Music/fill.wav";
final int timerFillSound = 1200; // Timer in millisecond
final String recordSound = "Music/voices/impro.wav";
final String errorSound = "Music/error.wav";

// State game
final int stateReproductP1 = 0;
final int stateRecordP1 = 1;
final int stateReproductP2 = 2;
final int stateRecordP2 = 3;
final int stateChangePlayerP1toP2 = 4;
final int stateChangePlayerP2toP1 = 5;
final int stateFailReproductP1 = 6;
final int stateFailReproductP2 = 7;

// Inputs
final int numberInputs = 6;
final int blankInput = numberInputs * 2;

// State input press
final int stateFailPress = 0;
final int stateGoodPress = 1;
final int stateFinishPress = 2;

// arduino id
final int PLAYER1 = 0;
final int PLAYER2 = 1;

// Led tempo pin
final int ledTempo[] = { 22, 23, 24, 25, 26, 27 };

// Varibles game
Arduino arduinoP1;
Arduino arduinoP2;
boolean[] valueInputP1 = new boolean[6];
boolean[] valueInputP2 = new boolean[6];
int currentPinPressP1 = -1;
int currentPinPressP2 = -1;

// Game state
int listInputsImpossible[] = {};
IntList listInputs = new IntList();
int currentState;
boolean canGetInput;
boolean waitNextTempo;
int currentInput;
int current_bpm_index;
int playerStartGame;

// Music
Minim minim;
AudioPlayer audioBG;
ArrayList<AudioPlayer> audioInputs;
ArrayList<AudioPlayer> audioMetros;
AudioPlayer audioWin;
AudioPlayer audioAreYouReady;
AudioPlayer audioStart;
AudioPlayer audioSpeedUp;
AudioPlayer audioFill;
AudioPlayer audioRecord;
AudioPlayer audioError;

// Tempo
int prevTime;
int currentTime;
int tempo;
int delta;

void setup()
{
  // Sound
  minim = new Minim(this);
  
  audioBG = minim.loadFile(BGSound);
  audioBG.loop();
  
  audioInputs = new ArrayList<AudioPlayer>();
  audioInputs.add(minim.loadFile(buttonArmRightYellowSound));
  audioInputs.add(minim.loadFile(buttonArmLeftGreenSound));
  audioInputs.add(minim.loadFile(buttonBoobsRedSound));
  audioInputs.add(minim.loadFile(buttonStomachBlueSound));
  audioInputs.add(minim.loadFile(buttonThighRightPinkSound));
  audioInputs.add(minim.loadFile(buttonThighLeftOrangeSound));
  
  audioMetros = new ArrayList<AudioPlayer>();
  audioMetros.add(minim.loadFile(metronomeJ1Sound));
  audioMetros.add(minim.loadFile(metronomeJ2Sound));
  
  audioWin = minim.loadFile(winSound);
  audioAreYouReady = minim.loadFile(areYouReadySound);
  audioStart = minim.loadFile(startSound);
  audioSpeedUp = minim.loadFile(speedUpSound);
  audioFill = minim.loadFile(fillSound);
  audioRecord = minim.loadFile(recordSound);
  audioError = minim.loadFile(errorSound);
  
  // Init the arduinos
  println(Arduino.list());
  arduinoP1 = new Arduino(this, Arduino.list()[0]);
  arduinoP2 = new Arduino(this, Arduino.list()[1]);
  
  // Init input tab
  currentPinPressP1 = -1;
  currentPinPressP2 = -1;
  InitInputs(valueInputP1, arduinoP1);
  InitInputs(valueInputP2, arduinoP2);
  
  // Init var game
  playerStartGame = PLAYER1;
  initGame();
}

void initGame()
{
  Arduino arduinoFirstPlayer = playerStartGame == PLAYER1 ? arduinoP1 : arduinoP2;
  int otherPlayer = playerStartGame == PLAYER1 ? PLAYER2 : PLAYER1;
  Arduino arduinoOtherPlayer = otherPlayer == PLAYER1 ? arduinoP1 : arduinoP2;
  
  // Init var game
  currentState = stateReproductP1;
  canGetInput = false;
  waitNextTempo = false;
  currentInput = 0;
  
  // Add the first input
  listInputs.clear();
  int value = -1;
  boolean find = true;
  while (find)
  {
    find = false;
    value = (int)random(numberInputs) + playerStartGame * numberInputs;
    for (int j = 0; j < listInputsImpossible.length; ++j)
    {
      if (listInputsImpossible[j] == value)
        find = true;
    }
  }
  listInputs.append(value);
  int pinLed = getLedPin(listInputs.get(0) - playerStartGame * numberInputs);
  if (pinLed != -1)
  {
    setPinState(arduinoFirstPlayer, pinLed, Arduino.HIGH);
    audioInputs.get(listInputs.get(0) - playerStartGame * numberInputs).rewind();
    audioInputs.get(listInputs.get(0) - playerStartGame * numberInputs).play();
    delay(timerLEDHighDuringComputerRandom);
    setPinState(arduinoFirstPlayer, pinLed, Arduino.LOW);
  }
  delay(timerLEDLowDuringComputerRandom);
  
  find = true;
  while (find)
  {
    find = false;
    value = (int)random(numberInputs) + otherPlayer * numberInputs;
    for (int j = 0; j < listInputsImpossible.length; ++j)
    {
      if (listInputsImpossible[j] == value)
        find = true;
    }
  }
  listInputs.append(value);
  pinLed = getLedPin(listInputs.get(1) - otherPlayer * numberInputs);
  if (pinLed != -1)
  {
    setPinState(arduinoOtherPlayer, pinLed, Arduino.HIGH);
    audioInputs.get(listInputs.get(1) - otherPlayer * numberInputs).rewind();
    audioInputs.get(listInputs.get(1) - otherPlayer * numberInputs).play();
    delay(timerLEDHighDuringComputerRandom);
    setPinState(arduinoOtherPlayer, pinLed, Arduino.LOW);
  }
  delay(timerLEDLowDuringComputerRandom);
    
  println(listInputs);
  
  // Sound
  currentTime = 0;
  current_bpm_index = 0;
  setBPM(BPM[current_bpm_index]);
  
  // Stop all led of tempo
  for(int i = 0 ; i < ledTempo.length ; ++i)
  {
    setPinState(arduinoP1, ledTempo[i], Arduino.HIGH);
    setPinState(arduinoP2, ledTempo[i], Arduino.HIGH);
  }
  
  //warn players that the game will start
  audioAreYouReady.rewind();
  audioAreYouReady.play();
  delay(timerAreYouReadySound);
  
  audioStart.rewind();
  audioStart.play();
  delay(timerStartSound);
  
  prevTime = millis();
}

void draw()
{
  GetInputs(valueInputP1, arduinoP1);
  GetInputs(valueInputP2, arduinoP2);
  buttonReleased();
  buttonPressed();
  
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
      stopAllRumble(arduinoP1);
      stopAllLED(arduinoP1);
      stopAllRumble(arduinoP2);
      stopAllLED(arduinoP2);
      
      audioFill.rewind();
      audioFill.play();
      delay(timerFillSound);
      
      if (playerStartGame == PLAYER2)
      {
        ++current_bpm_index;
        if(current_bpm_index >= BPM.length)
        {
          current_bpm_index = BPM.length - 1;
        }
        setBPM(BPM[current_bpm_index]);
        setLedTempo(current_bpm_index);
        audioSpeedUp.rewind();
        audioSpeedUp.play();
        delay(timerSpeedUpSound);
      }
      
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
      stopAllRumble(arduinoP1);
      stopAllLED(arduinoP1);
      stopAllRumble(arduinoP2);
      stopAllLED(arduinoP2);
      
      audioFill.rewind();
      audioFill.play();
      delay(timerFillSound);
      
      if (playerStartGame == PLAYER1)
      {
        ++current_bpm_index;
        if(current_bpm_index >= BPM.length)
        {
          current_bpm_index = BPM.length - 1;
        }
        setBPM(BPM[current_bpm_index]);
        setLedTempo(current_bpm_index);
        audioSpeedUp.rewind();
        audioSpeedUp.play();
        delay(timerSpeedUpSound);
      }
      
      println("Player 1");
      canGetInput = false;
      waitNextTempo = false;
      currentState = stateReproductP1;
      currentTime = 0;
      prevTime = millis();
    } break;
    case stateFailReproductP1:
    {
      println("P1 lose");
      sequenceEndRound(PLAYER2, PLAYER1);
      endRound();
    } break;
    case stateFailReproductP2:
    {
      println("P2 lose");
      sequenceEndRound(PLAYER1, PLAYER2);
      endRound();
    } break;
  }
}

void endRound()
{
  println(listInputs);
  int nextTurn = stateReproductP2;
  if (playerStartGame == PLAYER1)
  {
    playerStartGame = PLAYER2;
    println("Player 2 Turn");
  }
  else
  {
    playerStartGame = PLAYER1;
    nextTurn = stateReproductP1;
    println("Player 1 Turn");
  }
  initGame();
  currentState = nextTurn;
}

void sequenceEndRound(int winner,int looser)
{
    Arduino arduinoWinner = winner == PLAYER1 ? arduinoP1 : arduinoP2;
    
    audioWin.rewind();
    audioWin.play();
    delay(timerWinSound);
    
    stopAllLED(arduinoP1);
    stopAllLED(arduinoP2);
    stopAllRumble(arduinoP1);
    stopAllRumble(arduinoP2);
    
    for (int i = 0; i < numberBlinkVictory; ++i)
    {
      fireAllLED(arduinoWinner);
      delay(timerChrismasTree);
      stopAllLED(arduinoWinner);
      delay(timerChrismasTree);
    }
}

void giveTempo()
{
  // Give the tempo
  delta = millis() - prevTime;
  currentTime += delta;
  if (!canGetInput && !waitNextTempo && currentTime >= tempo - spaceTimeGetInput[current_bpm_index] && currentTime <= tempo + spaceTimeGetInput[current_bpm_index])
  {
    canGetInput = true;
    println("Press");
    // Tempo player
    if (currentState == stateReproductP1 || currentState == stateRecordP1)
    {
      audioMetros.get(PLAYER1).rewind();
      audioMetros.get(PLAYER1).play();
    }
    else
    {
      audioMetros.get(PLAYER2).rewind();
      audioMetros.get(PLAYER2).play();
    }
     
    if((currentState == stateReproductP1 || currentState == stateReproductP2) && listInputs.get(currentInput) != blankInput && listInputs.get(currentInput) != blankInput * numberInputs)
    {
      int input = listInputs.get(currentInput);
      if (input >= numberInputs)
      {
        int pinLed = getLedPin(input - numberInputs);
        int pinRumble = getRumblePin(input - numberInputs);
        if (pinLed != -1)
          setPinState(arduinoP2, pinLed, Arduino.HIGH);
        if (pinRumble != -1)
          setPinState(arduinoP2, pinRumble ,Arduino.HIGH);
      }
      else
      {
        int pinLed = getLedPin(input);
        int pinRumble = getRumblePin(input);
        if (pinLed != -1)
          setPinState(arduinoP1, pinLed, Arduino.HIGH);
        if (pinRumble != -1)
          setPinState(arduinoP1, pinRumble ,Arduino.HIGH);
      }
    }
  }
  if (currentTime > tempo + spaceTimeGetInput[current_bpm_index] - spaceBlackGetInput)
  {
    if((currentState == stateReproductP1 || currentState == stateReproductP2) && listInputs.get(currentInput) != blankInput && listInputs.get(currentInput) != blankInput * numberInputs)
    {
      int input = listInputs.get(currentInput);
      if (input >= numberInputs)
      {
        int pinLed = getLedPin(input - numberInputs);
        int pinRumble = getRumblePin(input - numberInputs);
        if (pinLed != -1)
          setPinState(arduinoP2, pinLed, Arduino.LOW);
        if (pinRumble != -1)
          setPinState(arduinoP2, pinRumble ,Arduino.LOW);
      }
      else
      {
        int pinLed = getLedPin(input);
        int pinRumble = getRumblePin(input);
        if (pinLed != -1)
          setPinState(arduinoP1, pinLed, Arduino.LOW);
        if (pinRumble != -1)
          setPinState(arduinoP1, pinRumble ,Arduino.LOW);
      }
    }
  }
  if (currentTime > tempo + spaceTimeGetInput[current_bpm_index])
  {
    println("Stop Press");
    stopAllLED(arduinoP1);
    stopAllLED(arduinoP2);
    stopAllRumble(arduinoP1);
    stopAllRumble(arduinoP2);
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
          }
          else
          {
            stateFail = stateFailReproductP2;
            stateFinish = stateRecordP2;
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
              audioRecord.rewind();
              audioRecord.play();
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

void buttonPressed()
{
  int currentGeneralInputPress = getGeneralInput(((currentState == stateReproductP1 || currentState == stateRecordP1) ? PLAYER1 : PLAYER2));
  int normalizeInput = currentGeneralInputPress >= numberInputs ? currentGeneralInputPress - numberInputs : currentGeneralInputPress;
  if (!canGetInput && !waitNextTempo && currentGeneralInputPress != -1)
  {
    //audioError.rewind();
    //audioError.play();
  }
  if (canGetInput && currentGeneralInputPress != -1)
  {
    audioInputs.get(normalizeInput).rewind();
    audioInputs.get(normalizeInput).play();
    
    canGetInput = false; // Now we can't do an other input
    waitNextTempo = true;
    
    switch(currentState)
    {
      case stateReproductP1:
      case stateReproductP2:
      {
        // Get final state
        // Stop the rumble and the leds of this action
        stopAllRumble(arduinoP1);
        stopAllRumble(arduinoP2);
        stopAllLED(arduinoP1);
        stopAllLED(arduinoP2);
        
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
            audioError.rewind();
            audioError.play();
          } break;
          case stateFinishPress:
          {
            currentState = stateFinish;
            audioRecord.rewind();
            audioRecord.play();
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
        
        int pin = getLedPin(normalizeInput);
        if (pin != -1)
        {
          if (currentGeneralInputPress >= numberInputs)
          {
            setPinState(arduinoP2, pin, Arduino.HIGH);
            delay(timerLEDHighDuringRecord);
            setPinState(arduinoP2, pin, Arduino.LOW);
          }
          else
          {
            setPinState(arduinoP1, pin, Arduino.HIGH);
            delay(timerLEDHighDuringRecord);
            setPinState(arduinoP1, pin, Arduino.LOW);
          }
        }
        
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


int getGeneralInput(int player)
{
  // First test
  if (currentPinPressP1 != -1)
  {
    if (valueInputP1[currentPinPressP1])
    {
      println("currentPinPressP1");
      return currentPinPressP1;
    }
  }
  if (currentPinPressP2 != -1)
  {
    if (valueInputP2[currentPinPressP2 - numberInputs])
    {
      println("currentPinPressP2");
      return currentPinPressP2;
    }
  }
  
  // Player 1
  if (valueInputP1[buttonArmRightYellow])
  {
    currentPinPressP1 = buttonArmRightYellow;
    return currentPinPressP1;
  }
  else if (valueInputP1[buttonArmLeftGreen])
  {
    currentPinPressP1 = buttonArmLeftGreen;
    return currentPinPressP1;
  }
  else if (valueInputP1[buttonBoobsRed])
  {
    currentPinPressP1 = buttonBoobsRed;
    return currentPinPressP1;
  }
  else if (valueInputP1[buttonStomachBlue])
  {
    currentPinPressP1 = buttonStomachBlue;
    return currentPinPressP1;
  }
  else if (valueInputP1[buttonThighRightPink])
  {
    currentPinPressP1 = buttonThighRightPink;
    return currentPinPressP1;
  }
  else if (valueInputP1[buttonThighLeftOrange])
  {
    currentPinPressP1 = buttonThighLeftOrange;
    return currentPinPressP1;
  }
  
  // Player 2
  if (valueInputP2[buttonArmRightYellow])
  {
    currentPinPressP2 = buttonArmRightYellow + numberInputs;
    return currentPinPressP2;
  }
  else if (valueInputP2[buttonArmLeftGreen])
  {
    currentPinPressP2 = buttonArmLeftGreen + numberInputs;
    return currentPinPressP2;
  }
  else if (valueInputP2[buttonBoobsRed])
  {
    currentPinPressP2 = buttonBoobsRed + numberInputs;
    return currentPinPressP2;
  }
  else if (valueInputP2[buttonStomachBlue])
  {
    currentPinPressP2 = buttonStomachBlue + numberInputs;
    return currentPinPressP2;
  }
  else if (valueInputP2[buttonThighRightPink])
  {
    currentPinPressP2 = buttonThighRightPink + numberInputs;
    return currentPinPressP2;
  }
  else if (valueInputP2[buttonThighLeftOrange])
  {
    currentPinPressP2 = buttonThighLeftOrange + numberInputs;
    return currentPinPressP2;
  }
  return -1;
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
    // Fail the reproduction
    return stateFailPress;
  }
}

void buttonReleased()
{
  switch(currentState)
  {
    case stateRecordP1:
    case stateRecordP2:
    case stateChangePlayerP1toP2:
    case stateChangePlayerP2toP1:
    {
      if (checkKeyReleased((currentState == stateRecordP1 || currentState == stateChangePlayerP1toP2) ? PLAYER1 : PLAYER2))
      {
        stopAllLED(arduinoP1);
        stopAllLED(arduinoP2);
      }
    } break;
    default:
    {
        //currentPinPressP1 = -1;
        //currentPinPressP2 = -1;
    } break;
  }
}

boolean checkKeyReleased(int player)
{
  if (currentPinPressP1 != -1)
  {
    if (valueInputP1[currentPinPressP1])
    {
      currentPinPressP1 = -1;
      return true;
    }
  }
  if (currentPinPressP2 != -1)
  {
    if (valueInputP2[currentPinPressP2 - numberInputs])
    {
      currentPinPressP2 = -1;
      return true;
    }
  }
  return false;
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
    setPinState(arduinoP1, ledTempo[i], l);
    setPinState(arduinoP2, ledTempo[i], l);
  }
}

void stop()
{
  // Stop all
  stopAllRumble(arduinoP1);
  stopAllRumble(arduinoP2);
  stopAllLED(arduinoP1);
  stopAllLED(arduinoP2);
  
  // Stop all sounds
  audioBG.close();
  audioWin.close();
  audioAreYouReady.close();
  audioStart.close();
  audioSpeedUp.close();
  audioFill.close();
  audioRecord.close();
  audioError.close();
  for (int i = 0; i < numberInputs; ++i)
    audioInputs.get(i).close();
  for(int i = 0 ; i < audioMetros.size();++i)
     audioMetros.get(i).close();
  
  // the AudioInput you got from Minim.getLineIn()
  minim.stop();
 
  // this calls the stop method that 
  // you are overriding by defining your own
  // it must be called so that your application 
  // can do all the cleanup it would normally do
  super.stop();
}
