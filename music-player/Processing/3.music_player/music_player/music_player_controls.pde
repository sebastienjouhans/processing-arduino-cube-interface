import ddf.minim.*;

Minim minim;
AudioPlayer[] player = new AudioPlayer[3];
int trackCounter;
boolean paused;

void loadMusic() {

  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);
  
  // loadFile will look in all the same places as loadImage does.
  // this means you can find files that are in the data folder and the 
  // sketch folder. you can also pass an absolute path, or a URL.
  player[0] = minim.loadFile("Movin on Up.mp3");
  player[1] = minim.loadFile("Dancing In The Street.mp3");
  player[2] = minim.loadFile("Once In A Lifetime.mp3");
  
  trackCounter = 0;
  paused = true;
}

void checkEndOfTrack() {
if (player[trackCounter].isPlaying() == false && paused == false) {
    player[trackCounter].pause();
    if ((trackCounter + 1) == player.length) {
      trackCounter = 0;
    } else {trackCounter++;}
    player[trackCounter].rewind();
    player[trackCounter].play();
  }
}

void togglePlay() {
  if (player[trackCounter].isPlaying()) {
      player[trackCounter].pause(); 
      paused = true;
  }
  else {
     player[trackCounter].play();
     paused = false;
  }
}

void prev() {
    player[trackCounter].pause();
    if ((trackCounter - 1) < 0) {
      trackCounter = (player.length - 1);
    } else {trackCounter--;}
    player[trackCounter].rewind();
    if (paused == false) player[trackCounter].play();
}


void next() {
    player[trackCounter].pause();
    if ((trackCounter + 1) == player.length) {
      trackCounter = 0;
    } else {trackCounter++;}
    player[trackCounter].rewind();
    if (paused == false) player[trackCounter].play();   
}

void changeVolume(int val) {
    player[trackCounter].setGain(val);
}



