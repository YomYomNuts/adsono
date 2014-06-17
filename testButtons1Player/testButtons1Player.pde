import processing.serial.*;
import cc.arduino.*;

final int numberInputs = 6;
boolean[] valueInputP1 = new boolean[numberInputs];
int currentPinPressP1 = -1;

final int PLAYER1 = 0;

Arduino arduinoP1;

void setup()
{
  // Init the arduinos
  println(Arduino.list());
  arduinoP1 = new Arduino(this, Arduino.list()[0]);
  
  // Init analog tab
  currentPinPressP1 = -1;
  InitInputs(valueInputP1, arduinoP1);
}

void draw()
{
  GetInputs(valueInputP1, arduinoP1);
  buttonReleased();
  buttonPressed();
}

void buttonPressed()
{
  getGeneralInput(PLAYER1);
}

int getGeneralInput(int player)
{
  if (player == PLAYER1)
  {
    if (currentPinPressP1 != -1)
    {
      if (valueInputP1[currentPinPressP1])
        return -1;
    }
    if (valueInputP1[buttonArmRightYellow])
    {
      println("Press buttonArmRightYellow 1");
      setPinState(arduinoP1, rumbleArmRightYellow, Arduino.HIGH);
      setPinState(arduinoP1, ledArmRightYellow, Arduino.HIGH);
      currentPinPressP1 = buttonArmRightYellow;
      return buttonArmRightYellow;
    }
    else if (valueInputP1[buttonArmLeftGreen])
    {
      println("Press buttonArmLeftGreen 1");
      setPinState(arduinoP1, rumbleArmLeftGreen, Arduino.HIGH);
      setPinState(arduinoP1, ledArmLeftGreen, Arduino.HIGH);
      currentPinPressP1 = buttonArmLeftGreen;
      return buttonArmLeftGreen;
    }
    else if (valueInputP1[buttonBoobsRed])
    {
      println("Press buttonBoobsRed 1");
      setPinState(arduinoP1, rumbleBoobsRed, Arduino.HIGH);
      setPinState(arduinoP1, ledBoobsRed, Arduino.HIGH);
      currentPinPressP1 = buttonBoobsRed;
      return buttonBoobsRed;
    }
    else if (valueInputP1[buttonStomachBlue])
    {
      println("Press buttonStomachBlue 1");
      setPinState(arduinoP1, rumbleStomachBlue, Arduino.HIGH);
      setPinState(arduinoP1, ledStomachBlue, Arduino.HIGH);
      currentPinPressP1 = buttonStomachBlue;
      return buttonStomachBlue;
    }
    else if (valueInputP1[buttonThighRightPink])
    {
      println("Press buttonThighRightPink 1");
      setPinState(arduinoP1, rumbleThighRightPink, Arduino.HIGH);
      setPinState(arduinoP1, ledThighRightPink, Arduino.HIGH);
      currentPinPressP1 = buttonThighRightPink;
      return buttonThighRightPink;
    }
    else if (valueInputP1[buttonThighLeftOrange])
    {
      println("Press buttonThighLeftOrange 1");
      setPinState(arduinoP1, rumbleThighLeftOrange, Arduino.HIGH);
      setPinState(arduinoP1, ledThighLeftOrange, Arduino.HIGH);
      currentPinPressP1 = buttonThighLeftOrange;
      return buttonThighLeftOrange;
    }
  }
  return -1;
}

void buttonReleased()
{
  checkKeyReleased(PLAYER1);
}

boolean checkKeyReleased(int player)
{
  boolean find = false;
  if (player == PLAYER1)
  {
    if (currentPinPressP1 != -1)
    {
      if (!valueInputP1[currentPinPressP1])
      {
        stopAllRumble(arduinoP1);
        stopAllLED(arduinoP1);
        currentPinPressP1 = -1;
        find = true;
      }
    }
  }
  return find;
}

void stop()
{
  // Stop all
  stopAllRumble(arduinoP1);
  stopAllLED(arduinoP1);
}
