import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

Minim minim;
AudioPlayer player;
AudioInput input;
ArrayList<AudioPlayer> audioPlayers1;
ArrayList<AudioPlayer> audioPlayers2;
int counterAudioPlayer1;
int counterAudioPlayer2;
int tours = 1;

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
  
  audioPlayers1 = new ArrayList<AudioPlayer>();
  audioPlayers2 = new ArrayList<AudioPlayer>();
  counterAudioPlayer1 = 0 ;
  counterAudioPlayer2 = 0 ;
  audioPlayers1.add(minim.loadFile("../test.wav"));
  audioPlayers1.add(minim.loadFile("../p11.wav"));
  audioPlayers1.add(minim.loadFile("../p12.wav"));
  audioPlayers2.add(minim.loadFile("../p21.wav"));
  audioPlayers2.add(minim.loadFile("../p22.wav"));
  audioPlayers2.add(minim.loadFile("../test.wav"));
  tours = 1;
  
  prevTime = millis();
  currentTime = 0;
}
 
void draw()
{
  delta = millis() -  prevTime;
  currentTime += delta;
  if(currentTime >= tempo){
    currentTime = currentTime - tempo;
    
    if(tours == 1)
    {
      audioPlayers1.get(counterAudioPlayer1).rewind();
      audioPlayers1.get(counterAudioPlayer1).play();
      counterAudioPlayer1 = (counterAudioPlayer1 + 1) % audioPlayers1.size();
      
    }else
    {
      audioPlayers2.get(counterAudioPlayer2).rewind();
      audioPlayers2.get(counterAudioPlayer2).play();
      counterAudioPlayer2 = (counterAudioPlayer2 + 1) % audioPlayers2.size();
    }
  }
  
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
       case RIGHT :
         tours =(tours + 1)%2;
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
