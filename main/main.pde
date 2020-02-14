import java.util.List;
import java.util.ArrayList;

double rotAngle = 30;
enum State {
  P2D,
  P3D;
}



State state = State.P2D;
List<PVector> points = new ArrayList();
PShape object3D; 
int separatorX;

void setup(){
  size(1200, 800, P3D);
  separatorX = width / 2;
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

void draw(){
  background(0, 0, 0);
  stroke(255, 255, 255);
  if (state == State.P2D){
    drawMiddle();
    drawLine();
  }else if (state == State.P3D){
    translate(mouseX, mouseY - height / 2);
    shape(object3D);
  }
}

void mouseClicked(){
  if (mouseButton == LEFT){
    if (mouseX >= width / 2){
      points.add(new PVector(mouseX - separatorX, mouseY, 0));
    }
  }else if (mouseButton == RIGHT){
    makeShape(); 
    state = State.P3D;
  }
}
