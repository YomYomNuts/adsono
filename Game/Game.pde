import processing.serial.*;
import cc.arduino.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


// GD can change this values
final int spaceTimeGetInput = 1500; // Give a value that can divide by 2 in millisecond
final int spaceBlackGetInput = 50; // Timer in millisecond
final int numberInputByMesure = 2;
final int timerLaunchRumbleDuringChangementPlayer = 3; // Timer in frame
final int timerChrismasTree = 500; // Timer in millisecond
final int BPM[] = {30,45,60,90,120};
final int timerLEDHighDuringRecord = 200; // Timer in millisecond
final int timerLEDHighDuringComputerRandom = 500; // Timer in millisecond
final int timerLEDLowDuringComputerRandom = 500; // Timer in millisecond
final int numberBlinkVictory = 3;

// Sounds
final String BGSound = "Music/background.wav";
final String buttonArmRightPinkSound = "Music/inputs/Fx_input (1).wav";
final String buttonArmLeftOrangeSound = "Music/inputs/Fx_input (2).wav";
final String buttonBoobsBlueSound = "Music/inputs/Fx_input (3).wav";
final String buttonStomachRedSound = "Music/inputs/Fx_input (4).wav";
final String buttonThighRightYellowSound = "Music/inputs/Fx_input (5).wav";
final String buttonThighLeftGreenSound = "Music/inputs/Fx_input (6).wav";
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

// Correlation input
final int buttonArmRightPink = 0;
final int buttonArmLeftOrange = 1;
final int buttonBoobsBlue = 2;
final int buttonStomachRed = 3;
final int buttonThighRightYellow = 4;
final int buttonThighLeftGreen = 5;
final int blankInput = 6;
final int numberInputs = 7;
final int valuePressButtonAnalog = 1023;

// State input press
final int stateFailPress = 0;
final int stateGoodPress = 1;
final int stateFinishPress = 2;

// Rumble pin
final int rumbleArmRightPink = 48;
final int rumbleArmLeftOrange = 49;
final int rumbleBoobsBlue = 50;
final int rumbleStomachRed = 51;
final int rumbleThighRightYellow = 52;
final int rumbleThighLeftGreen = 53;

// Led pin
final int ledArmRightPink = 8;
final int ledArmLeftOrange = 9;
final int ledBoobsBlue = 10;
final int ledStomachRed = 11;
final int ledThighRightYellow = 7;
final int ledThighLeftGreen = 13;

// arduino id
final int PLAYER1 = 0;
final int PLAYER2 = 1;

// Led tempo pin
final int ledTempo[] = { 22, 23, 24, 25, 26, 27 };

// Varibles game
Arduino arduinoP1;
Arduino arduinoP2;
int[] valueAnalogButtonP1 = new int[6];
int[] valueAnalogButtonP2 = new int[6];
// Game state
int currentState;
IntList listInputs;
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
  audioInputs.add(minim.loadFile(buttonArmRightPinkSound));
  audioInputs.add(minim.loadFile(buttonArmLeftOrangeSound));
  audioInputs.add(minim.loadFile(buttonBoobsBlueSound));
  audioInputs.add(minim.loadFile(buttonStomachRedSound));
  audioInputs.add(minim.loadFile(buttonThighRightYellowSound));
  audioInputs.add(minim.loadFile(buttonThighLeftGreenSound));
  
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
  
  // Init analog tab
  valueAnalogButtonP1[buttonArmRightPink] = arduinoP1.analogRead(buttonArmRightPink);
  valueAnalogButtonP1[buttonArmLeftOrange] = arduinoP1.analogRead(buttonArmLeftOrange);
  valueAnalogButtonP1[buttonBoobsBlue] = arduinoP1.analogRead(buttonBoobsBlue);
  valueAnalogButtonP1[buttonStomachRed] = arduinoP1.analogRead(buttonStomachRed);
  valueAnalogButtonP1[buttonThighRightYellow] = arduinoP1.analogRead(buttonThighRightYellow);
  valueAnalogButtonP1[buttonThighLeftGreen] = arduinoP1.analogRead(buttonThighLeftGreen);
  valueAnalogButtonP2[buttonArmRightPink] = arduinoP2.analogRead(buttonArmRightPink);
  valueAnalogButtonP2[buttonArmLeftOrange] = arduinoP2.analogRead(buttonArmLeftOrange);
  valueAnalogButtonP2[buttonBoobsBlue] = arduinoP2.analogRead(buttonBoobsBlue);
  valueAnalogButtonP2[buttonStomachRed] = arduinoP2.analogRead(buttonStomachRed);
  valueAnalogButtonP2[buttonThighRightYellow] = arduinoP2.analogRead(buttonThighRightYellow);
  valueAnalogButtonP2[buttonThighLeftGreen] = arduinoP2.analogRead(buttonThighLeftGreen);
  
  // Init var game
  listInputs = new IntList();
  initGame();
  playerStartGame = PLAYER1;
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
  int pinLed = getLedPin(listInputs.get(0));
  if (pinLed != -1)
  {
    setPinState(PLAYER1,pinLed,Arduino.HIGH);
    setPinState(PLAYER2,pinLed,Arduino.HIGH);
    audioInputs.get(listInputs.get(0)).rewind();
    audioInputs.get(listInputs.get(0)).play();
  }
  delay(timerLEDHighDuringComputerRandom);
  if (pinLed != -1)
  {
    setPinState(PLAYER1,pinLed,Arduino.LOW);
    setPinState(PLAYER2,pinLed,Arduino.LOW);
    audioInputs.get(listInputs.get(0)).rewind();
    audioInputs.get(listInputs.get(0)).play();
  }
  delay(timerLEDLowDuringComputerRandom);
  
  listInputs.append((int)random(numberInputs));
  pinLed = getLedPin(listInputs.get(1));
  if (pinLed != -1)
  {
    setPinState(PLAYER1,pinLed,Arduino.HIGH);
    setPinState(PLAYER2,pinLed,Arduino.HIGH);
  }
  delay(timerLEDHighDuringComputerRandom);
  if (pinLed != -1)
  {
    setPinState(PLAYER1,pinLed,Arduino.LOW);
    setPinState(PLAYER2,pinLed,Arduino.LOW);
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
    setPinState(PLAYER1,ledTempo[i],Arduino.HIGH);
    setPinState(PLAYER2,ledTempo[i],Arduino.HIGH);
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
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER2,rumbleThighRightYellow,Arduino.HIGH);
      setPinState(PLAYER2,rumbleThighLeftGreen,Arduino.HIGH);
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER2,rumbleBoobsBlue,Arduino.HIGH);
      setPinState(PLAYER2,rumbleStomachRed,Arduino.HIGH);
      
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER2,rumbleArmRightPink,Arduino.HIGH);
      setPinState(PLAYER2,rumbleArmLeftOrange,Arduino.HIGH);
      delay(timerLaunchRumbleDuringChangementPlayer);
      stopAllRumble(PLAYER2);
      stopAllLED(PLAYER2);
      delay(timerLaunchRumbleDuringChangementPlayer);
      
      audioFill.rewind();
      audioFill.play();
      delay(timerFillSound);
      
      if (playerStartGame == PLAYER2)
      {
        current_bpm_index ++;
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
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER1,rumbleThighRightYellow,Arduino.HIGH);
      setPinState(PLAYER1,rumbleThighLeftGreen,Arduino.HIGH);
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER1,rumbleBoobsBlue,Arduino.HIGH);
      setPinState(PLAYER1,rumbleStomachRed,Arduino.HIGH);
      
      delay(timerLaunchRumbleDuringChangementPlayer);
      setPinState(PLAYER1,rumbleArmRightPink,Arduino.HIGH);
      setPinState(PLAYER1,rumbleArmLeftOrange,Arduino.HIGH);
      stopAllRumble(PLAYER1);
      stopAllLED(PLAYER1);
      delay(timerLaunchRumbleDuringChangementPlayer);
      
      audioFill.rewind();
      audioFill.play();
      delay(timerFillSound);
      
      if (playerStartGame == PLAYER1)
      {
        current_bpm_index ++;
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
    println("Player 2 Turn");
  }
  else
  {
    playerStartGame = PLAYER1;
    currentState = stateReproductP1;
    println("Player 1 Turn");
  }
}

void sequenceEndRound(int winner,int looser)
{
    audioWin.rewind();
    audioWin.play();
    delay(timerWinSound);
    
    stopAllLED(PLAYER1);
    stopAllLED(PLAYER2);
    stopAllRumble(PLAYER1);
    stopAllRumble(PLAYER2);
    
    for (int i = 0; i < numberBlinkVictory; ++i)
    {
      fireAllLED(winner);
      delay(timerChrismasTree);
      stopAllLED(winner);
      delay(timerChrismasTree);
    }
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
      audioMetros.get(PLAYER1).rewind();
      audioMetros.get(PLAYER1).play();
     
      if(currentState == stateReproductP1 && listInputs.get(currentInput) != blankInput)
      {
        int pinLed = getLedPin(listInputs.get(currentInput));
        int pinRumble = getRumblePin(listInputs.get(currentInput));
        if (pinLed != -1)
          setPinState(PLAYER1,pinLed,Arduino.HIGH);
        if (pinRumble != -1)
          setPinState(PLAYER1,pinRumble,Arduino.HIGH);
      }
    }
    else
    {
      audioMetros.get(PLAYER2).rewind();
      audioMetros.get(PLAYER2).play();
      
      if(currentState == stateReproductP2 && listInputs.get(currentInput) != blankInput)
      {
        int pinLed = getLedPin(listInputs.get(currentInput));
        int pinRumble = getRumblePin(listInputs.get(currentInput));
        if (pinLed != -1)
          setPinState(PLAYER2,pinLed,Arduino.HIGH);
        if (pinRumble != -1)
          setPinState(PLAYER2,pinRumble,Arduino.HIGH);
      }
    }
  }
  if (currentTime > tempo + spaceTimeGetInput/2 - spaceBlackGetInput)
  {
    if(currentState == stateReproductP1 && listInputs.get(currentInput) != blankInput)
    {
      int pinLed = getLedPin(listInputs.get(currentInput));
      int pinRumble = getRumblePin(listInputs.get(currentInput));
      if (pinLed != -1)
        setPinState(PLAYER1,pinLed,Arduino.LOW);
      if (pinRumble != -1)
        setPinState(PLAYER1,pinRumble,Arduino.LOW);
    }
    else if(currentState == stateReproductP2 && listInputs.get(currentInput) != blankInput)
    {
      int pinLed = getLedPin(listInputs.get(currentInput));
      int pinRumble = getRumblePin(listInputs.get(currentInput));
      if (pinLed != -1)
        setPinState(PLAYER2,pinLed,Arduino.LOW);
      if (pinRumble != -1)
        setPinState(PLAYER2,pinRumble,Arduino.LOW);
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
  println(key);
  println(currentGeneralInputPress);
  if (!canGetInput && currentGeneralInputPress != -1)
  {
    audioError.rewind();
    audioError.play();
  }
  if (canGetInput && currentGeneralInputPress != -1)
  {
    audioInputs.get(currentGeneralInputPress).rewind();
    audioInputs.get(currentGeneralInputPress).play();
    
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
        // Stop the rumble and the leds of this action
        
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
        
        int pin = getLedPin(currentGeneralInputPress);
        if (pin != -1)
        {
          setPinState(PLAYER1,pin,Arduino.HIGH);
          setPinState(PLAYER2,pin,Arduino.HIGH);
        }
        
        delay(timerLEDHighDuringRecord);
        if (currentState == stateRecordP1)
        {
          stopAllLED(PLAYER1);
        }
        else
        {
          stopAllLED(PLAYER2);
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
  if (player == PLAYER1)
  {
    if (arduinoP1.analogRead(buttonArmRightPink) == valuePressButtonAnalog && valueAnalogButtonP1[buttonArmRightPink] != valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonArmRightPink] = arduinoP1.analogRead(buttonArmRightPink);
      return buttonArmRightPink;
    }
    else if (arduinoP1.analogRead(buttonArmLeftOrange) == valuePressButtonAnalog && valueAnalogButtonP1[buttonArmLeftOrange] != valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonArmLeftOrange] = arduinoP1.analogRead(buttonArmLeftOrange);
      return buttonArmLeftOrange;
    }
    else if (arduinoP1.analogRead(buttonBoobsBlue) == valuePressButtonAnalog && valueAnalogButtonP1[buttonBoobsBlue] != valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonBoobsBlue] = arduinoP1.analogRead(buttonBoobsBlue);
      return buttonBoobsBlue;
    }
    else if (arduinoP1.analogRead(buttonStomachRed) == valuePressButtonAnalog && valueAnalogButtonP1[buttonStomachRed] != valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonStomachRed] = arduinoP1.analogRead(buttonStomachRed);
      return buttonStomachRed;
    }
    else if (arduinoP1.analogRead(buttonThighRightYellow) == valuePressButtonAnalog && valueAnalogButtonP1[buttonThighRightYellow] != valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonThighRightYellow] = arduinoP1.analogRead(buttonThighRightYellow);
      return buttonThighRightYellow;
    }
    else if (arduinoP1.analogRead(buttonThighLeftGreen) == valuePressButtonAnalog && valueAnalogButtonP1[buttonThighLeftGreen] != valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonThighLeftGreen] = arduinoP1.analogRead(buttonThighLeftGreen);
      return buttonThighLeftGreen;
    }
  }
  else
  {
    if (arduinoP2.analogRead(buttonArmRightPink) == valuePressButtonAnalog && valueAnalogButtonP2[buttonArmRightPink] != valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonArmRightPink] = arduinoP2.analogRead(buttonArmRightPink);
      return buttonArmRightPink;
    }
    else if (arduinoP2.analogRead(buttonArmLeftOrange) == valuePressButtonAnalog && valueAnalogButtonP2[buttonArmLeftOrange] != valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonArmLeftOrange] = arduinoP2.analogRead(buttonArmLeftOrange);
      return buttonArmLeftOrange;
    }
    else if (arduinoP2.analogRead(buttonBoobsBlue) == valuePressButtonAnalog && valueAnalogButtonP2[buttonBoobsBlue] != valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonBoobsBlue] = arduinoP2.analogRead(buttonBoobsBlue);
      return buttonBoobsBlue;
    }
    else if (arduinoP2.analogRead(buttonStomachRed) == valuePressButtonAnalog && valueAnalogButtonP2[buttonStomachRed] != valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonStomachRed] = arduinoP2.analogRead(buttonStomachRed);
      return buttonStomachRed;
    }
    else if (arduinoP2.analogRead(buttonThighRightYellow) == valuePressButtonAnalog && valueAnalogButtonP2[buttonThighRightYellow] != valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonThighRightYellow] = arduinoP2.analogRead(buttonThighRightYellow);
      return buttonThighRightYellow;
    }
    else if (arduinoP2.analogRead(buttonThighLeftGreen) == valuePressButtonAnalog && valueAnalogButtonP2[buttonThighLeftGreen] != valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonThighLeftGreen] = arduinoP2.analogRead(buttonThighLeftGreen);
      return buttonThighLeftGreen;
    }
  }
  return -1;
}

int getLedPin(int input)
{
  switch (input)
  {
     case buttonArmRightPink : 
       return ledArmRightPink;
     case buttonArmLeftOrange : 
       return ledArmLeftOrange;
     case buttonBoobsBlue : 
       return ledBoobsBlue;
     case buttonStomachRed : 
       return ledStomachRed;
     case buttonThighRightYellow : 
       return ledThighRightYellow;
     case buttonThighLeftGreen : 
       return ledThighLeftGreen;
   }
   return -1;
}
int getRumblePin(int input)
{
  switch (input)
  {
     case buttonArmRightPink : 
       return rumbleArmRightPink;
     case buttonArmLeftOrange : 
       return rumbleArmLeftOrange;
     case buttonBoobsBlue : 
       return rumbleBoobsBlue;
     case buttonStomachRed : 
       return rumbleStomachRed;
     case buttonThighRightYellow : 
       return rumbleThighRightYellow;
     case buttonThighLeftGreen : 
       return rumbleThighLeftGreen;
  }
  return -1;
}

void stopAllRumble(int player)
{
  setPinState(player,rumbleArmRightPink,Arduino.LOW);
  setPinState(player,rumbleArmLeftOrange,Arduino.LOW);
  setPinState(player,rumbleBoobsBlue,Arduino.LOW);
  setPinState(player,rumbleStomachRed,Arduino.LOW);
  setPinState(player,rumbleThighRightYellow,Arduino.LOW);
  setPinState(player,rumbleThighLeftGreen,Arduino.LOW);
}

void stopAllLED(int player)
{
  setPinState(player,ledArmRightPink,Arduino.LOW);
  setPinState(player,ledArmLeftOrange,Arduino.LOW);
  setPinState(player,ledBoobsBlue,Arduino.LOW);
  setPinState(player,ledStomachRed,Arduino.LOW);
  setPinState(player,ledThighRightYellow,Arduino.LOW);
  setPinState(player,ledThighLeftGreen,Arduino.LOW);
}

void fireAllLED(int player)
{
  setPinState(player,ledArmRightPink,Arduino.HIGH);
  setPinState(player,ledArmLeftOrange,Arduino.HIGH);
  setPinState(player,ledBoobsBlue,Arduino.HIGH);
  setPinState(player,ledStomachRed,Arduino.HIGH);
  setPinState(player,ledThighRightYellow,Arduino.HIGH);
  setPinState(player,ledThighLeftGreen,Arduino.HIGH);
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
        stopAllLED(PLAYER1);
        stopAllLED(PLAYER2);
      }
    } break;
  }
}

boolean checkKeyReleased(int player)
{
  if (player == PLAYER1)
  {
    if (arduinoP1.analogRead(buttonArmRightPink) != valuePressButtonAnalog && valueAnalogButtonP1[buttonArmRightPink] == valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonArmRightPink] = arduinoP1.analogRead(buttonArmRightPink);
      return true;
    }
    else if (arduinoP1.analogRead(buttonArmLeftOrange) != valuePressButtonAnalog && valueAnalogButtonP1[buttonArmLeftOrange] == valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonArmLeftOrange] = arduinoP1.analogRead(buttonArmLeftOrange);
      return true;
    }
    else if (arduinoP1.analogRead(buttonBoobsBlue) != valuePressButtonAnalog && valueAnalogButtonP1[buttonBoobsBlue] == valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonBoobsBlue] = arduinoP1.analogRead(buttonBoobsBlue);
      return true;
    }
    else if (arduinoP1.analogRead(buttonStomachRed) != valuePressButtonAnalog && valueAnalogButtonP1[buttonStomachRed] == valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonStomachRed] = arduinoP1.analogRead(buttonStomachRed);
      return true;
    }
    else if (arduinoP1.analogRead(buttonThighRightYellow) != valuePressButtonAnalog && valueAnalogButtonP1[buttonThighRightYellow] == valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonThighRightYellow] = arduinoP1.analogRead(buttonThighRightYellow);
      return true;
    }
    else if (arduinoP1.analogRead(buttonThighLeftGreen) != valuePressButtonAnalog && valueAnalogButtonP1[buttonThighLeftGreen] == valuePressButtonAnalog)
    {
      valueAnalogButtonP1[buttonThighLeftGreen] = arduinoP1.analogRead(buttonThighLeftGreen);
      return true;
    }
  }
  else
  {
    if (arduinoP2.analogRead(buttonArmRightPink) != valuePressButtonAnalog && valueAnalogButtonP2[buttonArmRightPink] == valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonArmRightPink] = arduinoP2.analogRead(buttonArmRightPink);
      return true;
    }
    else if (arduinoP2.analogRead(buttonArmLeftOrange) != valuePressButtonAnalog && valueAnalogButtonP2[buttonArmLeftOrange] == valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonArmLeftOrange] = arduinoP2.analogRead(buttonArmLeftOrange);
      return true;
    }
    else if (arduinoP2.analogRead(buttonBoobsBlue) != valuePressButtonAnalog && valueAnalogButtonP2[buttonBoobsBlue] == valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonBoobsBlue] = arduinoP2.analogRead(buttonBoobsBlue);
      return true;
    }
    else if (arduinoP2.analogRead(buttonStomachRed) != valuePressButtonAnalog && valueAnalogButtonP2[buttonStomachRed] == valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonStomachRed] = arduinoP2.analogRead(buttonStomachRed);
      return true;
    }
    else if (arduinoP2.analogRead(buttonThighRightYellow) != valuePressButtonAnalog && valueAnalogButtonP2[buttonThighRightYellow] == valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonThighRightYellow] = arduinoP2.analogRead(buttonThighRightYellow);
      return true;
    }
    else if (arduinoP2.analogRead(buttonThighLeftGreen) != valuePressButtonAnalog && valueAnalogButtonP2[buttonThighLeftGreen] == valuePressButtonAnalog)
    {
      valueAnalogButtonP2[buttonThighLeftGreen] = arduinoP2.analogRead(buttonThighLeftGreen);
      return true;
    }
  }
  return false;
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
  for(int i = 0 ; i < audioMetros.size();++i)
  {
     audioMetros.get(i).close();
  }
  // the AudioInput you got from Minim.getLineIn()
  minim.stop();
 
  // this calls the stop method that 
  // you are overriding by defining your own
  // it must be called so that your application 
  // can do all the cleanup it would normally do
  super.stop();
}
