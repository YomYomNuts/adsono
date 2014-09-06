import processing.serial.*;
import cc.arduino.*;

final boolean firstArduino = true;
final int numberInputs = 5;
boolean[] valueInputP1 = new boolean[numberInputs];
int currentPinPressP1 = -1;
boolean[] valueInputP2 = new boolean[numberInputs];
int currentPinPressP2 = -1;

final int PLAYER1 = 0;
final int PLAYER2 = 1;

Arduino arduinoP1;
Arduino arduinoP2;

void setup()
{
  // Init the arduinos
  println(Arduino.list());
  arduinoP1 = new Arduino(this, Arduino.list()[0]);
  arduinoP2 = new Arduino(this, Arduino.list()[1]);
  
  // Init analog tab
  currentPinPressP1 = -1;
  currentPinPressP2 = -1;
  InitInputs(valueInputP1, arduinoP1, firstArduino);
  InitInputs(valueInputP2, arduinoP2, !firstArduino);
}

void draw()
{
  GetInputs(valueInputP1, arduinoP1, firstArduino);
  GetInputs(valueInputP2, arduinoP2, !firstArduino);
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
      if (valueInputP1[currentPinPressP1])
        return -1;
    }
    if (valueInputP1[buttonYellow])
    {
      println("Press buttonYellow 1");
      setPinState(arduinoP1, rumbleYellow, Arduino.HIGH);
      setPinState(arduinoP1, ledYellowP1, Arduino.HIGH);
      currentPinPressP1 = buttonYellow;
      return buttonYellow;
    }
    else if (valueInputP1[buttonGreen])
    {
      println("Press buttonGreen 1");
      setPinState(arduinoP1, rumbleGreen, Arduino.HIGH);
      setPinState(arduinoP1, ledGreenP1, Arduino.HIGH);
      currentPinPressP1 = buttonGreen;
      return buttonGreen;
    }
    else if (valueInputP1[buttonRed])
    {
      println("Press buttonRed 1");
      setPinState(arduinoP1, rumbleRed, Arduino.HIGH);
      setPinState(arduinoP1, ledRedP1, Arduino.HIGH);
      currentPinPressP1 = buttonRed;
      return buttonRed;
    }
    else if (valueInputP1[buttonBlue])
    {
      println("Press buttonBlue 1");
      setPinState(arduinoP1, rumbleBlue, Arduino.HIGH);
      setPinState(arduinoP1, ledBlueP1, Arduino.HIGH);
      currentPinPressP1 = buttonBlue;
      return buttonBlue;
    }
    else if (valueInputP1[buttonWhite])
    {
      println("Press buttonWhite 1");
      setPinState(arduinoP1, rumbleWhite, Arduino.HIGH);
      setPinState(arduinoP1, ledWhiteP1, Arduino.HIGH);
      currentPinPressP1 = buttonWhite;
      return buttonWhite;
    }
  }
  else
  {
    if (currentPinPressP2 != -1)
    {
      if (valueInputP2[currentPinPressP2])
        return -1;
    }
    if (valueInputP2[buttonYellow])
    {
      println("Press buttonYellow 2");
      setPinState(arduinoP2, rumbleYellow, Arduino.HIGH);
      setPinState(arduinoP2, ledYellowP2, Arduino.HIGH);
      currentPinPressP2 = buttonYellow;
      return buttonYellow;
    }
    else if (valueInputP2[buttonGreen])
    {
      println("Press buttonGreen 2");
      setPinState(arduinoP2, rumbleGreen, Arduino.HIGH);
      setPinState(arduinoP2, ledGreenP2, Arduino.HIGH);
      currentPinPressP2 = buttonGreen;
      return buttonGreen;
    }
    else if (valueInputP2[buttonRed])
    {
      println("Press buttonRed 2");
      setPinState(arduinoP2, rumbleRed, Arduino.HIGH);
      setPinState(arduinoP2, ledRedP2, Arduino.HIGH);
      currentPinPressP2 = buttonRed;
      return buttonRed;
    }
    else if (valueInputP2[buttonBlue])
    {
      println("Press buttonBlue 2");
      setPinState(arduinoP2, rumbleBlue, Arduino.HIGH);
      setPinState(arduinoP2, ledBlueP2, Arduino.HIGH);
      currentPinPressP2 = buttonBlue;
      return buttonBlue;
    }
    else if (valueInputP2[buttonWhite])
    {
      println("Press buttonWhite 2");
      setPinState(arduinoP2, rumbleWhite, Arduino.HIGH);
      setPinState(arduinoP2, ledWhiteP2, Arduino.HIGH);
      currentPinPressP2 = buttonWhite;
      return buttonWhite;
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
      if (!valueInputP1[currentPinPressP1])
      {
        stopAllRumble(arduinoP1);
        stopAllLED(arduinoP1, firstArduino);
        currentPinPressP1 = -1;
        find = true;
      }
    }
  }
  else
  {
    if (currentPinPressP2 != -1)
    {
      if (!valueInputP2[currentPinPressP2])
      {
        stopAllRumble(arduinoP2);
        stopAllLED(arduinoP2, !firstArduino);
        currentPinPressP2 = -1;
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
  stopAllRumble(arduinoP2);
  stopAllLED(arduinoP1, firstArduino);
  stopAllLED(arduinoP2, !firstArduino);
}
