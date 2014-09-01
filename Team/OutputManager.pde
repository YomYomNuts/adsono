// Rumble pin
final int rumbleYellow = 49;
final int rumbleGreen = 48;
final int rumbleRed = 47;
final int rumbleBlue = 46;
final int rumbleWhite = 45;

// Led pin
final int ledYellow = 19;
final int ledGreen = 18;
final int ledRed = 17;
final int ledBlue = 16;
final int ledWhite = 15;

void stopAllRumble(Arduino arduino)
{
  setPinState(arduino, rumbleYellow, Arduino.LOW);
  setPinState(arduino, rumbleGreen, Arduino.LOW);
  setPinState(arduino, rumbleRed, Arduino.LOW);
  setPinState(arduino, rumbleBlue, Arduino.LOW);
  setPinState(arduino, rumbleWhite, Arduino.LOW);
}

void stopAllLED(Arduino arduino)
{
  setPinState(arduino, ledYellow, Arduino.LOW);
  setPinState(arduino, ledGreen, Arduino.LOW);
  setPinState(arduino, ledRed, Arduino.LOW);
  setPinState(arduino, ledBlue, Arduino.LOW);
  setPinState(arduino, ledWhite, Arduino.LOW);
}

void fireAllLED(Arduino arduino)
{
  setPinState(arduino, ledYellow, Arduino.HIGH);
  setPinState(arduino, ledGreen, Arduino.HIGH);
  setPinState(arduino, ledRed, Arduino.HIGH);
  setPinState(arduino, ledBlue, Arduino.HIGH);
  setPinState(arduino, ledWhite, Arduino.HIGH);
}

int getLedPin(int input)
{
  switch (input)
  {
     case buttonYellow : 
       return ledYellow;
     case buttonGreen : 
       return ledGreen;
     case buttonRed : 
       return ledRed;
     case buttonBlue : 
       return ledBlue;
     case buttonWhite : 
       return ledWhite;
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
