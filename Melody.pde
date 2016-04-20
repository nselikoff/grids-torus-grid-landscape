class Melody {

  HE_Mesh mesh;
  HE_Path path;
  List<HE_Halfedge> pathEdges;
  Pulse pulse;
  int counter;
  int pathOrder;

  Melody(HE_Mesh aMesh) {
    mesh = aMesh;
    init();
  }

  void init() {
    counter = 0;

    // constructShortestPathBetweenRandomPoints();
    constructRandomPath2();
    
    pathOrder = path.getPathOrder();
    pathEdges = path.getPathEdges();

    pulse = new Pulse(path);
  }

  void constructRandomPath2() {
    ArrayList<HE_Vertex> vertices = new ArrayList<HE_Vertex>();
    int[] indices;

    int length = 20;
    indices = new int[length];
    int index = int(random(0, mesh.getNumberOfVertices()));
    HE_Vertex v = mesh.getVertexWithIndex(index);

    // println("starting path construction with vertex " + v);
    vertices.add(v);
    indices[0] = mesh.getIndex(v);
    for( int i = 0; i < length - 1; i++ ) {
      List<HE_Vertex> neighbors = v.getNeighborVertices();
      // println("got " + neighbors.size() + " neighbors");
      if (random(0, 1) > 0.5) {
        // forwards
        int neighborIndex = 0;
        while(vertices.size() < i + 2 && neighborIndex < neighbors.size()) {
          if (vertices.contains(neighbors.get(neighborIndex))) {
            neighborIndex++;
          } else {
            v = neighbors.get(neighborIndex);
            // println("adding " + v);
            vertices.add(v);
            indices[i + 1] = mesh.getIndex(v);
          }
        }
      } else {
        // backwards
        int neighborIndex = neighbors.size() - 1;
        while(vertices.size() < i + 2 && neighborIndex >= 0) {
          if (vertices.contains(neighbors.get(neighborIndex))) {
            neighborIndex--;
          } else {
            v = neighbors.get(neighborIndex);
            // println("adding " + v);
            vertices.add(v);
            indices[i + 1] = mesh.getIndex(v);
          }
        }
      }
    }

    try {
      path = mesh.createPathFromIndices(indices, false);
    } catch(Exception e) {
      println(e.getMessage());
      println("error creating path, trying again");
      constructRandomPath2();
    }
    // println(path);
  }

  void constructRandomPath1(HE_Mesh mesh) {
    ArrayList<HE_Halfedge> halfedges = new ArrayList<HE_Halfedge>();
    Iterator<HE_Halfedge> heItr = mesh.heItr();
    HE_Halfedge he;

    int length = 10;
    int offset = int(random(0, mesh.getNumberOfHalfedges() - length));

    while (heItr.hasNext() && offset >= 0) {
      he = heItr.next();
      offset--;
    }

    while (heItr.hasNext() && length > 0) {
      he = heItr.next();
      halfedges.add(he);
      length--;
    }

    path = new HE_Path(halfedges, false);
    // println(path);
  }

  void constructShortestPathBetweenRandomPoints() {
    int i, j;
    i = j = 0;

    while (i == j) {
      i = int(random(0, mesh.getNumberOfVertices() - 1));
      j = int(random(0, mesh.getNumberOfVertices() - 1));
    }
    HE_Vertex v0 = mesh.getVertexWithIndex(i);
    HE_Vertex v1 = mesh.getVertexWithIndex(j);
    
    WB_MeshGraph graph = new WB_MeshGraph(mesh);
    int[] shortestpath = graph.getShortestPathBetweenVertices(mesh.getIndex(v0), mesh.getIndex(v1));
    path = mesh.createPathFromIndices(shortestpath,false);    
  }

  void update() {
    if (frameCount % 5 == 0) {
      counter = (counter + 1) % pathOrder;
      // if (counter == 0) {
      //   init();
      // }
    }
  }

  void draw(WB_Render render, float alpha) {
    update();

    stroke(255, 0, 0, 255 * alpha);
    noFill();
    // render.drawPath(path);

    render.drawEdge(pathEdges.get(counter));


//  for (HE_Vertex v : vertices) {
//   render.drawPoint(v, 10);
//  }

    // pulse.draw();
  }

  void addLight(float alpha) {
    // pulse.addLight();
    WB_Coord center = pathEdges.get(counter).getHalfedgeCenter();
    WB_Coord normal = pathEdges.get(counter).getEdgeNormal();

    pushMatrix();
    translate(center.xf(), center.yf(), center.zf());
    translate(normal.xf() * 1.0, normal.yf() * 1.0, normal.zf() * 1.0);
    // translate(-10, 0, -10);
    lightFalloff(0, 0, 0.003);
    pointLight(255 * alpha, 0, 0, 0, 0, 0);
    popMatrix();    
  }

  void animate() {
    // pulse.animate();
  }

};