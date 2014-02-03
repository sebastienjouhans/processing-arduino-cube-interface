import ddf.minim.*;

Minim minim;
AudioPlayer[] player = new AudioPlayer[3];
int trackCounter = 0;
boolean paused;

void loadMusic() 
{

  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  
  //load mp3 files from the data folder and store them a list called player
  player[0] = minim.loadFile("Movin on Up.mp3");
  player[1] = minim.loadFile("Dancing In The Street.mp3");
  player[2] = minim.loadFile("Once In A Lifetime.mp3");
  
  trackCounter = 0;
  paused = true;
}


void checkEndOfTrack() 
{
  if (player[trackCounter].isPlaying() == false && paused == false) 
  {
    player[trackCounter].pause();
    if ((trackCounter + 1) == player.length) 
    {
      trackCounter = 0;
    } 
    else 
    {
      trackCounter++;
    }
    player[trackCounter].rewind();
    player[trackCounter].play();
  }
}

// toggle between play and stop
void togglePlay() 
{
  if (player[trackCounter].isPlaying()) 
  {
      player[trackCounter].pause(); 
      paused = true;
      println("stop");
  }
  else 
  {
     player[trackCounter].play();
     paused = false;
     println("play");
  }
}

// jump to the prev available track in the player list
void prev() 
{
  player[trackCounter].pause();
  if ((trackCounter - 1) < 0) 
  {
    trackCounter = (player.length - 1);
  } 
  else 
  {
    trackCounter--;
  }
  player[trackCounter].rewind();
  if (paused == false) player[trackCounter].play();
}

// jump to the next available track in the player list
void next() 
{
    player[trackCounter].pause();
    if ((trackCounter + 1) == player.length) 
    {
      trackCounter = 0;
    } 
    else 
    {
      trackCounter++;
    }
    player[trackCounter].rewind();
    if (paused == false) player[trackCounter].play();   
}

// set volume
void changeVolume(int val) 
{
    player[trackCounter].setGain(val);
}



