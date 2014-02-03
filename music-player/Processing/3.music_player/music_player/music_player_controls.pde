import ddf.minim.*;

Minim minim;
AudioPlayer[] playList = new AudioPlayer[12];
int trackCounter = 0;
boolean paused;

void loadMusic() 
{

  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  
  //load mp3 files from the data folder and store them a list called playList
  playList[0] = minim.loadFile("01 Raga Bhupali.mp3");
  playList[1] = minim.loadFile("02 Pocket Calculator.mp3");
  playList[2] = minim.loadFile("03 Sing.mp3");
  playList[3] = minim.loadFile("04 Choronzon.mp3");
  playList[4] = minim.loadFile("05 Maze.mp3");
  playList[5] = minim.loadFile("06 The Word Before Last.mp3");
  playList[6] = minim.loadFile("07 Its Not Right.mp3");
  playList[7] = minim.loadFile("08 Changeling.mp3");
  playList[8] = minim.loadFile("09 Playground For A Wedgeless Firm.mp3");
  playList[9] = minim.loadFile("10 Bonzai.mp3");
  playList[10] = minim.loadFile("11 Chase.mp3");
  playList[11] = minim.loadFile("12 Radio Waves.mp3");
  
  
  trackCounter = 0;
  paused = true;
}

//when track is coming to an end it'll go on to the next available track in the playList list
void checkEndOfTrack() 
{
  if (playList[trackCounter].isPlaying() == false && paused == false) 
  {
    playList[trackCounter].pause();
    if ((trackCounter + 1) == playList.length) 
    {
      trackCounter = 0;
    } 
    else 
    {
      trackCounter++;
    }
    playList[trackCounter].rewind();
    playList[trackCounter].play();
  }
}

// toggle between play and stop
void togglePlay() 
{
  if (playList[trackCounter].isPlaying()) 
  {
      playList[trackCounter].pause(); 
      paused = true;
      println("stop");
  }
  else 
  {
     playList[trackCounter].play();
     paused = false;
     println("play");
  }
}

// jump to the prev available track in the playList list
void prev() 
{
  playList[trackCounter].pause();
  if ((trackCounter - 1) < 0) 
  {
    trackCounter = (playList.length - 1);
  } 
  else 
  {
    trackCounter--;
  }
  playList[trackCounter].rewind();
  if (paused == false) playList[trackCounter].play();
  
  changeVolume(volume);   
}

// jump to the next available track in the playList list
void next() 
{
    playList[trackCounter].pause();
    if ((trackCounter + 1) == playList.length) 
    {
      trackCounter = 0;
    } 
    else 
    {
      trackCounter++;
    }
    playList[trackCounter].rewind();
    if (paused == false) playList[trackCounter].play();
   
   changeVolume(volume);   
}

// set volume
void changeVolume(int val) 
{
    playList[trackCounter].setGain(val);
}



