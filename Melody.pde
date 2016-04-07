class Melody {

  HE_Halfedge edge;
  HE_Path path;

  Melody(HE_Mesh mesh) {

    edge = mesh.getEdgeWithIndex(0);
    //path = new HE_Path(edge);
    HE_Vertex v0 = mesh.getVertexWithIndex(0);
    HE_Vertex v1 = mesh.getVertexWithIndex(100);
    
    WB_MeshGraph graph=new WB_MeshGraph(mesh);
    int[] shortestpath=graph.getShortestPathBetweenVertices(mesh.getIndex(v0), mesh.getIndex(v1));
    path = mesh.createPathFromIndices(shortestpath,false);
    
    println(path.getPathOrder());
  }

  void draw(WB_Render render) {
    stroke(255, 0, 0);
    noFill();
    //render.drawEdge(edge);
    render.drawPath(path);

//  for (HE_Vertex v : vertices) {
//   render.drawPoint(v, 10);
//  }
  }

  HE_Path getPath() { return path; }

};