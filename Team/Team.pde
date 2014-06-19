import processing.serial.*;
import cc.arduino.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


// GD can change this values
final int timerByInput = 1000; // Timer in millisecond
final int timerNextTurn = 1000; // Timer in millisecond
final int numberStartTurnDisco = 100; // Number start turns of disco
final int numberEndTurnDisco = 100; // Number end turns of disco
final int numberInputChangeByDisco = 5;
final int timerAfterChangementDisco = 300; // Timer in millisecond

// Sounds
final String BGSound = "Music/background.wav";
final String buttonArmRightYellowSound = "Music/inputs/Fx_input (1).wav";
final String buttonArmLeftGreenSound = "Music/inputs/Fx_input (2).wav";
final String buttonBoobsRedSound = "Music/inputs/Fx_input (3).wav";
final String buttonStomachBlueSound = "Music/inputs/Fx_input (4).wav";
final String buttonThighRightPinkSound = "Music/inputs/Fx_input (5).wav";
final String buttonThighLeftOrangeSound = "Music/inputs/Fx_input (6).wav";
final String winSound = "Music/voices/win.wav";
final int timerWinSound = 1680; // Timer in millisecond
final String areYouReadySound = "Music/voices/ready.wav";
final int timerAreYouReadySound = 1500; // Timer in millisecond
final String startSound = "Music/voices/start.wav";
final int timerStartSound = 1130; // Timer in millisecond
final String errorSound = "Music/error.wav";

// Inputs
final int numberInputs = 6;
final int blankInput = numberInputs * 2;

// arduino id
final int PLAYER1 = 0;
final int PLAYER2 = 1;

// Varibles game
Arduino arduinoP1;
Arduino arduinoP2;
boolean[] valueInputP1 = new boolean[numberInputs];
boolean[] valueInputP2 = new boolean[numberInputs];
boolean[] currentPinPressP1 = new boolean[numberInputs];
boolean[] currentPinPressP2 = new boolean[numberInputs];

// Game state
IntList listInputsP1 = new IntList();
IntList listInputsP2 = new IntList();
boolean badInputP1;
boolean badInputP2;

// Music
Minim minim;
AudioPlayer audioBG;
ArrayList<AudioPlayer> audioInputs;
AudioPlayer audioWin;
AudioPlayer audioAreYouReady;
AudioPlayer audioStart;
AudioPlayer audioError;

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
  
  audioWin = minim.loadFile(winSound);
  audioAreYouReady = minim.loadFile(areYouReadySound);
  audioStart = minim.loadFile(startSound);
  audioError = minim.loadFile(errorSound);
  
  // Init the arduinos
  println(Arduino.list());
  arduinoP1 = new Arduino(this, Arduino.list()[0]);
  arduinoP2 = new Arduino(this, Arduino.list()[1]);
  
  // Init input tab
  for (int i = 0; i < numberInputs; ++i)
  {
    currentPinPressP1[i] = false;
    currentPinPressP2[i] = false;
  }
  InitInputs(valueInputP1, arduinoP1);
  InitInputs(valueInputP2, arduinoP2);
  
  // Funk
  for (int i = 0; i < numberStartTurnDisco; ++i)
  {
    for (int j = 0; j < numberInputChangeByDisco; ++j)
    {
      setPinState(arduinoP1, getLedPin((int)random(numberInputs)), (int)random(2));
      setPinState(arduinoP2, getLedPin((int)random(numberInputs)), (int)random(2));
    }
    if (i == numberStartTurnDisco - 1)
      delay(timerAfterChangementDisco);
  }
  stopAllRumble(arduinoP1);
  stopAllRumble(arduinoP2);
  stopAllLED(arduinoP1);
  stopAllLED(arduinoP2);
  
  // Init the game
  initGame();
}

void initGame()
{
  // Init var game
  badInputP1 = false;
  badInputP2 = false;
  
  // Warn players that the game will start
  audioAreYouReady.rewind();
  audioAreYouReady.play();
  delay(timerAreYouReadySound);
  
  // Warn players that the game will start
  audioStart.rewind();
  audioStart.play();
  delay(timerStartSound);
  
  // Initialize the round
  newRound();
}

void newRound()
{
  // Init var game
  int numberInputsToGenerate = (int)random(numberInputs);
  IntList listInputsToAdd = new IntList();
  for (int i = 0; i < numberInputs; ++i)
  {
    listInputsToAdd.append(i);
  }
  int i = 0;
  listInputsP1.clear();
  listInputsP2.clear();
  while (i <= numberInputsToGenerate)
  {
    int index = (int)random(listInputsToAdd.size() - 1);
    int indexButton = listInputsToAdd.get(index);
    setPinState(arduinoP2, getLedPin(indexButton), Arduino.HIGH);
    setPinState(arduinoP2, getRumblePin(indexButton), Arduino.HIGH);
    setPinState(arduinoP1, getLedPin(indexButton), Arduino.HIGH);
    setPinState(arduinoP1, getRumblePin(indexButton), Arduino.HIGH);
    listInputsP1.append(indexButton);
    listInputsP2.append(indexButton);
    listInputsToAdd.remove(index);
    i++;
  }
  println("listInputsP1 " + listInputsP1);
}

void endGame(Arduino winner)
{
  // Stop all
  stopAllRumble(arduinoP1);
  stopAllRumble(arduinoP2);
  stopAllLED(arduinoP1);
  stopAllLED(arduinoP2);
  
  // Sound winner
  audioWin.rewind();
  audioWin.play();
  delay(timerWinSound);
  
  // Funk
  for (int i = 0; i < numberEndTurnDisco; ++i)
  {
    for (int j = 0; j < numberInputChangeByDisco; ++j)
    {
      setPinState(winner, getLedPin((int)random(numberInputs)), (int)random(2));
    }
    if (i == numberEndTurnDisco - 1)
      delay(timerAfterChangementDisco);
  }
  stopAllRumble(winner);
  stopAllLED(winner);
  
  // Reset
  initGame();
}

void draw()
{
  GetInputs(valueInputP1, arduinoP1);
  GetInputs(valueInputP2, arduinoP2);
  buttonState();
  
  // End round
  if (badInputP1)
  {
    println("End round! P1 lose!");
    audioError.rewind();
    audioError.play();
    endGame(arduinoP2);
  }
  else if (badInputP2)
  {
    println("End round! P2 lose!");
    audioError.rewind();
    audioError.play();
    endGame(arduinoP1);
  }
  else if (listInputsP1.size() == 0)
  {
    println("End round! P1 win!");
    endGame(arduinoP1);
  }
  else if (listInputsP2.size() == 0)
  {
    println("End round! P2 win!");
    endGame(arduinoP2);
  }
}

void buttonState()
{
  for (int i = 0; i < numberInputs; ++i)
  {
    int pinLed = getLedPin(i);
    int rumbleLed = getRumblePin(i);
    // Player 1
    if (!currentPinPressP1[i] && valueInputP1[i])
    {
      currentPinPressP1[i] = true;
      boolean find = false;
      for (int j = 0; j < listInputsP1.size() && !find; ++j)
      {
        if (listInputsP1.get(j) == i)
        {
          listInputsP1.remove(j);
          find = true;
        }
      }
      if (find)
      {
        audioInputs.get(i).rewind();
        audioInputs.get(i).play();
        setPinState(arduinoP1, pinLed, Arduino.LOW);
        setPinState(arduinoP1, rumbleLed, Arduino.LOW);
      }
      else
      {
        badInputP1 = true;
      }
    }
    else if (!valueInputP1[i])
    {
      currentPinPressP1[i] = false;
    }
    // Player 2
    if (!currentPinPressP2[i] && valueInputP2[i])
    {
      currentPinPressP2[i] = true;
      boolean find = false;
      for (int j = 0; j < listInputsP2.size() && !find; ++j)
      {
        if (listInputsP2.get(j) == i)
        {
          listInputsP2.remove(j);
          find = true;
        }
      }
      if (find)
      {
        audioInputs.get(i).rewind();
        audioInputs.get(i).play();
        setPinState(arduinoP2, pinLed, Arduino.LOW);
        setPinState(arduinoP2, rumbleLed, Arduino.LOW);
      }
      else
      {
        badInputP2 = true;
      }
    }
    else if (!valueInputP2[i])
    {
      currentPinPressP2[i] = false;
    }
  }
}

void stop()
{
  // Stop all
  stopAllRumble(arduinoP1);
  stopAllRumble(arduinoP2);
  stopAllLED(arduinoP1);
  stopAllLED(arduinoP2);
  
  audioBG.close();
  audioAreYouReady.close();
  audioStart.close();
  audioError.close();
  for (int i = 0; i < numberInputs; ++i)
    audioInputs.get(i).close();
  
  // the AudioInput you got from Minim.getLineIn()
  minim.stop();
 
  // this calls the stop method that 
  // you are overriding by defining your own
  // it must be called so that your application 
  // can do all the cleanup it would normally do
  super.stop();
}
