import processing.serial.*;
import cc.arduino.*;

final int numberInputs = 5;
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
    if (valueInputP1[buttonYellow])
    {
      println("Press buttonYellow 1");
      setPinState(arduinoP1, rumbleYellow, Arduino.HIGH);
      setPinState(arduinoP1, ledYellow, Arduino.HIGH);
      currentPinPressP1 = buttonYellow;
      return buttonYellow;
    }
    else if (valueInputP1[buttonGreen])
    {
      println("Press buttonGreen 1");
      setPinState(arduinoP1, rumbleGreen, Arduino.HIGH);
      setPinState(arduinoP1, ledGreen, Arduino.HIGH);
      currentPinPressP1 = buttonGreen;
      return buttonGreen;
    }
    else if (valueInputP1[buttonRed])
    {
      println("Press buttonRed 1");
      setPinState(arduinoP1, rumbleRed, Arduino.HIGH);
      setPinState(arduinoP1, ledRed, Arduino.HIGH);
      currentPinPressP1 = buttonRed;
      return buttonRed;
    }
    else if (valueInputP1[buttonBlue])
    {
      println("Press buttonBlue 1");
      setPinState(arduinoP1, rumbleBlue, Arduino.HIGH);
      setPinState(arduinoP1, ledBlue, Arduino.HIGH);
      currentPinPressP1 = buttonBlue;
      return buttonBlue;
    }
    else if (valueInputP1[buttonWhite])
    {
      println("Press buttonWhite 1");
      setPinState(arduinoP1, rumbleWhite, Arduino.HIGH);
      setPinState(arduinoP1, ledWhite, Arduino.HIGH);
      currentPinPressP1 = buttonWhite;
      return buttonWhite;
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
