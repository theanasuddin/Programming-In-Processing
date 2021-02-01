// Clock
// Anas Uddin
// https://github.com/theanasuddin

import processing.sound.*;
import java.util.Calendar;

PImage background;
PImage icon;
PImage audio;
PImage noAudio;

float halfWidth;
float halfHeight;
float clockCenterY;

float clockDiameter = 250;
float centerCircleDiameter = 20;
int strokeWeightFive = 5;
int strokeWeightThree = 3;
int strokeWeightTwo = 2;
int strokeWeightOne = 1;
float strokeWeightHalf = 0.5;

float minuteTheta = 0;
float minuteDelta = radians(6);
float hourTheta = 0;
float hourDelta = radians(30);
float distLineX1;
float distLineY1;
float distLineX2;
float distLineY2;
float lineX1;
float lineY1;
float lineX2;
float lineY2;

color clockBodyColor = color(233, 234, 239);
color clockInnerStroke = color(88, 89, 95);
color clockStroke = color(51, 52, 52);
color minuteLineColor = color(186, 189, 187);
color centerCircle = color(136, 139, 135);
color pinColor = color(189, 193, 191);

color digitalClockRectBorder = color(160, 160, 160);
color digitalClockRectFill = color(31, 31, 31);

int currentHour;
float hourHandLength = 82;
float hourHandDelta = 360.0 / 43200.0;

int currentMinute;
float minuteHandLength = 116;
float minuteHandDelta = 0.1;

int currentSecond;
float secondHandLength = 98;
float secondHandDelta = 6;

float distHandX;
float distHandY;

SoundFile tickSound;
SoundFile audioToggle;

PFont Finance;

Calendar calendar;

boolean audioState = true;
boolean audioButtonHover;

void setup() {
  size(1920, 1080);
  frameRate(60);
  background = loadImage("bg.jpg");
  tickSound = new SoundFile(this, "tick.wav");
  audioToggle = new SoundFile(this, "sound_on.mp3");
  Finance = createFont("Finance.ttf", 32);
  calendar = Calendar.getInstance();
  surface.setTitle("Clock");
  icon = loadImage("icon.png");
  surface.setIcon(icon);
  audio = loadImage("audio.png");
  noAudio = loadImage("no_audio.png");

  halfWidth = width / 2;
  halfHeight = height / 2;
  clockCenterY = halfHeight - 220;
}

void draw() {
  image(background, 0, 0);
  currentSecond = second();
  currentMinute = minute();
  currentHour = getHour();

  drawClockBody();

  setStroke(strokeWeightOne, minuteLineColor);
  drawLines(112, 120, 60, minuteTheta, minuteDelta);

  setStroke(1.5, clockStroke);
  drawLines(74, 106, 12, hourTheta, hourDelta);

  setStroke(strokeWeightHalf, clockInnerStroke);
  drawCircle(halfWidth, clockCenterY, centerCircleDiameter, centerCircle);

  // branding
  textAlign(CENTER, CENTER);
  drawText(Finance, 7, clockStroke, "KARLSSON", halfWidth, clockCenterY + 37);

  // hour hand
  setStroke(4.5, clockStroke);
  drawHand((currentHour * 3600) + (minute() * 60) + currentSecond, hourHandDelta, hourHandLength);

  // minute hand
  setStroke(3.75, clockStroke);
  drawHand((minute() * 60) + currentSecond, minuteHandDelta, minuteHandLength);

  // second hand
  setStroke(strokeWeightOne, clockStroke);
  drawHand(currentSecond, secondHandDelta, secondHandLength);

  // pin
  setStroke(strokeWeightHalf, clockInnerStroke);
  drawCircle(halfWidth, clockCenterY, (centerCircleDiameter / 4) * 3, pinColor);

  // digital clock
  setStroke(strokeWeightHalf, digitalClockRectBorder);
  fill(digitalClockRectFill);
  rect(1452, 49, 518, 159);
  
  // check cursor position
  checkCursor();

  // audio button
  drawAudioButton(audioState);

  // play tick
  if (frameCount % 60 == 30) {
    playTick();
  }

  textAlign(LEFT, TOP);
  drawText(Finance, 80, color(255), nf(getHour(), 2) + ":" + nf(currentMinute, 2) + ":" + nf(currentSecond, 2), 1482, 74);
  drawText(Finance, 40, color(160, 160, 160), getPeriods(), 1747, 105);
  drawText(Finance, 30, color(152, 197, 232), getDayName(calendar.get(Calendar.DAY_OF_WEEK)) + ", " + getMonthName(month()) + " " + day() + ", " + year(), 1482, 159);
}

void drawClockBody() {
  // background
  noStroke();
  drawCircle(halfWidth, clockCenterY, clockDiameter, clockBodyColor);

  // inner stroke
  setStroke(strokeWeightTwo, clockInnerStroke);
  drawCircle(halfWidth, clockCenterY, clockDiameter + 2);

  // stroke
  setStroke(strokeWeightFive, clockStroke);
  drawCircle(halfWidth, clockCenterY, clockDiameter + 8);

  // outer stroke
  setStroke(strokeWeightTwo, clockInnerStroke);
  drawCircle(halfWidth, clockCenterY, clockDiameter + 14);
}

void drawLines(float initialPos, float finalPos, int lineCount, float theta, float delta) {

  for (int count = 0; count < lineCount; count++) {
    distLineX1 = initialPos * cos(theta);
    distLineY1 = initialPos * sin(theta);
    lineX1 = halfWidth + distLineX1;
    lineY1 = clockCenterY + distLineY1;

    distLineX2 = finalPos * cos(theta);
    distLineY2 = finalPos * sin(theta);
    lineX2 = halfWidth + distLineX2;
    lineY2 = clockCenterY + distLineY2;

    line(lineX1, lineY1, lineX2, lineY2);
    theta += delta;
  }
}

void setStroke(float weight, color c) {
  strokeCap(PROJECT);
  stroke(c);
  strokeWeight(weight);
}

void drawCircle(float posX, float posY, float diameter, color fillColor) {
  fill(fillColor);
  ellipse(posX, posY, diameter, diameter);
}

void drawCircle(float posX, float posY, float diameter) {
  noFill();
  ellipse(posX, posY, diameter, diameter);
}

void drawHand(int currentTime, float delta, float handLength) {
  float theta = (PI + HALF_PI) + radians(delta * currentTime);

  distHandX = handLength * cos(theta);
  distHandY = handLength * sin(theta);
  line(halfWidth, clockCenterY, halfWidth + distHandX, clockCenterY + distHandY);
}

void playTick() {
  if (audioState) {
    tickSound.play();
  } else if (!audioState) {
    tickSound.stop();
  }
}

void drawText(PFont fontName, int textSize, color textFill, String text, float posX, float posY) {
  fill(textFill);
  textFont(fontName, textSize);
  text(text, posX, posY);
}

String getMonthName(int month) {
  String[] monthNames = { "January", "February", "March", "April", "May", "June", "July", 
    "August", "September", "October", "November", "December" };

  return monthNames[month - 1];
}

String getDayName(int day) {
  String[] dayNames = { "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" };

  return dayNames[day - 1];
}

String getPeriods() {
  if (hour() >= 0 && hour() < 12) {
    return "AM";
  } else {
    return "PM";
  }
}

int getHour() {
  if (hour() % 12 == 0) {
    return 12;
  } else {
    return hour() % 12;
  }
}

void drawAudioButton(boolean audioState) {
  setStroke(strokeWeightHalf, digitalClockRectBorder);
  noFill();
  rect(1870, 49, 60, 50);
  if (audioState) {
    image(audio, 1880, 59, 30, 30);
  } else if (!audioState) {
    image(noAudio, 1880, 59, 30, 30);
  }
}

void checkCursor() {
  if (mouseX >= 1880 && mouseX <= 1910 && mouseY >= 59 && mouseY <= 89) {
    audioButtonHover = true;
    cursor(HAND);
  } else {
    audioButtonHover = false;
    cursor(ARROW);
  }
}

void toggleAudio() {
  if (audioState) {
    audioState = false;
  } else if (!audioState) {
    audioToggle.play();
    audioState = true;
  }
}

void mousePressed() {
  if (audioButtonHover) {
    toggleAudio();
  }
}
