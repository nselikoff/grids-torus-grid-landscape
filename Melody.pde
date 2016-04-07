class Melody {

  HE_Path path;
  Pulse pulse;

  Melody(HE_Mesh mesh) {
    int i, j;
    i = j = 0;

    while (i == j) {
      i = int(random(0, mesh.getNumberOfVertices() - 1));
      j = int(random(0, mesh.getNumberOfVertices() - 1));
    }
    HE_Vertex v0 = mesh.getVertexWithIndex(i);
    HE_Vertex v1 = mesh.getVertexWithIndex(j);
    
    WB_MeshGraph graph=new WB_MeshGraph(mesh);
    int[] shortestpath=graph.getShortestPathBetweenVertices(mesh.getIndex(v0), mesh.getIndex(v1));
    path = mesh.createPathFromIndices(shortestpath,false);
    
    println(path.getPathOrder());

    pulse = new Pulse(path);
  }

  void draw(WB_Render render) {
    stroke(255, 0, 0);
    noFill();
    render.drawPath(path);

//  for (HE_Vertex v : vertices) {
//   render.drawPoint(v, 10);
//  }

    pulse.draw();
  }

  void addLight() {
    pulse.addLight();
  }

  void animate() {
    pulse.animate();
  }

};