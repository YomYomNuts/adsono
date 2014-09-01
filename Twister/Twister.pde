import processing.serial.*;
import cc.arduino.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


// GD can change this values
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
final int numberMinimalInputs = 2;
final int numberMaximalInputs = 9;
final int timerBlinkBeforeTheEnd = 1000; // Timer in millisecond

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
int endTimerInput;
int prevTime;
int timerBlink;
int stateBlink;

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
  InitInputs(valueInputP1, arduinoP1);
  InitInputs(valueInputP2, arduinoP2);
  
  // Init the game
  initGame();
}

void initGame()
{
  // Init var game
  stateBlink = Arduino.HIGH;
  
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
  int numberInputsToGenerate = int(random(numberMinimalInputs, numberMaximalInputs));
  if (numberInputsToGenerate > listInputsToAdd.size())
    numberInputsToGenerate = listInputsToAdd.size();
  endTimerInput = timerStart + timerByInput * numberInputsToGenerate;
  while (i < numberInputsToGenerate)
  {
    int index = (int)random(listInputsToAdd.size());
    int indexButton = listInputsToAdd.get(index);
    if (indexButton >= numberInputs)
    {
      setPinState(arduinoP2, getLedPin(indexButton - numberInputs), Arduino.HIGH);
      setPinState(arduinoP2, getRumblePin(indexButton - numberInputs), Arduino.HIGH);
    }
    else
    {
      setPinState(arduinoP1, getLedPin(indexButton), Arduino.HIGH);
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
  stopAllLED(arduinoP1);
  stopAllLED(arduinoP2);
  for (int i = 0; i < numberTurnDisco + maxTurnDiscoToAdd; ++i)
  {
    for (int j = 0; j < numberInputChangeByDisco; ++j)
    {
      setPinState(arduinoP1, getLedPin((int)random(numberInputs)), (int)random(2));
      setPinState(arduinoP2, getLedPin((int)random(numberInputs)), (int)random(2));
    }
    if (i == numberTurnDisco + maxTurnDiscoToAdd - 1)
      delay(timerAfterChangementDisco);
  }
  stopAllRumble(arduinoP1);
  stopAllRumble(arduinoP2);
  stopAllLED(arduinoP1);
  stopAllLED(arduinoP2);
  
  // Reset
  initGame();
}

void draw()
{
  GetInputs(valueInputP1, arduinoP1);
  GetInputs(valueInputP2, arduinoP2);
  buttonState();
  
  // Check all
  int nbFind = 0;
  for (int i = 0; i < listInputs.size(); ++i)
  {
    if (listInputs.get(i) < numberInputs)
    {
      if (currentPinPressP1[listInputs.get(i)])
          ++nbFind;
    }
    else
    {
      if (currentPinPressP2[listInputs.get(i) - numberInputs])
          ++nbFind;
    }
  }
  
  // Blink
  if (millis() > prevTime + endTimerInput - timerBlinkBeforeTheEnd)
  {
    if (millis() > timerBlink)
    {
      stateBlink = stateBlink == Arduino.HIGH ? Arduino.LOW : Arduino.HIGH;
      timerBlink = (int)(-log(timerBlinkBeforeTheEnd - millis() - prevTime - endTimerInput) * timerBlinkBeforeTheEnd / 2);
      for (int i = 0; i < listInputs.size(); ++i)
      {
        if (listInputs.get(i) < numberInputs)
        {
          setPinState(arduinoP1, getLedPin(listInputs.get(i)), stateBlink);
          setPinState(arduinoP1, getRumblePin(listInputs.get(i)), stateBlink);
        }
        else
        {
          setPinState(arduinoP2, getLedPin(listInputs.get(i) - numberInputs), stateBlink);
          setPinState(arduinoP2, getRumblePin(listInputs.get(i) - numberInputs), stateBlink);
        }
      }
    }
  }
  
  // End round
  if (millis() > prevTime + endTimerInput)
  {
    println("End round! Too slow!");
    endGame();
  }
  else if (nbFind == listInputs.size())
  {
    println("End!");
    endGame();
  }
}

void buttonState()
{
  int nbFind = 0;
  for (int i = 0; i < numberInputs; ++i)
  {
    // Player 1
    if (!currentPinPressP1[i] && valueInputP1[i])
    {
      currentPinPressP1[i] = true;
      audioInputs.get(i).rewind();
      audioInputs.get(i).play();
    }
    else if (!valueInputP1[i])
    {
      currentPinPressP1[i] = false;
    }
    // Player 2
    if (!currentPinPressP2[i] && valueInputP2[i])
    {
      currentPinPressP2[i] = true;
      audioInputs.get(i).rewind();
      audioInputs.get(i).play();
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
