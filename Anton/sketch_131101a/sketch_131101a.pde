import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;
AudioInput input;
 
int currentTime;
int tempo =1000;
int delta;

void setup()
{
  size(100, 100);
 
  minim = new Minim(this);
  player = minim.loadFile("C:/Users/anton/Desktop/test.wav");
  input = minim.getLineIn();
  
  currentTime = millis();
}
 
void draw()
{
  delta = millis() -  currentTime;
  if(delta >= tempo){
    currentTime = millis();
    
    
    player.rewind();
    player.play();
  }
  // do what you do
}

void keyPressed() {
  switch(key){
    case 'o':
      println("hoha");
      tempo += 100;
      break;
    case 'l' :
      println("hoho");
      if(tempo > 100){
        tempo -=100;
      }else{
        tempo = 0;
      }
      break;
  }
}
void stop()
{
  // the AudioPlayer you got from Minim.loadFile()
  player.close();
  // the AudioInput you got from Minim.getLineIn()
  input.close();
  minim.stop();
 
  // this calls the stop method that 
  // you are overriding by defining your own
  // it must be called so that your application 
  // can do all the cleanup it would normally do
  super.stop();
}
