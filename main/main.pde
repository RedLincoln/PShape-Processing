import java.util.List;
import java.util.ArrayList;

double rotAngle = 10;

enum State {
  P2D,
  P3D;
}

enum Movement {
  translate, 
  rotate;
}

Button dimensionToggleButton;
Button clearButton;
Button translateButton;
Button rotateButton;
Movement movement = Movement.translate;
boolean rotateX = true;
State state = State.P2D;
float rotationRatio = 0.1;
int xPos, yPos;
List<PVector> points = new ArrayList();
List<PVector> orig = new ArrayList();
PShape object3D; 
int separatorX;
int separatorY;
int foregroundColor = #ffffff;
int backgroundColor = #000000;
int startX = 0;
int startY = 0;
int step = 15;

void setup(){
  size(1200, 800, P3D);
  separatorX = width / 2;
  separatorY = height / 2;
  dimensionToggleButton = initButton("3D", 60, 40, 80, 40);
  clearButton = initButton("Clear", 160, 40, 80, 40);
  translateButton = initButton("Translate", 80, 100, 120, 40);
  translateButton.selected(true);
  rotateButton = initButton("Rotate-X", 220, 100, 120, 40);
  setInitPos();
}

void draw(){
  background(backgroundColor);
  dimensionToggleButton.draw();
  stroke(255, 255, 255);
  if (state == State.P2D){
    clearButton.draw();
    drawMiddle();
    drawLine();
  }else if (state == State.P3D){
    translateButton.draw();
    rotateButton.draw();
    translate(xPos, yPos);      
    shape(object3D);
  }
}

void setInitPos(){
  xPos = width / 2;
  yPos = height / 2;
}


boolean haveFigure(){
  return orig != null && !orig.isEmpty();
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

int getMidPoint(){
  float lower = orig.get(0).y;
  float higher = orig.get(0).y;
  for (PVector point: orig){
    if (point.y < lower){
      lower = point.y;
    }else if (point.y > higher){
      higher = point.y;
    }
  }
  return int((higher + lower) / 2);
}

void setMirrorFigure(){
  points.clear();
  int midPoint = getMidPoint();
  int diference = height / 2 - midPoint;
  for (PVector point : orig){
    points.add(new PVector(point.x, point.y - separatorY + diference, point.z));
  }
}

void makeShape(){
  if (object3D != null) return;
  setMirrorFigure();
  object3D = createShape();
  object3D.beginShape(TRIANGLE_STRIP);
  object3D.stroke(255, 0, 0);
  double angle = 0;
  while (angle <= 360){
    List<PVector> rotated = rotateLine();
    addVertex(rotated);
    points = rotated;
    angle += rotAngle;
  }
  object3D.endShape();
}

void drawLine(){
  if (!haveFigure()) return;  
  strokeWeight(3);
  point(separatorX + orig.get(0).x, orig.get(0).y, 0);
  for(int i = 0; i < orig.size() - 1; i++){    
    line(separatorX + orig.get(i).x, orig.get(i).y, separatorX + orig.get(i + 1).x,orig.get(i + 1).y);
  }
  strokeWeight(1);
}

void keyPressedTranslate(){
  if (keyCode == UP){
    yPos -= yPos > step ? step : 0;           
  }else if(keyCode == DOWN){
    yPos += yPos < height - step ? step : 0;  
  }else if(keyCode == LEFT){
    xPos -= xPos > step ? step : 0;  
  }else if(keyCode == RIGHT){
    xPos += xPos < width - step ? step : 0;  
  }
}

void keyPressedRotate(){
  if (key == 'w'){
    object3D.rotateX(rotationRatio);           
  }else if(key == 's'){
    object3D.rotateX(-rotationRatio);  
  }else if(key == 'a'){
    object3D.rotateY(rotationRatio);  
  }else if(key == 'd'){
    object3D.rotateY(-rotationRatio);  
  }
}

void keyPressed(){
  if (state == State.P3D ){
      keyPressedTranslate();
      keyPressedRotate();
  }
}

void mouseClicked(){
  if (dimensionToggleButton.isMouseOver()){
    if (haveFigure()){
      dimensionControl();
    }
  }else if (state == State.P2D && clearButton.isMouseOver()){
    orig.clear();
    object3D = null;
    setInitPos();
  }else if (state == State.P3D){
    if(translateButton.isMouseOver()){
      translateButton.selected(true);
      rotateButton.selected(false);
      movement = Movement.translate;
    }else if (rotateButton.isMouseOver()){
      translateButton.selected(false);
      rotateControl();
    }else if (movement == Movement.rotate){
      startX = mouseX;
      startY = mouseY;
    }
  }else if (mouseButton == LEFT){
    if (mouseX >= width / 2){
      object3D = null;
      orig.add(new PVector(mouseX - separatorX, mouseY, 0));
    }
  }
}

void rotateControl(){
  rotateButton.selected(true);
  if (movement != Movement.rotate){
    movement = Movement.rotate;
    return;
  }
  rotateX = !rotateX;
  if (rotateX){
    rotateButton.changeText("Rotate-X");
  }else{
    rotateButton.changeText("Rotate-Y");
  }
}

void dimensionControl(){
  String text = "3D";
  if (state == State.P2D){
    state = State.P3D;
    text = "2D";
    makeShape();
  }else {
    state = State.P2D; 
  }
  dimensionToggleButton.changeText(text);
}

void mouseDragged(){
  if (state == State.P3D &&
      !translateButton.isMouseOver() &&
      !rotateButton.isMouseOver()){
    if (movement == Movement.translate){
      xPos = mouseX;
      yPos = mouseY;
    }else if (movement == Movement.rotate){
      if (rotateX){
        if (mouseX < startX){
          object3D.rotate(-rotationRatio, 0, 1, 0);
        }else if (mouseX > startX){
          object3D.rotate(rotationRatio, 0, 1, 0);
        }
      }else{
        if (mouseY < startY){
          object3D.rotateX(rotationRatio);      
        }else if(mouseY > startY){
          object3D.rotateX(-rotationRatio);
        }
      }
      startX = mouseX;
      startY = mouseY;
    }
  }
}

void mouseMoved(){
  dimensionToggleButton.mouseOver();
  clearButton.mouseOver();
  translateButton.mouseOver();
  rotateButton.mouseOver();
}
