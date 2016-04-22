import wblut.math.*;
import wblut.processing.*;
import wblut.core.*;
import wblut.hemesh.*;
import wblut.geom.*;
import java.util.*;
import peasy.*;
import codeanticode.syphon.*;
import de.looksgood.ani.*;
import oscP5.*;
import netP5.*;

SyphonServer server;

OscP5 oscP5;
NetAddress myBroadcastLocation; 

PeasyCam cam;

Torus torus;
ArrayList<Melody> melodies;
ArrayList<BlinkingFace> blinkingFaces;

WB_Render render;

//int screenWidth = 1280, screenHeight = 289;
int screenWidth = 1920, screenHeight = 434;

float camRotateX = 90;
float camRotateY = 0;
float camRotateZ = 0;

float echoAlpha = 0;
float melodyAlpha = 0;
float tunnelEdgeAlpha = 0;
float tunnelFaceAlpha = 0;

void settings() {
  size(screenWidth, screenHeight, P3D);
  PJOGL.profile=1; // OpenGL 1.2 / 2.x context, for Syphon compatibility
}

void setup() {
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "torus_grid_landscape");

  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  oscP5 = new OscP5(this,12000);

  Ani.init(this);

  // smooth(8);
  frameRate(60);

  torus = new Torus();

  melodies = new ArrayList<Melody>();
  for (int i = 0; i < 6; i++) {
    melodies.add(new Melody(torus.getMesh()));
  }

  blinkingFaces = new ArrayList<BlinkingFace>();
  for (int i = 0; i < 50; i++) {
    blinkingFaces.add(new BlinkingFace(torus.getMesh()));
  }

  render = new WB_Render(this);
  
  perspective(PI/4, float(width)/float(height), 1.0, 10000.0);
  cam = new PeasyCam(this, 0);
  cam.setRotations(camRotateX, camRotateY, camRotateZ);

  blendMode(ADD);
}

void update() {
  pushMatrix();
  translate(0, 70, 25);
  lightFalloff(0,0,0.0005);
  pointLight(255, 255, 255, 0, 0, 0);
  ambientLight(128, 128, 128);
  popMatrix();

  if (frameCount % 60 == 0) {
    println(frameRate);
  }
}

void draw() {
  update();
  
  background(0);
  translate(150, 0, 20);
  rotateZ(frameCount * 0.001);

  lightFalloff(0,0,0.0008);
  strokeWeight(2);
  for (Melody melody : melodies) {
    melody.addLight(melodyAlpha);
  }

  strokeWeight(3);
  torus.draw(render, tunnelEdgeAlpha, tunnelFaceAlpha);

  strokeWeight(5);
  for (Melody melody : melodies) {
    melody.draw(render, melodyAlpha);
  }

  strokeWeight(3);
  for (BlinkingFace blinkingFace : blinkingFaces) {
    blinkingFace.draw(render, echoAlpha);
  }
  emissive(0);

  server.sendScreen();
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  String addr = theOscMessage.addrPattern();
  String typetag = theOscMessage.typetag();
  float floatVal = 0;
  boolean boolVal = false;
  
  if (typetag.equals("f"))
    floatVal = theOscMessage.get(0).floatValue();
  else if (typetag.equals("b"))
    boolVal = theOscMessage.get(0).booleanValue();
  
  if (addr.equals("/FromVDMX/Slider1")) {
  }
  else if (addr.equals("/FromVDMX/Slider2")) {
  }
  else if (addr.equals("/FromVDMX/Slider3")) {
  }
  else if (addr.equals("/FromVDMX/Slider4")) {
  }
  else if (addr.equals("/FromVDMX/Slider5")) {
    echoAlpha = floatVal;
  }
  else if (addr.equals("/FromVDMX/Slider6")) {
    melodyAlpha = floatVal;
  }
  else if (addr.equals("/FromVDMX/Slider7")) {
    tunnelEdgeAlpha = floatVal;
  }
  else if (addr.equals("/FromVDMX/Slider8")) {
    tunnelFaceAlpha = floatVal;
  }
  else if (addr.equals("/FromVDMX/M1")) {
    for ( Melody melody : melodies ) {
      melody.init();
    }
  }
  else if (addr.equals("/FromVDMX/R1")) {
    for ( BlinkingFace blinkingFace : blinkingFaces ) {
      blinkingFace.init();
    }
  }
  else if (addr.equals("/FromVDMX/S3")) {
    torus.animateRing();
  }

  // theOscMessage.print();
}

void keyPressed(KeyEvent e) {
    for ( Melody melody : melodies ) {
      melody.animate();
    }
}