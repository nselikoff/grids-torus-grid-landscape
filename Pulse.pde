class Pulse {

  AniSequence seq;
  float pulsePositionX, pulsePositionY, pulsePositionZ;

  Pulse(HE_Path path) {
    pulsePositionX = 0.0;
    pulsePositionY = 0.0;
    pulsePositionZ = 0.0;

    ArrayList<HE_Vertex> vertices = new ArrayList<HE_Vertex>();
    //vertices.add(v0);
    //for( HE_Vertex neighbor : v0.getNextNeighborVertices() ) {
    //  vertices.add(neighbor);
    //}
    
    Iterator<HE_Vertex> pathVertexItr = new HE_PathVertexIterator(path);
    while (pathVertexItr.hasNext()) {
      vertices.add(pathVertexItr.next());
    }

    seq = new AniSequence(sketch_torus_grid_landscape.this);
    seq.beginSequence();

    for (int i = 0; i < vertices.size(); i++) {
      seq.beginStep();
      seq.add(Ani.to(this, 0.5, "pulsePositionX", vertices.get(i).xf(), Ani.LINEAR));
      seq.add(Ani.to(this, 0.5, "pulsePositionY", vertices.get(i).yf(), Ani.LINEAR));
      seq.add(Ani.to(this, 0.5, "pulsePositionZ", vertices.get(i).zf(), Ani.LINEAR));
      seq.endStep();
    }
    
    seq.endSequence();

    // start the whole sequence
    seq.start();
  }

  void addLight() {
    pushMatrix();
    translate(pulsePositionX, pulsePositionY, pulsePositionZ);
    translate(-10, 0, -10);
    lightFalloff(0, 0, 0.01);
    pointLight(255, 0, 0, 0, 0, 0);
    popMatrix();
  }

  void draw() {
    pushMatrix();
    translate(pulsePositionX, pulsePositionY, pulsePositionZ);
    sphere(1);
    popMatrix();    
  }

  void animate() {
    seq.start();
  }
};