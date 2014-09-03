import processing.serial.*;
import cc.arduino.*;

Arduino arduinoP1;

int pinLed = 7;
int pinButton = 5;

void setup()
{
  println(Arduino.list());
  arduinoP1 = new Arduino(this, Arduino.list()[0]);
  arduinoP1.pinMode(pinButton, Arduino.INPUT);
}

void draw()
{
  if (arduinoP1.digitalRead(pinButton) == Arduino.LOW)
  {
    arduinoP1.digitalWrite(pinLed, Arduino.HIGH);
    println("Press");
  }
  else
  {
    arduinoP1.digitalWrite(pinLed, Arduino.LOW);
    println("Release");
  }
}
