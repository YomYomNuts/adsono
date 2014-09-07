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
final int timerStart = 3000; // Timer in millisecond
final int timerByInput = 10000; // Timer in millisecond
final int timerNextTurn = 1000; // Timer in millisecond
final int numberStartTurnDisco = 100; // Number start turns of disco
final int numberTurnDisco = 10; // Number minimal turns of disco 
final int maxTurnDiscoToAdd = 100; // Number maximal turns of disco
final int numberInputChangeByDisco = 5;
final int timerAfterChangementDisco = 150; // Timer in millisecond
final int addButtonAllRound = 10;
final int timerEndOpportinity = 150; // Timer in millisecond
final int timerBlinkBeforeTheEnd = 1000; // Timer in millisecond
final int stepTwister[] = { 2, 2, 3, 3, 3, 4 }; // Number button by player
final int timerPlayBip = 1000; // Timer in millisecond
final int timerChrismasTree = 500; // Timer in millisecond
final int numberBlinkVictory = 3;

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
final String bipSound = "Music/bip.wav";
final String endSound = "Music/voices/end.wav";
final int timerEndSound = 3130; // Timer in millisecond
final String winTwisterSound = "Music/voices/winTwister.wav";
final int timerWinTwisterSound = 4130; // Timer in millisecond
final String nextRoundSound = "Music/fill.wav";
final int timerNextRoundSound = 750; // Timer in millisecond

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
int currentIndexStepTwister;
int previousTimerBip;

// Music
Minim minim;
AudioPlayer audioBG;
ArrayList<AudioPlayer> audioInputs;
AudioPlayer audioAreYouReady;
AudioPlayer audioStart;
AudioPlayer audioError;
AudioPlayer audioBip;
AudioPlayer audioEnd;
AudioPlayer audioWinTwister;
AudioPlayer audioNextRound;

int rectX, rectY;      // Position of square button
int rectSize = 90;     // Diameter of rect
color rectColor, rectHighlight;
boolean rectOver = false;

void setup()
{
  // Init Window
  size(320, 160);
  rectColor = color(0);
  rectHighlight = color(51);
  rectX = width/2-rectSize;
  rectY = height/2-rectSize/2;
  
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
  audioBip = minim.loadFile(bipSound);
  audioEnd = minim.loadFile(endSound);
  audioWinTwister = minim.loadFile(winTwisterSound);
  audioNextRound = minim.loadFile(nextRoundSound);
  
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
  
  // Warn players that the game will start
  audioAreYouReady.rewind();
  audioAreYouReady.play();
  delay(timerAreYouReadySound);
  audioStart.rewind();
  audioStart.play();
  delay(timerStartSound);
  
  // Init the game
  initGame();
}

void initGame()
{
  // Init var game
  stateBlink = Arduino.HIGH;
  
  // Initialize the round
  newRound();
}

void newRound()
{
  // Init var game
  IntList listInputsToAdd1 = new IntList();
  IntList listInputsToAdd2 = new IntList();
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
      listInputsToAdd1.append(i);
    if (!find2)
      listInputsToAdd2.append(i + numberInputs);
  }
  
  int i = 0;
  listInputs.clear();
  endTimerInput = timerStart + timerByInput * stepTwister[currentIndexStepTwister];
  while (i < stepTwister[currentIndexStepTwister])
  {
    int index1 = (int)random(listInputsToAdd1.size());
    int index2 = (int)random(listInputsToAdd2.size());
    int indexButton1 = listInputsToAdd1.get(index1);
    int indexButton2 = listInputsToAdd2.get(index2);
    setPinState(arduinoP1, getLedPin(indexButton1, firstArduino), Arduino.HIGH);
    setPinState(arduinoP1, getRumblePin(indexButton1), Arduino.HIGH);
    setPinState(arduinoP2, getLedPin(indexButton2 - numberInputs, !firstArduino), Arduino.HIGH);
    setPinState(arduinoP2, getRumblePin(indexButton2 - numberInputs), Arduino.HIGH);
    listInputs.append(indexButton1);
    listInputs.append(indexButton2);
    listInputsToAdd1.remove(index1);
    listInputsToAdd2.remove(index2);
    i++;
  }
  println("listInputs " + listInputs);
  
  prevTime = millis();
  previousTimerBip = prevTime;
}

void endGame()
{
  ++currentIndexStepTwister;
  if (currentIndexStepTwister >= stepTwister.length)
  {
    currentIndexStepTwister = 0;
    audioWinTwister.rewind();
    audioWinTwister.play();
    
    // Funk
    stopAllRumble(arduinoP1);
    stopAllRumble(arduinoP2);
    stopAllLED(arduinoP1, firstArduino);
    stopAllLED(arduinoP2, !firstArduino);
    for (int i = 0; i < numberBlinkVictory; ++i)
    {
      fireAllLED(arduinoP1, firstArduino);
      fireAllLED(arduinoP2, !firstArduino);
      delay(timerChrismasTree);
      stopAllLED(arduinoP1, firstArduino);
      stopAllLED(arduinoP2, !firstArduino);
      delay(timerChrismasTree);
    }
    delay(timerWinTwisterSound);
    
    // Warn players that the game will start
    audioAreYouReady.rewind();
    audioAreYouReady.play();
    delay(timerAreYouReadySound);
    audioStart.rewind();
    audioStart.play();
    delay(timerStartSound);
  }
  stopAllRumble(arduinoP1);
  stopAllRumble(arduinoP2);
  stopAllLED(arduinoP1, firstArduino);
  stopAllLED(arduinoP2, !firstArduino);
  
  // Reset
  initGame();
}

void mousePressed()
{
  if (rectOver)
  {
    // Reset
    stopAllRumble(arduinoP1);
    stopAllRumble(arduinoP2);
    stopAllLED(arduinoP1, firstArduino);
    stopAllLED(arduinoP2, !firstArduino);
    currentIndexStepTwister = 0;
    
    // Warn players that the game will start
    audioAreYouReady.rewind();
    audioAreYouReady.play();
    delay(timerAreYouReadySound);
    audioStart.rewind();
    audioStart.play();
    delay(timerStartSound);
    
    initGame();
  }
}

boolean overRect(int x, int y, int width, int height)
{
  if (mouseX >= x && mouseX <= x+width && mouseY >= y && mouseY <= y+height)
  {
    return true;
  }
  else
  {
    return false;
  }
}

void draw()
{
  // Button
  background(color(102));
  if (rectOver)
  {
    fill(rectHighlight);
  }
  else
  {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX, rectY, rectSize, rectSize);
  if ( overRect(rectX, rectY, rectSize, rectSize) )
  {
    rectOver = true;
  }
  else
  {
    rectOver = false;
  }
  
  GetInputs(valueInputP1, arduinoP1, firstArduino);
  GetInputs(valueInputP2, arduinoP2, !firstArduino);
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
      if (stateBlink == Arduino.HIGH)
      {
        audioBip.rewind();
        audioBip.play();
      }
      timerBlink = (int)(-log(timerBlinkBeforeTheEnd - millis() - prevTime - endTimerInput) * timerBlinkBeforeTheEnd / 2);
      for (int i = 0; i < listInputs.size(); ++i)
      {
        if (listInputs.get(i) < numberInputs)
        {
          setPinState(arduinoP1, getLedPin(listInputs.get(i), firstArduino), stateBlink);
          setPinState(arduinoP1, getRumblePin(listInputs.get(i)), stateBlink);
        }
        else
        {
          setPinState(arduinoP2, getLedPin(listInputs.get(i) - numberInputs, !firstArduino), stateBlink);
          setPinState(arduinoP2, getRumblePin(listInputs.get(i) - numberInputs), stateBlink);
        }
      }
    }
  }
  else
  {
    if (millis() - previousTimerBip > timerPlayBip)
    {
        audioBip.rewind();
        audioBip.play();
        previousTimerBip = millis();
    }
  }
  
  // End round
  if (millis() > prevTime + endTimerInput)
  {
    println("End round! Too slow!");
    currentIndexStepTwister = -1;
    
    audioEnd.rewind();
    audioEnd.play();
    delay(timerEndSound);
    
    // Warn players that the game will start
    audioAreYouReady.rewind();
    audioAreYouReady.play();
    delay(timerAreYouReadySound);
    audioStart.rewind();
    audioStart.play();
    delay(timerStartSound);
    
    endGame();
  }
  else if (nbFind == listInputs.size())
  {
    println("End!");
    audioNextRound.rewind();
    audioNextRound.play();
    delay(timerNextRoundSound);
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
  stopAllLED(arduinoP1, firstArduino);
  stopAllLED(arduinoP2, !firstArduino);
  
  audioBG.close();
  audioAreYouReady.close();
  audioStart.close();
  audioError.close();
  audioBip.close();
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
