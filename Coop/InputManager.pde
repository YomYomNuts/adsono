// Pin buttons
final int pinbuttonArmRightYellow = 2;
final int pinbuttonArmLeftGreen = 3;
final int pinbuttonBoobsRed = 4;
final int pinbuttonStomachBlue = 5;
final int pinbuttonThighRightPink = 6;
final int pinbuttonThighLeftOrange = 7;

// Position buttons
final int buttonArmRightYellow = 0;
final int buttonArmLeftGreen = 1;
final int buttonBoobsRed = 2;
final int buttonStomachBlue = 3;
final int buttonThighRightPink = 4;
final int buttonThighLeftOrange = 5;

void InitInputs(boolean pinValues[], Arduino arduino)
{
  int index = pinbuttonArmRightYellow;
  for (int i = 0; i < 6; ++i)
  {
    arduino.pinMode(index, Arduino.INPUT);
    pinValues[i] = false;
    index++;
  }
}

void GetInputs(boolean pinValues[], Arduino arduino)
{
  int valueButton = Arduino.LOW;
  int index = pinbuttonArmRightYellow;
  for (int i = 0; i < 6; ++i)
  {
    pinValues[i] = (arduino.digitalRead(index) == valueButton) ? true : false;
    index++;
  }
}  
