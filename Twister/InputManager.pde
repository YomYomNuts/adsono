// Pin buttons
final int pinbuttonYellow = 2;
final int pinbuttonGreen = 3;
final int pinbuttonRed = 4;
final int pinbuttonBlue = 5;
final int pinbuttonWhite = 6;

// Position buttons
final int buttonYellow = 0;
final int buttonGreen = 1;
final int buttonRed = 2;
final int buttonBlue = 3;
final int buttonWhite = 4;

void InitInputs(boolean pinValues[], Arduino arduino)
{
  arduino.pinMode(pinbuttonYellow, Arduino.INPUT);
  pinValues[buttonYellow] = false;
  arduino.pinMode(pinbuttonGreen, Arduino.INPUT);
  pinValues[buttonGreen] = false;
  arduino.pinMode(pinbuttonRed, Arduino.INPUT);
  pinValues[buttonRed] = false;
  arduino.pinMode(pinbuttonBlue, Arduino.INPUT);
  pinValues[buttonBlue] = false;
  arduino.pinMode(pinbuttonWhite, Arduino.INPUT);
  pinValues[buttonWhite] = false;
}

void GetInputs(boolean pinValues[], Arduino arduino)
{
  int valueButton = Arduino.LOW;
  pinValues[buttonYellow] = (arduino.digitalRead(pinbuttonYellow) == valueButton) ? true : false;
  pinValues[buttonGreen] = (arduino.digitalRead(pinbuttonGreen) == valueButton) ? true : false;
  pinValues[buttonRed] = (arduino.digitalRead(pinbuttonRed) == valueButton) ? true : false;
  pinValues[buttonBlue] = (arduino.digitalRead(pinbuttonBlue) == valueButton) ? true : false;
  pinValues[buttonWhite] = (arduino.digitalRead(pinbuttonWhite) == valueButton) ? true : false;
}  
