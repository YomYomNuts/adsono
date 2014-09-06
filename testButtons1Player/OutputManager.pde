// Rumble pin
final int rumbleYellow = 2;
final int rumbleGreen = 3;
final int rumbleRed = 4;
final int rumbleBlue = 5;
final int rumbleWhite = 6;

// Led pin
final int ledYellowP1 = 43;
final int ledGreenP1 = 34;
final int ledRedP1 = 38;
final int ledBlueP1 = 42;
final int ledWhiteP1 = 39;

final int ledYellowP2 = 24;
final int ledGreenP2 = 22;
final int ledRedP2 = 26;
final int ledBlueP2 = 28;
final int ledWhiteP2 = 30;

void stopAllRumble(Arduino arduino)
{
  setPinState(arduino, rumbleYellow, Arduino.LOW);
  setPinState(arduino, rumbleGreen, Arduino.LOW);
  setPinState(arduino, rumbleRed, Arduino.LOW);
  setPinState(arduino, rumbleBlue, Arduino.LOW);
  setPinState(arduino, rumbleWhite, Arduino.LOW);
}

void stopAllLED(Arduino arduino, boolean firstArduino)
{
  if (firstArduino)
  {
    setPinState(arduino, ledYellowP1, Arduino.LOW);
    setPinState(arduino, ledGreenP1, Arduino.LOW);
    setPinState(arduino, ledRedP1, Arduino.LOW);
    setPinState(arduino, ledBlueP1, Arduino.LOW);
    setPinState(arduino, ledWhiteP1, Arduino.LOW);
  }
  else
  {
    setPinState(arduino, ledYellowP2, Arduino.LOW);
    setPinState(arduino, ledGreenP2, Arduino.LOW);
    setPinState(arduino, ledRedP2, Arduino.LOW);
    setPinState(arduino, ledBlueP2, Arduino.LOW);
    setPinState(arduino, ledWhiteP2, Arduino.LOW);
  }
}

void fireAllLED(Arduino arduino, boolean firstArduino)
{
  if (firstArduino)
  {
    setPinState(arduino, ledYellowP1, Arduino.HIGH);
    setPinState(arduino, ledGreenP1, Arduino.HIGH);
    setPinState(arduino, ledRedP1, Arduino.HIGH);
    setPinState(arduino, ledBlueP1, Arduino.HIGH);
    setPinState(arduino, ledWhiteP1, Arduino.HIGH);
  }
  else
  {
    setPinState(arduino, ledYellowP2, Arduino.HIGH);
    setPinState(arduino, ledGreenP2, Arduino.HIGH);
    setPinState(arduino, ledRedP2, Arduino.HIGH);
    setPinState(arduino, ledBlueP2, Arduino.HIGH);
    setPinState(arduino, ledWhiteP2, Arduino.HIGH);
  }
}

int getLedPin(int input, boolean firstArduino)
{
  if (firstArduino)
  {
    switch (input)
    {
       case buttonYellow : 
         return ledYellowP1;
       case buttonGreen : 
         return ledGreenP1;
       case buttonRed : 
         return ledRedP1;
       case buttonBlue : 
         return ledBlueP1;
       case buttonWhite : 
         return ledWhiteP1;
     }
  }
  else
  {
    switch (input)
    {
       case buttonYellow : 
         return ledYellowP2;
       case buttonGreen : 
         return ledGreenP2;
       case buttonRed : 
         return ledRedP2;
       case buttonBlue : 
         return ledBlueP2;
       case buttonWhite : 
         return ledWhiteP2;
     }
  }
   return -1;
}

int getRumblePin(int input)
{
  switch (input)
  {
     case buttonYellow : 
       return rumbleYellow;
     case buttonGreen : 
       return rumbleGreen;
     case buttonRed : 
       return rumbleRed;
     case buttonBlue : 
       return rumbleBlue;
     case buttonWhite : 
       return rumbleWhite;
  }
  return -1;
}

void setPinState(Arduino arduino, int pin, int value)
{
  arduino.digitalWrite(pin, value);
}
