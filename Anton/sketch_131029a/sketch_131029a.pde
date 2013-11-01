import processing.serial.*;
import cc.arduino.*;

Arduino arduino;
int ledPin = 13;
boolean aPressed = false;
boolean precedent = false;

int currentTime;
int tempo =200;
int delta;

void setup()
{
  //println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);
  arduino.pinMode(ledPin, Arduino.OUTPUT);
}

void draw()
{
  if(aPressed ){
    arduino.digitalWrite(ledPin, Arduino.HIGH);
    println("allumer");
  }else if(!aPressed ){
    arduino.digitalWrite(ledPin, Arduino.LOW);
    println("off");aa
  }
  precedent = aPressed;
}
void keyPressed() {
  if (key == 'a' ) {
    aPressed = true;
  }
}
void keyReleased(){  
  if (key == 'a' ) {
    aPressed = false;
  }
}
