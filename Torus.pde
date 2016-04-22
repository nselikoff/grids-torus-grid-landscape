class Torus {

  HE_Mesh mesh;
  PShader tunnelShader, tunnelLineShader;
  float time;
  PImage dummyTexture;

  Torus() {
    createMesh();
    initShaders();
  }

  void createMesh() {
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

    mesh.flipAllFaces();

  }

  void initShaders() {
    tunnelShader = loadShader("tunnelfrag.glsl", "tunnelvert.glsl");
    tunnelLineShader = loadShader("tunnellinefrag.glsl", "tunnellinevert.glsl");
    dummyTexture = createImage(128, 128, RGB);
    dummyTexture.loadPixels();
    for (int i = 0; i < dummyTexture.pixels.length; i++) {
      dummyTexture.pixels[i] = color(random(0,255), random(0,255), random(0,255)); 
    }
    dummyTexture.updatePixels();    
  }

  void draw(WB_Render render, float edgeAlpha, float faceAlpha) {

    fill(255);
    tint(255, 255 * faceAlpha);
    stroke(0, 32, 32, 255 * edgeAlpha);
    shader(tunnelShader);
    shader(tunnelLineShader, LINES);
    tunnelShader.set("modelviewInv", ((PGraphicsOpenGL) g).modelviewInv);
    tunnelShader.set("time", time);
    render.drawFaces(mesh, dummyTexture);
    resetShader();

  }

  HE_Mesh getMesh() { return mesh; }

  void animateRing() {
    time = 0.0;
    Ani.to(this, 2.0, "time", 1.0, Ani.LINEAR);
  }

};