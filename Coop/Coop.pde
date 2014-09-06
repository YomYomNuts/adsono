import processing.serial.*;
import cc.arduino.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


// GD can change this values
final boolean firstArduino = true;
final int timerStart = 1000; // Timer in millisecond
final int timerByInput = 1500; // Timer in millisecond
final int timerNextTurn = 1000; // Timer in millisecond
final int numberStartTurnDisco = 100; // Number start turns of disco
final int numberTurnDisco = 10; // Number minimal turns of disco
final int maxTurnDiscoToAdd = 100; // Number maximal turns of disco
final int numberInputChangeByDisco = 5;
final int timerAfterChangementDisco = 150; // Timer in millisecond
final int addButtonAllRound = 10;
final int timerEndOpportinity = 150; // Timer in millisecond

// Sounds
final String BGSound = "Music/background.wav";
final String buttonYellowSound = "Music/inputs/Fx_input (1).wav";
final String buttonGreenSound = "Music/inputs/Fx_input (2).wav";
final String buttonRedSound = "Music/inputs/Fx_input (3).wav";
final String buttonBlueSound = "Music/inputs/Fx_input (4).wav";
final String buttonWhiteSound = "Music/inputs/Fx_input (5).wav";
final String areYouReadySound = "Music/voices/ready.wav";
final int timerAreYouReadySound = 1500; // Timer in millisecond
final String startSound = "Music/voices/start.wav";
final int timerStartSound = 1130; // Timer in millisecond
final String errorSound = "Music/error.wav";

// Inputs
final int numberInputs = 5;
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
int listInputsImpossible[] = {};
IntList listInputs = new IntList();
int numberRound;
int endTimerInput;
boolean badInput;
int prevTime;

// Music
Minim minim;
AudioPlayer audioBG;
ArrayList<AudioPlayer> audioInputs;
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
  audioInputs.add(minim.loadFile(buttonYellowSound));
  audioInputs.add(minim.loadFile(buttonGreenSound));
  audioInputs.add(minim.loadFile(buttonRedSound));
  audioInputs.add(minim.loadFile(buttonBlueSound));
  audioInputs.add(minim.loadFile(buttonWhiteSound));
  
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
  InitInputs(valueInputP1, arduinoP1, firstArduino);
  InitInputs(valueInputP2, arduinoP2, !firstArduino);
  
  // Funk
  for (int i = 0; i < numberStartTurnDisco; ++i)
  {
    for (int j = 0; j < numberInputChangeByDisco; ++j)
    {
      setPinState(arduinoP1, getLedPin((int)random(numberInputs), firstArduino), (int)random(2));
      setPinState(arduinoP2, getLedPin((int)random(numberInputs), !firstArduino), (int)random(2));
    }
    if (i == numberStartTurnDisco - 1)
      delay(timerAfterChangementDisco);
  }
  stopAllRumble(arduinoP1);
  stopAllRumble(arduinoP2);
  stopAllLED(arduinoP1, firstArduino);
  stopAllLED(arduinoP2, !firstArduino);
  
  // Init the game
  initGame();
}

void initGame()
{
  // Init var game
  numberRound = 0;
  badInput = false;
  
  // Warn players that the game will start
  audioAreYouReady.rewind();
  audioAreYouReady.play();
  delay(timerAreYouReadySound);
  audioStart.rewind();
  audioStart.play();
  delay(timerStartSound);
  
  // Initialize the round
  newRound();
}

void newRound()
{
  // Init var game
  int numberInputsToGenerate = 1 + numberRound / addButtonAllRound;
  if (numberInputsToGenerate > numberInputs * 2 - listInputsImpossible.length)
    numberInputsToGenerate = numberInputs * 2 - listInputsImpossible.length;
  endTimerInput = timerStart + timerByInput * numberInputsToGenerate;
  IntList listInputsToAdd = new IntList();
  for (int i = 0; i < numberInputs; ++i)
  {
    boolean find1 = false, find2 = false;
    for (int j = 0; j < listInputsImpossible.length; ++j)
    {
      if (listInputsImpossible[j] == i)
        find1 = true;
      if (listInputsImpossible[j] == i + numberInputs)
        find2 = true;
    }
    if (!find1)
      listInputsToAdd.append(i);
    if (!find2)
      listInputsToAdd.append(i + numberInputs);
  }
  int i = 0;
  listInputs.clear();
  while (i < numberInputsToGenerate)
  {
    int index = (int)random(listInputsToAdd.size());
    int indexButton = listInputsToAdd.get(index);
    if (indexButton >= numberInputs)
    {
      setPinState(arduinoP2, getLedPin(indexButton - numberInputs, !firstArduino), Arduino.HIGH);
      setPinState(arduinoP2, getRumblePin(indexButton - numberInputs), Arduino.HIGH);
    }
    else
    {
      setPinState(arduinoP1, getLedPin(indexButton, firstArduino), Arduino.HIGH);
      setPinState(arduinoP1, getRumblePin(indexButton), Arduino.HIGH);
    }
    listInputs.append(indexButton);
    listInputsToAdd.remove(index);
    i++;
  }
  println("listInputs " + listInputs);
  
  prevTime = millis();
}

void endGame()
{
  // Funk
  stopAllRumble(arduinoP1);
  stopAllRumble(arduinoP2);
  stopAllLED(arduinoP1, firstArduino);
  stopAllLED(arduinoP2, !firstArduino);
  int nbTurnDisco = numberRound > maxTurnDiscoToAdd ? maxTurnDiscoToAdd : numberRound;
  for (int i = 0; i < numberTurnDisco + nbTurnDisco; ++i)
  {
    for (int j = 0; j < numberInputChangeByDisco; ++j)
    {
      setPinState(arduinoP1, getLedPin((int)random(numberInputs), firstArduino), (int)random(2));
      setPinState(arduinoP2, getLedPin((int)random(numberInputs), !firstArduino), (int)random(2));
    }
    if (i == numberTurnDisco + nbTurnDisco - 1)
      delay(timerAfterChangementDisco);
  }
  stopAllRumble(arduinoP1);
  stopAllRumble(arduinoP2);
  stopAllLED(arduinoP1, firstArduino);
  stopAllLED(arduinoP2, !firstArduino);
  
  // Reset
  initGame();
}

void draw()
{
  GetInputs(valueInputP1, arduinoP1, firstArduino);
  GetInputs(valueInputP2, arduinoP2, !firstArduino);
  buttonState();
  
  // End round
  if (millis() > prevTime + endTimerInput - timerEndOpportinity)
  {
    println("Stop all!");
    stopAllRumble(arduinoP1);
    stopAllRumble(arduinoP2);
    stopAllLED(arduinoP1, firstArduino);
    stopAllLED(arduinoP2, !firstArduino);
  }
  if (listInputs.size() == 0 && !badInput)
  {
    println("Next round!");
    ++numberRound;
    newRound();
  }
  else if (badInput)
  {
    println("End round! You lose!");
    audioError.rewind();
    audioError.play();
    endGame();
  }
  else if (millis() > prevTime + endTimerInput)
  {
    println("End round! Too slow!");
    endGame();
  }
}

void buttonState()
{
  for (int i = 0; i < numberInputs; ++i)
  {
    int pinLedP1 = getLedPin(i, firstArduino);
    int pinLedP2 = getLedPin(i, !firstArduino);
    int rumbleLed = getRumblePin(i);
    // Player 1
    if (!currentPinPressP1[i] && valueInputP1[i])
    {
      currentPinPressP1[i] = true;
      boolean find = false;
      for (int j = 0; j < listInputs.size() && !find; ++j)
      {
        if (listInputs.get(j) == i)
        {
          listInputs.remove(j);
          find = true;
        }
      }
      if (find)
      {
        audioInputs.get(i).rewind();
        audioInputs.get(i).play();
        setPinState(arduinoP1, pinLedP1, Arduino.LOW);
        setPinState(arduinoP1, rumbleLed, Arduino.LOW);
      }
      else
      {
        badInput = true;
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
      for (int j = 0; j < listInputs.size() && !find; ++j)
      {
        if (listInputs.get(j) == i + numberInputs)
        {
          listInputs.remove(j);
          find = true;
        }
      }
      if (find)
      {
        audioInputs.get(i).rewind();
        audioInputs.get(i).play();
        setPinState(arduinoP2, pinLedP2, Arduino.LOW);
        setPinState(arduinoP2, rumbleLed, Arduino.LOW);
      }
      else
      {
        badInput = true;
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
  stopAllLED(arduinoP1, firstArduino);
  stopAllLED(arduinoP2, !firstArduino);
  
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
