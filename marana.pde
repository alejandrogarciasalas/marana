/*
maraña (spanish for tangle)
 by Alejandro García Salas
 
a tentacles inspired procedural painting
*/

ArrayList<Particle> pts;
boolean onPressed, showInstruction;
PFont instructionsFont;

 
void setup() {
  size(displayWidth, displayHeight, P2D);
  smooth();
  frameRate(30);
  colorMode(HSB);
  rectMode(CENTER);
 
  pts = new ArrayList<Particle>();
 
  showInstruction = true;
  instructionsFont = createFont("Helvetica", 18, true);
 
  background(255);
}

//drawing
void draw() {
  if (showInstruction) {
    background(255);
    fill(128);
    textAlign(CENTER, CENTER);
    textFont(instructionsFont);
    textLeading(36);
    text("drag and draw" + "\n" +
      "Press 'c' to clear the canvas." + "\n"
      , width/2, height/2);
  }
 
  if (onPressed) {
    for (int i=0;i<10;i++) {
      Particle newP = new Particle(mouseX, mouseY, i+pts.size(), i+pts.size());
      pts.add(newP);
    }
  }
 
  for (int i=0; i<pts.size(); i++) {
    Particle p = pts.get(i);
    p.update();
    p.display();
  }
 
  for (int i=pts.size()-1; i>-1; i--) {
    Particle p = pts.get(i);
    if (p.dead) {
      pts.remove(i);
    }
  }
}

 //hide instructions if mouse pressed
void mousePressed() {
  onPressed = true;
  if (showInstruction) {
    background(255);
    showInstruction = false;
  }
}
 
 //when the mouse is released change mousePressed to false
void mouseReleased() {
  onPressed = false;
}
 
//when the 'c' key is pressed clear the screen
void keyPressed() {
  if (key == 'c') {
    for (int i=pts.size()-1; i>-1; i--) {
      Particle p = pts.get(i);
      pts.remove(i);
    }
    background(255);
  }
}
 
//Particle object
class Particle{
  PVector loc, vel, acc;
  int lifeSpan, timeLiving;
  boolean dead;
  float alpha, weight, weightRange, decay, xOffset, yOffset;
  color c;
   
  Particle(float x, float y, float xOffset, float yOffset){
    //** Adjust these variables **
    lifeSpan = int(random(30, 90)); //how much time the particle lives
    weightRange = random(3, 50); //how big can each circle be
    color cmix = color(250, 250, 250); //color definition
    c = generateRandomColor(cmix); //generates pseudo-random colors within a same palette based on the value of cmix
    
    loc = new PVector(x,y);     
    float randomDegrees = random(360);
    vel = new PVector(cos(radians(randomDegrees)), sin(radians(randomDegrees))); 
    vel.mult(random(5));
    
    acc = new PVector(0,0);
    decay = random(0.75, 0.9);    
 
    this.xOffset = xOffset;
    this.yOffset = yOffset;
  }
   
  void update(){
    if(timeLiving>=lifeSpan){
      dead = true;
    }else{
      timeLiving++;
    }
     
    alpha = float(lifeSpan-timeLiving)/lifeSpan * 70+50;
    weight = float(lifeSpan-timeLiving)/lifeSpan * weightRange;
     
    acc.set(0,0);    
    float rn = (noise((loc.x+frameCount+xOffset)/100, (loc.y+frameCount+yOffset)/100)-0.5)*4*PI;
    float magnitude = noise((loc.y+frameCount)*0.01, (loc.x+frameCount)*0.01);
    PVector direction = new PVector(cos(rn),sin(rn));
    acc.mult(magnitude);
    acc.add(direction);

    float randomDegrees = random(360);
    PVector randomVector = new PVector(cos(radians(randomDegrees)), sin(radians(randomDegrees)));
    randomVector.mult(0.5);
    acc.add(randomVector);    
    vel.add(acc);
    vel.mult(decay);
    vel.limit(3);
    loc.add(vel);
  }
   
  void display(){
    strokeWeight(weight+1.5);
    point(loc.x, loc.y);
    stroke(c);
    point(loc.x, loc.y);
  }
}
 
// returns a random color 
color generateRandomColor(color mix) {
    int red = int(random(100,250));
    int green = int(random(100,250));
    int blue = int(random(100,250));

    // mixing the color
    red = int((red + red(mix)) / 2);
    green = int((green + green(mix)) / 2);
    blue = int((blue + blue(mix)) / 2);
 
    color c= color(red, green, blue);
    return c;
}
