import processing.serial.*;
import cc.arduino.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


// GD can change this value
final int spaceTimeGetInput = 2000; // Give a value that can divide by 2 (in frame)
final int numberInputByMesure = 2;
final int timerBetweenChangementPlayer = 60; // Timer in frame
final int timerLaunchRumbleDuringChangementPlayer = 3; // Timer in frame
final int numberRound = 4;


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
final char buttonArmLeftP1 = 'b';
final char buttonBoobsP1 = 'c';
final char buttonStomachP1 = 'd';
final char buttonThighRightP1 = 'e';
final char buttonThighLeftP1 = 'f';

// Input player 2
final char buttonArmRightP2 = 'g';
final char buttonArmLeftP2 = 'h';
final char buttonBoobsP2 = 'i';
final char buttonStomachP2 = 'j';
final char buttonThighRightP2 = 'k';
final char buttonThighLeftP2 = 'l';

// State input press
final int stateFailPress = 0;
final int stateGoodPress = 1;
final int stateFinishPress = 2;

// Tempo
final int pasTempo = 50;

// State rumble
final int stateRumbleThigh = 0;
final int stateRumbleStomach = 1;
final int stateRumbleArm = 2;

// Rumble pin
final int rumbleArmRight = 2;
final int rumbleArmLeft = 3;
final int rumbleBoobs = 4;
final int rumbleStomach = 5;
final int rumbleThighRight = 6;
final int rumbleThighLeft = 7;

// Led pin
final int ledArmRight = 8;
final int ledArmLeft = 9;
final int ledBoobs = 10;
final int ledStomach = 11;
final int ledThighRight = 12;
final int ledThighLeft = 13;

// Led tempo pin
final int ledTempo[] = { 22, 23, 24, 25, 26, 27 };

// Led round
final int ledRound[] = { 28, 29, 30, 31 };


// Varibles game
Arduino arduinoP1;
Arduino arduinoP2;
// Game state
int currentState;
IntList listInputs;
boolean canGetInput;
boolean waitNextTempo;
int currentInput;
int timerChangementPlayer;
int stateRumbleChangePlayer;
// Tempo
Minim minim;
AudioPlayer player;
AudioInput input;
int prevTime;
int currentTime;
int tempo;
int delta;

void setup()
{
  // Init the arduinos
  //println(Arduino.list());
  arduinoP1 = new Arduino(this, Arduino.list()[0]);
  arduinoP2 = new Arduino(this, Arduino.list()[1]);
  
  // Init var game
  currentState = stateReproductP1;
  listInputs = new IntList();
  canGetInput = false;
  waitNextTempo = false;
  currentInput = 0;
  timerChangementPlayer = 0;
  stateRumbleChangePlayer = stateRumbleThigh;
  // Add the first input
  listInputs.append((int)random(numberInputs));
  listInputs.append((int)random(numberInputs));
  println(listInputs);
  
  // Sound
  prevTime = millis();
  currentTime = 0;
  tempo = 10000;
  minim = new Minim(this);
  player = minim.loadFile("Music/test.wav");
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
      ++timerChangementPlayer;
      if (timerChangementPlayer >= timerLaunchRumbleDuringChangementPlayer * (1 + stateRumbleChangePlayer))
      {
        switch(stateRumbleChangePlayer)
        {
          case stateRumbleThigh:
          {
            // TODO launch rumble rumbleThighRight and rumbleThighLeft
          } break;
          case stateRumbleStomach:
          {
            // TODO launch rumble rumbleBoobs and rumbleStomach
          } break;
          case stateRumbleArm:
          {
            // TODO launch rumble rumbleArmRight and rumbleArmLeft
          } break;
        }
      }
      if (timerChangementPlayer >= timerBetweenChangementPlayer)
      {
        println("Player 2");
        canGetInput = false;
        waitNextTempo = false;
        timerChangementPlayer = 0;
        currentState = stateReproductP2;
        currentTime = 0;
        
        // TODO stop the rumbles
      }
    } break;
    case stateChangePlayerP2toP1:
    {
      ++timerChangementPlayer;
      if (timerChangementPlayer >= timerBetweenChangementPlayer)
      {
        println("Player 1");
        canGetInput = false;
        waitNextTempo = false;
        timerChangementPlayer = 0;
        currentState = stateReproductP1;
        currentTime = 0;
        
        // TODO stop the rumbles
      }
    } break;
    case stateFailReproductP1:
    {
      println(currentState);
    } break;
    case stateFailReproductP2:
    {
      println(currentState);
    } break;
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
    // TODO Launch the rumble for the current player and leds for two players be careful with the blank
    if (currentState == stateReproductP1)
    {
    }
    else if (currentState == stateReproductP2)
    {
    }
    
    // Launch music feedback tempo
    player.rewind();
    player.play();
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
  int currentGeneralInputPress = getGeneralInput(key, ((currentState == stateReproductP1 || currentState == stateRecordP1) ? 1: 2));
  if (canGetInput && currentGeneralInputPress != -1)
  {
    canGetInput = false; // Now we can't do an other input
    waitNextTempo = true;
    
    switch(currentState)
    {
      case stateReproductP1:
      case stateReproductP2:
      {
        // Get final state
        // TODO stop the rumble and the leds of this action
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
        // Add the input
        listInputs.append(currentGeneralInputPress);
        
        // TODO Launch led on this input for 2 players
        
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
  if (player == 1)
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
      // TODO stop leds of this previous action
    } break;
  }
}

void stop()
{
  // the AudioPlayer you got from Minim.loadFile()
  player.close();
  // the AudioInput you got from Minim.getLineIn()
  input.close();
  minim.stop();
 
  // this calls the stop method that 
  // you are overriding by defining your own
  // it must be called so that your application 
  // can do all the cleanup it would normally do
  super.stop();
}
