import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;
AudioInput input;

 
int prevTime;
int currentTime;
int tempo =1000;
int delta;
final int pasTempo = 50;

void setup()
{
  size(100, 100);
 
  minim = new Minim(this);
  player = minim.loadFile("../test.wav");
  input = minim.getLineIn();
  
  prevTime = millis();
  currentTime = 0;
}
 
void draw()
{
  delta = millis() -  prevTime;
  currentTime += delta;
  if(currentTime >= tempo){
    currentTime = currentTime - tempo;
    
    
    player.rewind();
    player.play();
  }
  /*
  int nbT = int(random(1000));
  int x = 0;
  for(int i = 0; i< nbT;i++){
    x +=1;
  }
  println(" x = " + x);*/
  
  prevTime = millis();
}

void keyPressed() {
  if (key == CODED) {
    switch(keyCode){
      case UP:
        tempo += pasTempo;
        break;
      case DOWN :
        if(tempo > pasTempo){
          tempo -=pasTempo;
        }else{
          tempo = 0;
        }
        break;
    }
    println(tempo);
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
