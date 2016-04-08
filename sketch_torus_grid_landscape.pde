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

void settings() {
  size(screenWidth, screenHeight, P3D);
  PJOGL.profile=1; // OpenGL 1.2 / 2.x context, for Syphon compatibility
}

void setup() {
  // Create syhpon server to send frames out.
  server = new SyphonServer(this, "sketch_thread_lattice");

  /* create a new instance of oscP5. 
   * 12000 is the port number you are listening for incoming osc messages.
   */
  oscP5 = new OscP5(this,12000);

  Ani.init(this);

  // smooth(8);
  frameRate(60);

  torus = new Torus();

  melodies = new ArrayList<Melody>();
  for (int i = 0; i < 7; i++) {
    melodies.add(new Melody(torus.getMesh()));
  }

  blinkingFaces = new ArrayList<BlinkingFace>();
  for (int i = 0; i < 50; i++) {
    blinkingFaces.add(new BlinkingFace(torus.getMesh()));
  }

  render = new WB_Render(this);
  
  perspective(PI/4, float(width)/float(height), 1.0, 10000.0);
  cam = new PeasyCam(this, 0);

  blendMode(ADD);
}

void update() {
  cam.setRotations(camRotateX, camRotateY, camRotateZ);
  pushMatrix();
  translate(0, 70, 25);
  lightFalloff(0,0,0.0005);
  pointLight(255, 255, 255, 0, 0, 0);
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

  lightFalloff(0,0,0.001);
  for (Melody melody : melodies) {
    melody.addLight();
  }

  strokeWeight(3);
  torus.draw(render);

  strokeWeight(5);
  for (Melody melody : melodies) {
    melody.draw(render);
  }

  strokeWeight(3);
  for (BlinkingFace blinkingFace : blinkingFaces) {
    blinkingFace.draw(render);
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
    camRotateX = map(floatVal, 0, 1, -PI, PI);
  }
  else if (addr.equals("/FromVDMX/Slider3")) {
    camRotateY = map(floatVal, 0, 1, -PI, PI); 
  }
  else if (addr.equals("/FromVDMX/Slider4")) {
    camRotateZ = map(floatVal, 0, 1, -PI, PI); 
  }
  else if (addr.equals("/FromVDMX/Slider5")) {
  }
  else if (addr.equals("/FromVDMX/Slider6")) {
  }
  else if (addr.equals("/FromVDMX/Slider7")) {
  }
  else if (addr.equals("/FromVDMX/Slider8")) {
  }
  else if (addr.equals("/FromVDMX/S1")) {
    for ( Melody melody : melodies ) {
      melody.animate();
    }
  }
  else if (addr.equals("/FromVDMX/M1")) {
  }
  else if (addr.equals("/FromVDMX/R1")) {
  }

  // theOscMessage.print();
}

void keyPressed(KeyEvent e) {
    for ( Melody melody : melodies ) {
      melody.animate();
    }
}