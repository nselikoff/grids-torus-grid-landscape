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

HE_Mesh mesh;
WB_Render render;
HE_Halfedge edge;
HE_Path path;
ArrayList<HE_Vertex> vertices;

//int screenWidth = 1280, screenHeight = 289;
int screenWidth = 1920, screenHeight = 434;

AniSequence seq;
float pulsePositionX, pulsePositionY, pulsePositionZ;

float camRotateX = 0;
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

  smooth(8);
  frameRate(60);
  
  mesh = new HE_Mesh(
    new HEC_Torus()
      .setRadius(50, 150)
      .setTubeFacets(12)
      .setTorusFacets(24)
      //.setTwist(12)
  );
  
  // for some reason have to do this in two steps
  HE_Vertex v;
  Iterator<HE_Vertex> vItr = mesh.vItr();
  ArrayList<WB_Coord> normals = new ArrayList<WB_Coord>();
  while (vItr.hasNext()) {
    v = vItr.next();
    normals.add(v.getVertexNormal());
  }
  Iterator<WB_Coord> vnItr = normals.iterator();
  vItr = mesh.vItr();
  WB_Coord n;
  while (vItr.hasNext()) {
    v = vItr.next();
    n = vnItr.next();
    v.addMulSelf(random(-10,10), n);
  }
  
  mesh.modify(new HEM_TriSplit());

  edge = mesh.getEdgeWithIndex(0);
  //path = new HE_Path(edge);
  HE_Vertex v0 = mesh.getVertexWithIndex(0);
  HE_Vertex v1 = mesh.getVertexWithIndex(100);
  
  WB_MeshGraph graph=new WB_MeshGraph(mesh);
  int[] shortestpath=graph.getShortestPathBetweenVertices(mesh.getIndex(v0), mesh.getIndex(v1));
  path = mesh.createPathFromIndices(shortestpath,false);
  
  println(path.getPathOrder());
  
  vertices = new ArrayList<HE_Vertex>();
  //vertices.add(v0);
  //for( HE_Vertex neighbor : v0.getNextNeighborVertices() ) {
  //  vertices.add(neighbor);
  //}
  
  Iterator<HE_Vertex> pathVertexItr = new HE_PathVertexIterator(path);
  while (pathVertexItr.hasNext()) {
    vertices.add(pathVertexItr.next());
  }
    
  seq = new AniSequence(this);
  seq.beginSequence();

  pulsePositionX = vertices.get(0).xf();
  pulsePositionY = vertices.get(0).yf();
  pulsePositionZ = vertices.get(0).zf();

  for (int i = 1; i < path.getPathOrder() + 1; i++) {
    seq.beginStep();
    seq.add(Ani.to(this, 0.05, "pulsePositionX", vertices.get(i).xf(), Ani.LINEAR));
    seq.add(Ani.to(this, 0.05, "pulsePositionY", vertices.get(i).yf(), Ani.LINEAR));
    seq.add(Ani.to(this, 0.05, "pulsePositionZ", vertices.get(i).zf(), Ani.LINEAR));
    seq.endStep();
  }
  
  seq.endSequence();

  // start the whole sequence
  seq.start();
    
  render = new WB_Render(this);
  
  perspective(PI/4, float(width)/float(height), 1.0, 10000.0);
  cam = new PeasyCam(this, 0);
}

void update() {
  //edge = edge.getNextInFace();

  //directionalLight(64, 64, 64, 1, 2, -1);
  //directionalLight(64, 64, 64, -1, -2, 1);
  pushMatrix();
  translate(0, 70, 25);
  lightFalloff(0,0,0.001);
  pointLight(255, 255, 255, 0, 0, 0);
  popMatrix();
  
}

void draw() {
  cam.setRotations(camRotateX, camRotateY, camRotateZ);

  update();
  
  background(0);
  translate(150, 0, 20);
  rotateZ(frameCount * 0.001);

  pushMatrix();
  translate(pulsePositionX, pulsePositionY, pulsePositionZ);
  translate(-10, 0, -10);
  lightFalloff(0, 0, 0.01);
  pointLight(255, 0, 0, 0, 0, 0);
  popMatrix();

  fill(255);
  stroke(0, 255, 255, 16);
  strokeWeight(2);
  //noStroke();
  //render.drawEdges(mesh);
  render.drawFaces(mesh);
 
  stroke(255, 0, 0);
  noFill();
  //render.drawEdge(edge);
  render.drawPath(path);

//  for (HE_Vertex v : vertices) {
//   render.drawPoint(v, 10);
//  }
  pushMatrix();
  translate(pulsePositionX, pulsePositionY, pulsePositionZ);
  sphere(1);
  popMatrix();

  server.sendScreen();
}

void startSequence() {
  seq.start();
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
     startSequence(); 
  }
  else if (addr.equals("/FromVDMX/M1")) {
  }
  else if (addr.equals("/FromVDMX/R1")) {
  }

  // theOscMessage.print();
}