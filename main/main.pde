import java.util.List;
import java.util.ArrayList;

double rotAngle = 30;
enum State {
  P2D,
  P3D;
}


Button dimensionToggleButton;
State state = State.P2D;
int xPos, yPos;
List<PVector> points = new ArrayList();
PShape object3D; 
int separatorX;

void setup(){
  size(1200, 800, P3D);
  separatorX = width / 2;
  dimensionToggleButton = initButton("2D", 60, 40, 80, 40);
  xPos = width / 2;
  yPos = 0;
}


void draw(){
  background(0, 0, 0);
  dimensionToggleButton.draw();
  stroke(255, 255, 255);
  if (state == State.P2D){
    drawMiddle();
    drawLine();
  }else if (state == State.P3D && object3D != null){
    println(xPos);
    translate(xPos, yPos);
    shape(object3D);
  }
}

Button initButton(String text, int x, int y, int w, int h){
  Button button  = new Button(text, x, y, w, h);
  button.changeFontSize(20);
  return button;
}


void drawMiddle(){
  int gap = 10;
  line(width / 2, gap, width / 2, height - gap);
}


PVector rotatePoint(PVector point){
  PVector result = new PVector(0, 0, 0);
  double r = Math.toRadians(rotAngle);
  result.x = (float)(point.x * Math.cos(r) - point.z * Math.sin(r));
  result.z = (float)(point.x * Math.sin(r) + point.z * Math.cos(r));
  result.y = point.y;
  return result;
}

List<PVector> rotateLine(){
  List<PVector> rotated = new ArrayList();
  for (int i = 0; i < points.size(); i++){
    PVector v = points.get(i);
    rotated.add(rotatePoint(v));
  }
  return rotated;
}


void addVertex(List<PVector> rotated){
  if (rotated.isEmpty()) return;
  object3D.vertex(rotated.get(0).x, rotated.get(0).y, rotated.get(0).z);
  for (int i = 0; i < rotated.size() - 1; i++){
    object3D.vertex(points.get(i).x, points.get(i).y, points.get(i).z);
    object3D.vertex(rotated.get(i + 1).x, rotated.get(i + 1).y, rotated.get(i + 1).z);
  }
  PVector v = points.get(points.size() - 1);
  object3D.vertex(v.x, v.y, v.z);
} 


void makeShape(){
  object3D = createShape();
  object3D.beginShape(TRIANGLE_STRIP);
  object3D.stroke(255, 0, 0);
  double angle = 0;
  while (angle < 360){
    List<PVector> rotated = rotateLine();
    addVertex(rotated);
    points = rotated;
    angle += rotAngle;
  }
  object3D.endShape();
  
}

void drawLine(){
  if (points.isEmpty()) return;
  for(int i = 0; i < points.size() - 1; i++){
    line(separatorX + points.get(i).x, points.get(i).y, separatorX + points.get(i + 1).x, points.get(i + 1).y);
  }
}

void mouseClicked(){
  if (dimensionToggleButton.isMouseOver()){
    dimensionControl();
  }else if (mouseButton == LEFT){
    if (mouseX >= width / 2){
      points.add(new PVector(mouseX - separatorX, mouseY, 0));
    }
  }
}

void dimensionControl(){
  String text = "2D";
  if (state == State.P2D){
    state = State.P3D;
    text = "3D";
    makeShape();
  }else {
    state = State.P2D; 
  }
  dimensionToggleButton.changeText(text);
}

void mouseDragged(){
  if (state == State.P3D){
    xPos = mouseX;
    yPos = mouseY - height / 2;
  }
}

void mouseMoved(){
  dimensionToggleButton.mouseOver();
}
