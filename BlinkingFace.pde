class BlinkingFace {

  HE_Face face;
  HE_Mesh mMesh;
  float intensity;
  float intensityOffset;
  color fillColor;

  BlinkingFace(HE_Mesh mesh) {
    mMesh = mesh;
    init();
  }

  void init() {
    int numFaces = mMesh.getNumberOfFaces();
    int faceIndex = int(random(0, numFaces));
    face = mMesh.getFaceWithIndex(faceIndex);
    intensityOffset = random(0, 100);

    fillColor = color(int(random(0,2))*255, int(random(0,2))*255, int(random(0,2))*255);
    if (red(fillColor) == 0 && green(fillColor) == 0 && blue(fillColor) == 0) {
      fillColor = color(0, 255, 0);
    }    
  }

  void update() {
    intensity = noise(frameCount * 0.05, intensityOffset) > 0.5 ? 1.0 : 0.0;
  }

  void draw(WB_Render render, float alpha) {
    update();

    // fill(fillColor);
    fill(fillColor, 64 * alpha);
    stroke(fillColor, 255 * alpha);
    emissive(red(fillColor)*intensity*alpha, green(fillColor)*intensity*alpha, blue(fillColor)*intensity*alpha);
    render.drawFace(face);
  }
};