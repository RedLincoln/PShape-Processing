class Button {
  int x, y, w, h, fontSize = 12;
  String text;
  int buttonOffset = 2;
  int foreground = #ffffff;
  int unSelectedColor = #C0C0C0;
  int background = unSelectedColor;
  int selectedColor = #28a745;
  float baseAlpha = 128;
  float overAlpha = 255;
  float alpha = 128;
  
  public Button(String text, int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.text = text;
  }
  
  public void changeText(String text){
    this.text = text;
  }
  
  public void changeFontSize(int fontSize){
    this.fontSize = fontSize;
  }
  
  public void draw(){
    fill(background, alpha);
    rectMode(CENTER);
    strokeWeight(1);
    rect(x, y, w, h, 7);
    fill(foreground, alpha);
    textSize(fontSize);
    textAlign(CENTER);
    text(text, x, y + 7.5);
  }
  
  public void selected(boolean selected){
    if (selected)
      background = selectedColor;
    else
      background = unSelectedColor; 
  }
  
  public void mouseOver(){
    if (isMouseOver()){
      alpha = overAlpha;    
    }else{
      alpha = baseAlpha;
    }
  }
  
  public boolean isMouseOver(){
    return (mouseX + buttonOffset > x - w / 2 &&
        mouseX - buttonOffset < x + w / 2 &&
        mouseY + buttonOffset > y - h / 2 &&
        mouseY - buttonOffset < y + h / 2);
  }
}
