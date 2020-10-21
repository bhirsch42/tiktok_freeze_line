import processing.video.*;

Capture cam;
int width = 1280;
int height = 720;
PGraphics pg;

void setup() {
  size(1280, 720);
  pg = createGraphics(width, height);
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an
    // element from the array returned by list():
    cam = new Capture(this, width, height, cameras[1]);
    cam.start();
  }
}

int startTime = millis() + 3000;
int traversalDuration = 8 * 1000;

int getLineX() {
  float delta = float(millis() - startTime) / traversalDuration;
  return min(int(delta * width), width);
}

void draw() {
  if (mousePressed) {
    startTime = millis();
  }

  if (cam.available() == true) {
    cam.read();
  }

  int lineX = getLineX();
  PImage croppedCamFrame = cam.get(0, 0, width - lineX, height);

  pg.beginDraw();
  pg.scale(-1, 1);
  pg.translate(-width, 0);
  pg.image(croppedCamFrame, 0, 0);
  pg.endDraw();

  image(pg, 0, 0);
  line(lineX, 0, lineX, height);
}
