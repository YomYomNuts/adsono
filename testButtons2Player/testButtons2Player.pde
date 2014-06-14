import processing.serial.*;
import cc.arduino.*;

boolean[] valueAnalogP1 = new boolean[6];
int currentPinPressP1 = -1;
boolean[] valueAnalogP2 = new boolean[6];
int currentPinPressP2 = -1;

final int PLAYER1 = 0;
final int PLAYER2 = 0;

Arduino arduinoP1;
Arduino arduinoP2;

void setup()
{
  arduinoP1 = new Arduino(this, Arduino.list()[0]);
  arduinoP1 = new Arduino(this, Arduino.list()[1]);
  
  // Init analog tab
  currentPinPressP1 = -1;
  InitInputs(valueAnalogP1, arduinoP1);
  currentPinPressP2 = -1;
  InitInputs(valueAnalogP2, arduinoP2);
}

void draw()
{
  GetInputs(valueAnalogP1, arduinoP1);
  GetInputs(valueAnalogP2, arduinoP2);
  buttonReleased();
  buttonPressed();
}

void buttonPressed()
{
  getGeneralInput(PLAYER1);
  getGeneralInput(PLAYER2);
}

int getGeneralInput(int player)
{
  if (player == PLAYER1)
  {
    if (currentPinPressP1 != -1)
    {
      if (valueAnalogP1[currentPinPressP1])
        return -1;
    }
    if (valueAnalogP1[buttonArmRightYellow])
    {
      println("Press buttonArmRightYellow 1");
      setPinState(arduinoP1, rumbleArmRightYellow, Arduino.HIGH);
      setPinState(arduinoP1, ledArmRightYellow, Arduino.HIGH);
      currentPinPressP1 = buttonArmRightYellow;
      return buttonArmRightYellow;
    }
    else if (valueAnalogP1[buttonArmLeftGreen])
    {
      println("Press buttonArmLeftGreen 1");
      setPinState(arduinoP1, rumbleArmLeftGreen, Arduino.HIGH);
      setPinState(arduinoP1, ledArmLeftGreen, Arduino.HIGH);
      currentPinPressP1 = buttonArmLeftGreen;
      return buttonArmLeftGreen;
    }
    else if (valueAnalogP1[buttonBoobsRed])
    {
      println("Press buttonBoobsRed 1");
      setPinState(arduinoP1, rumbleBoobsRed, Arduino.HIGH);
      setPinState(arduinoP1, ledBoobsRed, Arduino.HIGH);
      currentPinPressP1 = buttonBoobsRed;
      return buttonBoobsRed;
    }
    else if (valueAnalogP1[buttonStomachBlue])
    {
      println("Press buttonStomachBlue 1");
      setPinState(arduinoP1, rumbleStomachBlue, Arduino.HIGH);
      setPinState(arduinoP1, ledStomachBlue, Arduino.HIGH);
      currentPinPressP1 = buttonStomachBlue;
      return buttonStomachBlue;
    }
    else if (valueAnalogP1[buttonThighRightPink])
    {
      println("Press buttonThighRightPink 1");
      setPinState(arduinoP1, rumbleThighRightPink, Arduino.HIGH);
      setPinState(arduinoP1, ledThighRightPink, Arduino.HIGH);
      currentPinPressP1 = buttonThighRightPink;
      return buttonThighRightPink;
    }
    else if (valueAnalogP1[buttonThighLeftOrange])
    {
      println("Press buttonThighLeftOrange 1");
      setPinState(arduinoP1, rumbleThighLeftOrange, Arduino.HIGH);
      setPinState(arduinoP1, ledThighLeftOrange, Arduino.HIGH);
      currentPinPressP1 = buttonThighLeftOrange;
      return buttonThighLeftOrange;
    }
  }
  else
  {
  {
    if (currentPinPressP2 != -1)
    {
      if (valueAnalogP2[currentPinPressP2])
        return -1;
    }
    if (valueAnalogP2[buttonArmRightYellow])
    {
      println("Press buttonArmRightYellow 2");
      setPinState(arduinoP2, rumbleArmRightYellow, Arduino.HIGH);
      setPinState(arduinoP2, ledArmRightYellow, Arduino.HIGH);
      currentPinPressP2 = buttonArmRightYellow;
      return buttonArmRightYellow;
    }
    else if (valueAnalogP2[buttonArmLeftGreen])
    {
      println("Press buttonArmLeftGreen 2");
      setPinState(arduinoP2, rumbleArmLeftGreen, Arduino.HIGH);
      setPinState(arduinoP2, ledArmLeftGreen, Arduino.HIGH);
      currentPinPressP2 = buttonArmLeftGreen;
      return buttonArmLeftGreen;
    }
    else if (valueAnalogP2[buttonBoobsRed])
    {
      println("Press buttonBoobsRed 2");
      setPinState(arduinoP2, rumbleBoobsRed, Arduino.HIGH);
      setPinState(arduinoP2, ledBoobsRed, Arduino.HIGH);
      currentPinPressP2 = buttonBoobsRed;
      return buttonBoobsRed;
    }
    else if (valueAnalogP2[buttonStomachBlue])
    {
      println("Press buttonStomachBlue 2");
      setPinState(arduinoP2, rumbleStomachBlue, Arduino.HIGH);
      setPinState(arduinoP2, ledStomachBlue, Arduino.HIGH);
      currentPinPressP2 = buttonStomachBlue;
      return buttonStomachBlue;
    }
    else if (valueAnalogP2[buttonThighRightPink])
    {
      println("Press buttonThighRightPink 2");
      setPinState(arduinoP2, rumbleThighRightPink, Arduino.HIGH);
      setPinState(arduinoP2, ledThighRightPink, Arduino.HIGH);
      currentPinPressP2 = buttonThighRightPink;
      return buttonThighRightPink;
    }
    else if (valueAnalogP2[buttonThighLeftOrange])
    {
      println("Press buttonThighLeftOrange 2");
      setPinState(arduinoP2, rumbleThighLeftOrange, Arduino.HIGH);
      setPinState(arduinoP2, ledThighLeftOrange, Arduino.HIGH);
      currentPinPressP2 = buttonThighLeftOrange;
      return buttonThighLeftOrange;
    }
  }
  return -1;
}

void buttonReleased()
{
  checkKeyReleased(PLAYER1);
  checkKeyReleased(PLAYER2);
}

boolean checkKeyReleased(int player)
{
  boolean find = false;
  if (player == PLAYER1)
  {
    if (currentPinPressP1 != -1)
    {
      if (!valueAnalogP1[currentPinPressP1])
      {
        stopAllRumble(arduinoP1);
        stopAllLED(arduinoP1);
        currentPinPressP1 = -1;
        find = true;
      }
    }
  }
  else
  {
    if (currentPinPressP2 != -1)
    {
      if (!valueAnalogP1[currentPinPressP2])
      {
        stopAllRumble(arduinoP2);
        stopAllLED(arduinoP2);
        currentPinPressP2 = -1;
        find = true;
      }
    }
  }
  return find;
}
