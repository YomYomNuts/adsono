// Pin buttons
final int pinbuttonYellowP1 = 40;
final int pinbuttonGreenP1 = 37;
final int pinbuttonRedP1 = 41;
final int pinbuttonBlueP1 = 45;
final int pinbuttonWhiteP1 = 36;

final int pinbuttonYellowP2 = 27;
final int pinbuttonGreenP2 = 25;
final int pinbuttonRedP2 = 29;
final int pinbuttonBlueP2 = 31;
final int pinbuttonWhiteP2 = 33;

// Position buttons
final int buttonYellow = 0;
final int buttonGreen = 1;
final int buttonRed = 2;
final int buttonBlue = 3;
final int buttonWhite = 4;

void InitInputs(boolean pinValues[], Arduino arduino, boolean firstArduino)
{
  pinValues[buttonYellow] = false;
  pinValues[buttonGreen] = false;
  pinValues[buttonRed] = false;
  pinValues[buttonBlue] = false;
  pinValues[buttonWhite] = false;
  if (firstArduino)
  {
    arduino.pinMode(pinbuttonYellowP1, Arduino.INPUT);
    arduino.pinMode(pinbuttonGreenP1, Arduino.INPUT);
    arduino.pinMode(pinbuttonRedP1, Arduino.INPUT);
    arduino.pinMode(pinbuttonBlueP1, Arduino.INPUT);
    arduino.pinMode(pinbuttonWhiteP1, Arduino.INPUT);
  }
  else
  {
    arduino.pinMode(pinbuttonYellowP2, Arduino.INPUT);
    arduino.pinMode(pinbuttonGreenP2, Arduino.INPUT);
    arduino.pinMode(pinbuttonRedP2, Arduino.INPUT);
    arduino.pinMode(pinbuttonBlueP2, Arduino.INPUT);
    arduino.pinMode(pinbuttonWhiteP2, Arduino.INPUT);
  }
}

void GetInputs(boolean pinValues[], Arduino arduino, boolean firstArduino)
{
  int valueButton = Arduino.LOW;
  if (firstArduino)
  {
    pinValues[buttonYellow] = (arduino.digitalRead(pinbuttonYellowP1) == valueButton) ? true : false;
    pinValues[buttonGreen] = (arduino.digitalRead(pinbuttonGreenP1) == valueButton) ? true : false;
    pinValues[buttonRed] = (arduino.digitalRead(pinbuttonRedP1) == valueButton) ? true : false;
    pinValues[buttonBlue] = (arduino.digitalRead(pinbuttonBlueP1) == valueButton) ? true : false;
    pinValues[buttonWhite] = (arduino.digitalRead(pinbuttonWhiteP1) == valueButton) ? true : false;
  }
  else
  {
    pinValues[buttonYellow] = (arduino.digitalRead(pinbuttonYellowP2) == valueButton) ? true : false;
    pinValues[buttonGreen] = (arduino.digitalRead(pinbuttonGreenP2) == valueButton) ? true : false;
    pinValues[buttonRed] = (arduino.digitalRead(pinbuttonRedP2) == valueButton) ? true : false;
    pinValues[buttonBlue] = (arduino.digitalRead(pinbuttonBlueP2) == valueButton) ? true : false;
    pinValues[buttonWhite] = (arduino.digitalRead(pinbuttonWhiteP2) == valueButton) ? true : false;
  }
}  
