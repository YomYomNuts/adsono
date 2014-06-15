// Rumble pin
final int rumbleArmRightYellow = 49;
final int rumbleArmLeftGreen = 48;
final int rumbleBoobsRed = 47;
final int rumbleStomachBlue = 46;
final int rumbleThighRightPink = 45;
final int rumbleThighLeftOrange = 44;

// Led pin
final int ledArmRightYellow = 19;
final int ledArmLeftGreen = 18;
final int ledBoobsRed = 17;
final int ledStomachBlue = 16;
final int ledThighRightPink = 15;
final int ledThighLeftOrange = 14;

void stopAllRumble(Arduino arduino)
{
  setPinState(arduino, rumbleArmRightYellow, Arduino.LOW);
  setPinState(arduino, rumbleArmLeftGreen, Arduino.LOW);
  setPinState(arduino, rumbleBoobsRed, Arduino.LOW);
  setPinState(arduino, rumbleStomachBlue, Arduino.LOW);
  setPinState(arduino, rumbleThighRightPink, Arduino.LOW);
  setPinState(arduino, rumbleThighLeftOrange, Arduino.LOW);
}

void stopAllLED(Arduino arduino)
{
  setPinState(arduino, ledArmRightYellow, Arduino.LOW);
  setPinState(arduino, ledArmLeftGreen, Arduino.LOW);
  setPinState(arduino, ledBoobsRed, Arduino.LOW);
  setPinState(arduino, ledStomachBlue, Arduino.LOW);
  setPinState(arduino, ledThighRightPink, Arduino.LOW);
  setPinState(arduino, ledThighLeftOrange, Arduino.LOW);
}

void fireAllLED(Arduino arduino)
{
  setPinState(arduino, ledArmRightYellow, Arduino.HIGH);
  setPinState(arduino, ledArmLeftGreen, Arduino.HIGH);
  setPinState(arduino, ledBoobsRed, Arduino.HIGH);
  setPinState(arduino, ledStomachBlue, Arduino.HIGH);
  setPinState(arduino, ledThighRightPink, Arduino.HIGH);
  setPinState(arduino, ledThighLeftOrange, Arduino.HIGH);
}

int getLedPin(int input)
{
  switch (input)
  {
     case buttonArmRightYellow : 
       return ledArmRightYellow;
     case buttonArmLeftGreen : 
       return ledArmLeftGreen;
     case buttonBoobsRed : 
       return ledBoobsRed;
     case buttonStomachBlue : 
       return ledStomachBlue;
     case buttonThighRightPink : 
       return ledThighRightPink;
     case buttonThighLeftOrange : 
       return ledThighLeftOrange;
   }
   return -1;
}

int getRumblePin(int input)
{
  switch (input)
  {
     case buttonArmRightYellow : 
       return rumbleArmRightYellow;
     case buttonArmLeftGreen : 
       return rumbleArmLeftGreen;
     case buttonBoobsRed : 
       return rumbleBoobsRed;
     case buttonStomachBlue : 
       return rumbleStomachBlue;
     case buttonThighRightPink : 
       return rumbleThighRightPink;
     case buttonThighLeftOrange : 
       return rumbleThighLeftOrange;
  }
  return -1;
}

void setPinState(Arduino arduino, int pin, int value)
{
  arduino.digitalWrite(pin, value);
}
