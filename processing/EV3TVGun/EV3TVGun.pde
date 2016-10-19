/**
 * EV3 TV Gun
 * Karandash & Samodelkin, 2015
 */


import processing.serial.*;
import java.nio.ByteBuffer;


Serial myPort;  
int target = 0;
int score = 0;

byte[] in_message = new byte[64];
int in_mailbox_length = 0;
char[] in_mailbox = new char[16];
char[] in_value_chars = new char[64];
byte[] mes_value = new byte[0];

PImage[] img = new PImage[5];
PImage[] good = new PImage[8];
PImage[] bad = new PImage[4];
PImage bg, no, shot_yes, shot_no;

void setup() 
{
  fullScreen();
  background(0);
  String portName = Serial.list()[1];
  myPort = new Serial(this, portName, 115200);
  for (int i=0; i<5; i++) {
    img[i] = loadImage(i+".jpg");
    img[i].resize(width, height);
  }
  for (int i=0; i<4; i++) {
    bad[i] = loadImage("bad"+i+".png");
    bad[i].resize(int(width*300/1366), int(height*300/768));
  }
  for (int i=0; i<7; i++) {
    good[i] = loadImage("good"+i+".png");
    good[i].resize(int(width*300/1366), int(height*300/768));
  }
  bg = loadImage("background.jpg");
  bg.resize(width, height);
  no = loadImage("no.png");
  no.resize(width, height);
  shot_yes = loadImage("shot_yes.png");
  shot_no = loadImage("shot_no.png");
  shot_yes.resize(int(width*300/1366), int(height*300/768));
  shot_no.resize(int(width*300/1366), int(height*300/768));
}

void draw() {
  boolean InMessageTrue = false;
  while (myPort.available() > 0 && !InMessageTrue)
  {
    in_message = myPort.readBytes();
    myPort.readBytes(in_message);    

    if (in_message.length < 12) break;
    byte[] mes_size = {in_message[0], in_message[1]};

    in_mailbox_length = int(in_message[6]-1);
    if (in_mailbox_length > in_message.length-10) break;
    in_mailbox = new char[0];
    for (int i=0; i<in_mailbox_length; i++) {
      in_mailbox = append(in_mailbox, char(in_message[7+i]));
    }

    mes_value = new byte[0];
    byte[] mes_value = {in_message[in_message.length-4], in_message[in_message.length-3], in_message[in_message.length-2], in_message[in_message.length-1]};
    float x = java.nio.ByteBuffer.wrap(mes_value).order(java.nio.ByteOrder.LITTLE_ENDIAN).getFloat();
    String TmpString = new String(in_mailbox);

    for (int i=0; i<5; i++) {
      if (TmpString.equals("start") == true && x == i) {
        image(img[i], 0, 0);
      }
    }  

    if (TmpString.equals("target") == true && x == 1) {
      target = 1;
      image(bg, 0, 0);
      int bad_pos = int(random (0, 3));
      image(bad[bad_pos], int(90*width/1366), int(290*height/768));
      int good1_pos = int(random (0, 7));
      image(good[good1_pos], int(532*width/1366), int(290*height/768));
      int good2_pos = int(random (0, 7));
      image(good[good2_pos], int(974*width/1366), int(290*height/768));
    }

    if (TmpString.equals("target") == true && x == 2) {
      target = 2;
      image(bg, 0, 0);
      int good1_pos = int(random (0, 7));
      image(good[good1_pos], int(90*width/1366), int(290*height/768));
      int bad_pos = int(random (0, 3));
      image(bad[bad_pos], int(532*width/1366), int(290*height/768));        
      int good2_pos = int(random (0, 7));
      image(good[good2_pos], int(974*width/1366), int(290*height/768));    
    }

    if (TmpString.equals("target") == true && x == 3) {
      target = 3;
      image(bg, 0, 0);
      int good1_pos = int(random (0, 7));
      image(good[good1_pos], int(90*width/1366), int(290*height/768));
      int good2_pos = int(random (0, 7));
      image(good[good2_pos], int(532*width/1366), int(290*height/768));         
      int bad_pos = int(random (0, 3));
      image(bad[bad_pos], int(974*width/1366), int(290*height/768));
    }

    if (TmpString.equals("shot") == true) {
      if (int(x) == 0) {
        image(no, 0, 0);
        score = 0;
      }
      else score++;

      if (target == 1 && int(x) != 0) {
        if (x == target) image(shot_yes, int(90*width/1366), int(290*height/768));
        else image(shot_no, int(90*width/1366), int(290*height/768));
      }

      if (target == 2 && int(x) != 0) {
        if (x == target) image(shot_yes, int(532*width/1366), int(290*height/768));
        else image(shot_no, int(532*width/1366), int(290*height/768));
      }        

      if (target == 3 && int(x) != 0) {
        if (x == target) image(shot_yes, int(974*width/1366), int(290*height/768));
        else image(shot_no, int(974*width/1366), int(290*height/768));
      }
    }

    if (TmpString.equals("end") == true && x == 0) {
      exit();
    }
  }
}