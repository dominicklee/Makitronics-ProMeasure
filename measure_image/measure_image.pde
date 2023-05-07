import java.io.File;

PImage img;
PVector startPoint, endPoint, circleStart, circleEnd;
boolean dragging = false, measuring = false;
float quarterDiameterMM = 24.26; // Diameter of a US quarter in millimeters
float scale, circleDiameterPixels;
ArrayList<PVector> lines = new ArrayList<PVector>();
String settingsFilename = "settings.txt";
String helperText = "Draw a circle around the quarter to calibrate.";

// Add the following variables for buttons
int buttonWidth = 70;
int buttonHeight = 25;
int buttonSpacing = 10;
int buttonX = 10;
int buttonY = 10;
boolean btnClicked = false;

void setup() {
  size(700, 700);
  surface.setTitle("Makitronics ProMeasure");
  img = loadImage("pcb_image.jpg"); // Replace with your image filename
  float imgScaleX = width / (float) img.width;
  float imgScaleY = height / (float) img.height;
  scale = min(imgScaleX, imgScaleY);
  imageMode(CENTER);
  startPoint = new PVector();
  endPoint = new PVector();
  circleStart = new PVector();
  circleEnd = new PVector();

  File settingsFile = new File(sketchPath("data/" + settingsFilename));
  if (settingsFile.exists()) {
    String[] settingsLines = loadStrings("data/" + settingsFilename);
    circleDiameterPixels = float(settingsLines[0]);
    measuring = true;
    helperText = "Drag mouse from point A to point B to measure.";
    println("Settings loaded");
  }
}

void draw() {
  background(255);
  
  // draw buttons
  noStroke();
  fill(200);
  rect(buttonX, buttonY, buttonWidth, buttonHeight);
  rect(buttonX + buttonWidth + buttonSpacing, buttonY, buttonWidth, buttonHeight);
  fill(0);
  textSize(12);
  text("Clear", buttonX + buttonWidth / 2 - textWidth("Clear") / 2, buttonY + buttonHeight / 2 + 6);
  text("Undo", buttonX + buttonWidth * 1.5 + buttonSpacing - textWidth("Undo") / 2, buttonY + buttonHeight / 2 + 6);
  textAlign(CENTER);
  fill(50, 60, 120);
  text(helperText, width / 2, height - 25);
  //restore
  textAlign(LEFT);
  fill(0);
  strokeWeight(2);
  
  pushMatrix();
  translate(width / 2, height / 2);
  scale(scale);
  image(img, 0, 0);
  popMatrix();

  if (dragging && !measuring) {
    stroke(0, 255, 0);
    strokeWeight(2);
    noFill();
    ellipseMode(CORNERS);
    ellipse(circleStart.x, circleStart.y, circleEnd.x, circleEnd.y);
  }

  for (int i = 0; i < lines.size(); i += 2) {
    PVector start = lines.get(i);
    PVector end = lines.get(i + 1);

    stroke(255, 0, 0);
    strokeWeight(2);
    line(start.x, start.y, end.x, end.y);

    drawArrow(start.x, start.y, end.x, end.y, 5);
    drawArrow(end.x, end.y, start.x, start.y, 5);

    float distancePixels = dist(start.x, start.y, end.x, end.y);
    float distanceMM = (distancePixels / circleDiameterPixels) * quarterDiameterMM;
    textSize(12);
    fill(255, 0, 0);
    text(nf(distanceMM, 0, 2) + " mm", end.x - 15, end.y + 18);
  }

  if (dragging && measuring) {
    stroke(255, 0, 0);
    strokeWeight(2);
    line(startPoint.x, startPoint.y, endPoint.x, endPoint.y);

    drawArrow(startPoint.x, startPoint.y, endPoint.x, endPoint.y, 5);
    drawArrow(endPoint.x, endPoint.y, startPoint.x, startPoint.y, 5);

    float distancePixels = dist(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
    float distanceMM = (distancePixels / circleDiameterPixels) * quarterDiameterMM;
    textSize(12);
    fill(255, 0, 0);
    text(nf(distanceMM, 0, 2) + " mm", endPoint.x - 15 , endPoint.y + 18);
  }
}

void mousePressed() {
  // Check for button clicks
  if (mouseX > buttonX && mouseX < buttonX + buttonWidth && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
    clearMeasurements();
    btnClicked = true;
    return;
  } else if (mouseX > buttonX + buttonWidth + buttonSpacing && mouseX < buttonX + buttonWidth * 2 + buttonSpacing && mouseY > buttonY && mouseY < buttonY + buttonHeight) {
    undoMeasurement();
    btnClicked = true;
    return;
  }
  
  if (!measuring) {
    circleStart.set(mouseX, mouseY);
  } else {
    startPoint.set(mouseX, mouseY);
  }
  dragging = true;
}

void mouseDragged() {
  if (!measuring) {
    circleEnd.set(mouseX, mouseY);
  } 
  else if (btnClicked) {
    //do nothing
  }
  else {
    endPoint.set(mouseX, mouseY);
  }
}

void mouseReleased() {
  if (!measuring) {
    circleDiameterPixels = dist(circleStart.x, circleStart.y, circleEnd.x, circleEnd.y);
    measuring = true;
    saveStrings("data/" + settingsFilename, new String[] {str(circleDiameterPixels)});
    helperText = "Drag mouse from point A to point B to measure.";
  } 
  else if (btnClicked) {
    btnClicked = false;
  }
  else {
    lines.add(new PVector(startPoint.x, startPoint.y));
    lines.add(new PVector(endPoint.x, endPoint.y));
  }
  dragging = false;
}

void drawArrow(float x1, float y1, float x2, float y2, float size) {
  float angle = atan2(y2 - y1, x2 - x1);
  float arrowX1 = x2 - cos(angle - radians(30)) * size;
  float arrowY1 = y2 - sin(angle - radians(30)) * size;
  float arrowX2 = x2 - cos(angle + radians(30)) * size;
  float arrowY2 = y2 - sin(angle + radians(30)) * size;
  line(x2, y2, arrowX1, arrowY1);
  line(x2, y2, arrowX2, arrowY2);
}

// Add the following functions to handle button actions
void clearMeasurements() {
  lines.clear();
}

void undoMeasurement() {
  if (lines.size() >= 2) {
    lines.remove(lines.size() - 1);
    lines.remove(lines.size() - 1);
  }
}