import processing.serial.*;
import cc.arduino.*;

Arduino arduinoP1;
Arduino arduinoP2;

int powerOn = Arduino.LOW;

int pinTest = 7;
int pinButton = 5;
final int valuePressButtonAnalog = 1016;

void setup()
{
  println(Arduino.list());
  arduinoP1 = new Arduino(this, Arduino.list()[0]);
  arduinoP2 = new Arduino(this, Arduino.list()[1]);
}

void draw()
{
  for (int pin = 0; pin < 58; ++pin)
  {
    arduinoP1.digitalWrite(pin, powerOn);
    arduinoP2.digitalWrite(pin, powerOn);
  }
  
  //arduinoP1.digitalWrite(pinTest, powerOn);
  /*println(arduinoP1.analogRead(pinButton));
  if (arduinoP1.analogRead(pinButton) >= valuePressButtonAnalog)
  {
    arduinoP1.digitalWrite(pinTest, Arduino.HIGH);
    println("Press");
  }
  else
  {
    arduinoP1.digitalWrite(pinTest, Arduino.LOW);
    //println("Release");
  }*/
}
