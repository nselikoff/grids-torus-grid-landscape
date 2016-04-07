class BlinkingFace {

  HE_Face face;
  float intensity;
  float intensityOffset;
  color fillColor;

  BlinkingFace(HE_Mesh mesh) {
    int numFaces = mesh.getNumberOfFaces();
    int faceIndex = int(random(0, numFaces));
    face = mesh.getFaceWithIndex(faceIndex);
    intensityOffset = random(0, 100);
    fillColor = color(int(random(0,2))*255, int(random(0,2))*255, int(random(0,2))*255);
    if (red(fillColor) == 0 && green(fillColor) == 0 && blue(fillColor) == 0) {
      fillColor = color(0, 255, 0);
    }
  }

  void update() {
    intensity = noise(frameCount * 0.05, intensityOffset) > 0.5 ? 1.0 : 0.0;
  }

  void draw(WB_Render render) {
    update();

    // fill(fillColor);
    fill(fillColor, 32);
    stroke(fillColor);
    emissive(red(fillColor)*intensity, green(fillColor)*intensity, blue(fillColor)*intensity);
    render.drawFace(face);
  }
};