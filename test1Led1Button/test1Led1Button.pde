import processing.serial.*;
import cc.arduino.*;

Arduino arduinoP1;

int pinLed = 30;
int pinButton = 32;

void setup()
{
  println(Arduino.list());
  arduinoP1 = new Arduino(this, Arduino.list()[0]);
  arduinoP1.pinMode(25, Arduino.INPUT); //Vert
  arduinoP1.pinMode(27, Arduino.INPUT); //Jaune
  arduinoP1.pinMode(29, Arduino.INPUT); //Rouge
  arduinoP1.pinMode(31, Arduino.INPUT); //Bleu
  arduinoP1.pinMode(33, Arduino.INPUT); //Blanc
}

void draw()
{
  //for (int i = 22; i < 36; ++i)
    //arduinoP1.digitalWrite(i, Arduino.HIGH);
    //println(i + " " + arduinoP1.digitalRead(i));
  /*if (arduinoP1.digitalRead(pinButton) == Arduino.LOW)
  {
    arduinoP1.digitalWrite(pinLed, Arduino.HIGH);
    println("Press");
  }
  else
  {
    arduinoP1.digitalWrite(pinLed, Arduino.LOW);
    println("Release");
  }*/
}
