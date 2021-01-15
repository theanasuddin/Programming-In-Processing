// Lightbulb Simulation
// Anas Uddin
// https://github.com/theanasuddin

import processing.sound.*;

color background = color(24, 23, 21);
color stripColor = color(218, 222, 223);
color stripBorder = color(93, 93, 93);
color masterplugCutoutBorder = color(201, 203, 200);
color masterplugTextBorder = color(192, 193, 188);
color masterplugRectColor = color(210, 210, 208);
color cutLineColor = color(84, 81, 76);
color verticalLinesColor = color(173, 168, 157);
color socketsInnerBorderColor = color(86, 85, 90);
color socketsHoleColor = color(76, 54, 57);
color socketsRectColor = color(132, 141, 148);
color fuseRectColor = color(115, 39, 41);
color fuseTextColor = color(77, 9, 8);
color chargerBodyStrokeOut = color(193, 201, 203);
color chargerBodyColor = color(220, 224, 223);
color chargerBodyStrokeIn = color(73, 69, 66);
color samsungTextColor = color(136, 142, 142);
color verticalSocketsHoleColor = color(12, 14, 18);
color usbMetalColor = color(162, 155, 127);
color usbLogoColor = color(171, 172, 166);
color switchOuterRectStroke = color(15, 0, 3);
color switchRectFill = color(91, 36, 39);
color indicatorOffFill = color(23, 3, 2);
color indicatorOnFill = color(255, 6, 16);

float halfWidth;
float halfHeight;
float powerStripBodyPosX;
float powerStripBodyPosY;

int strokeWeightTwo = 2;
int strokeWeightThree = 3;
int strokeWeightOne = 1;
int strokeWeightFive = 5;

PFont ArialRegular;
PFont ITCAvantGardeDemiBold;

PShape usbLogo;
PShape switchOff;
PShape switchOn;
PShape bulbOff;
PShape bulbOn;
PShape pin;

PImage icon;

boolean switchState = false;
boolean indicatorState = false;
boolean bulbState = false;

boolean mouseOverSwitchTop = false;
boolean mouseOverSwitchBottom = false;

SoundFile clickSound;

void setup() {
  size(1920, 1080);
  background(background);
  
  surface.setTitle("Lightbulb Simulation");
  icon = loadImage("icon.png");
  clickSound = new SoundFile(this, "click.mp3");
  surface.setIcon(icon);
  
  halfWidth = width / 2;
  halfHeight = height / 2;
  powerStripBodyPosX = halfWidth;
  powerStripBodyPosY = halfHeight + 360;

  // drawing power strip
  // body
  rectMode(CENTER);
  stroke(stripBorder);
  strokeWeight(strokeWeightTwo);
  fill(stripColor);
  rect(powerStripBodyPosX, powerStripBodyPosY, 1265, 265, 30);

  // strip cable
  noFill();
  stroke(stripColor);
  strokeWeight(22);
  bezier(1592.3195, 899.47595, 1809.0195, 900.47595, 1719.9332, 1022.30505, 1920.7284, 1022.30505);

  stroke(verticalLinesColor);
  strokeWeight(6);
  bezier(1592.3195, 899.47595, 1809.0195, 900.47595, 1719.9332, 1022.30505, 1920.7284, 1022.30505);

  // masterplug text
  rectMode(CORNERS);
  fill(stripColor);
  stroke(masterplugCutoutBorder);
  strokeWeight(strokeWeightTwo);
  rect(halfWidth + 508, halfHeight + 327.5, halfWidth + 640.5, halfHeight + 392.5, 100, 8, 8, 100);

  stroke(masterplugTextBorder);
  fill(masterplugRectColor);
  rect(halfWidth + 522.5, halfHeight + 348.5, halfWidth + 632.5, halfHeight + 371.5);

  ArialRegular = createFont("arial.ttf", 32);
  textFont(ArialRegular, 14);
  textAlign(CENTER, CENTER);
  fill(masterplugTextBorder);
  text("MASTERPLUG", halfWidth + 577.5, halfHeight + 359);

  // cut line
  stroke(cutLineColor);
  strokeWeight(strokeWeightTwo);
  line(halfWidth + 481.5, halfHeight + 228.5, halfWidth + 481.5, halfHeight + 491.5);

  // vertical lines on strip
  stroke(verticalLinesColor);
  strokeWeight(strokeWeightFive);
  strokeCap(PROJECT);
  float lastVerticalLinePosX = halfWidth + 485;
  for (int counter = 0; counter < 6; counter++) {
    line(lastVerticalLinePosX, halfHeight + 237.5, lastVerticalLinePosX, halfHeight + 482.5);
    lastVerticalLinePosX = lastVerticalLinePosX - 208;
  }

  // fuse
  rectMode(CENTER);
  strokeWeight(strokeWeightTwo);
  stroke(cutLineColor);
  fill(verticalLinesColor);
  rect(halfWidth + 330, powerStripBodyPosY, 37, 143);
  strokeWeight(strokeWeightOne);
  fill(fuseRectColor);
  rect(halfWidth + 330, powerStripBodyPosY, 60, 120);

  // fuse text
  float fuseTextX = halfWidth + 330;
  float fuseTextY = halfHeight + 358;
  String fuse = "F\nU\nS\nE";

  textAlign(CENTER, CENTER);
  fill(fuseTextColor);
  textSize(22); 
  textLeading(26);
  text(fuse, fuseTextX, fuseTextY);

  // smasung charger
  strokeWeight(strokeWeightOne);
  stroke(chargerBodyStrokeOut);
  fill(chargerBodyColor);
  rect(halfWidth - 451, halfHeight + 420, 185, 105, 25);

  strokeWeight(strokeWeightTwo);
  stroke(chargerBodyStrokeIn);
  noFill();
  rect(halfWidth - 451, halfHeight + 420, 178, 98, 25);

  ITCAvantGardeDemiBold = createFont("ITCAvantGardeDemiBold.ttf", 32);
  textFont(ITCAvantGardeDemiBold, 18);
  textAlign(CENTER, CENTER);
  fill(samsungTextColor);
  text("SAMSUNG", halfWidth - 451, halfHeight + 420);

  // sockets horizontal
  stroke(socketsInnerBorderColor);
  strokeWeight(strokeWeightOne);
  rectMode(CENTER);
  float lastSocketHolePosX = halfWidth + 233;
  float lastSocketHolePosY = halfHeight + 420.5;
  int lastSocketHoleWidth = 26;
  int lastSocketHoleHeight = 18;
  drawSocketHoles(lastSocketHolePosX, lastSocketHolePosY, lastSocketHoleWidth, lastSocketHoleHeight);

  float secondLastSocketHolePosX = halfWidth + 113;
  float secondLastSocketHolePosY = lastSocketHolePosY;
  int secondLastSocketHoleWidth = lastSocketHoleWidth;
  int secondLastSocketHoleHeight = lastSocketHoleHeight;
  drawSocketHoles(secondLastSocketHolePosX, secondLastSocketHolePosY, secondLastSocketHoleWidth, secondLastSocketHoleHeight);

  // sockets vertical
  float lastVerticalSocketHolePosX = halfWidth + 173;
  float lastVerticalSocketHolePosY = halfHeight + 340.5;
  int verticalSocketHoleWidth = 18;
  int verticalSocketHoleHeight = 32;
  drawSocketHoles(lastVerticalSocketHolePosX, lastVerticalSocketHolePosY, verticalSocketHoleWidth, verticalSocketHoleHeight);

  float lastVerticalSocketHolePinPosX = halfWidth + 173;
  float lastVerticalSocketHolePinPosY = halfHeight + 347;
  int verticalSocketHolePinWidth = 9;
  int verticalSocketHolePinHeight = 18;
  for (int counter = 0; counter < 3; counter++) {
    fill(verticalSocketsHoleColor);
    rect(lastVerticalSocketHolePosX, lastVerticalSocketHolePosY, verticalSocketHoleWidth, verticalSocketHoleHeight);
    fill(socketsHoleColor);
    rect(lastVerticalSocketHolePinPosX, lastVerticalSocketHolePinPosY, verticalSocketHolePinWidth, verticalSocketHolePinHeight);
    lastVerticalSocketHolePosX = lastVerticalSocketHolePosX - 208;
    lastVerticalSocketHolePinPosX = lastVerticalSocketHolePosX;
  }

  // usb cable
  strokeWeight(strokeWeightOne);
  fill(usbMetalColor);
  stroke(cutLineColor);
  rect(halfWidth - 451, halfHeight + 365, 45, 3.5);

  fill(chargerBodyColor);
  stroke(chargerBodyStrokeOut);
  rect(halfWidth - 451, halfHeight + 331, 60, 64);

  usbLogo = loadShape("usb.svg");
  shapeMode(CENTER);
  PShape usbLogoChild;
  usbLogoChild = usbLogo.getChild("Layer 1");
  usbLogoChild.disableStyle();
  fill(usbLogoColor);
  shape(usbLogo, halfWidth - 451, halfHeight + 331, 32, 32);

  // switch
  stroke(switchOuterRectStroke);
  fill(switchRectFill);
  strokeWeight(strokeWeightTwo);
  rect(halfWidth + 432, powerStripBodyPosY, 56, 117);
  drawSwitchOff();

  // on off text
  textFont(ArialRegular, 14);
  textAlign(CENTER, BOTTOM);
  fill(masterplugTextBorder);
  text("ON", halfWidth + 432, powerStripBodyPosY - 71.5);
  textAlign(CENTER, TOP);
  text("OFF", halfWidth + 432, powerStripBodyPosY + 71.5);

  // indicator light
  drawIndicatorOff();

  // usb c
  drawUSBC(halfWidth, 175, 22.069, 80);

  // bulb
  drawBulbOff();

  // wire
  drawUSBWire();

  // pins
  drawPin("pin_middle.svg", halfWidth, 31.025);
  drawPin("pin_left.svg", 150, 44.772);
}

void draw() {
  mouseOverSwitch();
}

void drawSocketHoles(float posX, float posY, int width, int height) {
  for (int counter = 0; counter < 3; counter++) {
    fill(socketsRectColor);
    rect(posX, posY, width + 3, height + 3);
    fill(socketsHoleColor);
    rect(posX, posY, width, height);
    posX = posX - 208;
  }
}

void drawSwitchOff() {
  switchOff = loadShape("switch_off.svg");

  shapeMode(CENTER);
  noStroke();

  PShape switchOffStroke = switchOff.getChild("stroke");
  PShape switchOffFill = switchOff.getChild("fill");
  PShape switchOffZero = switchOff.getChild("zero");
  PShape switchOffOne = switchOff.getChild("one");
  PShape switchOffShadeTop = switchOff.getChild("shadeTop");
  PShape switchOffShadeBottom = switchOff.getChild("shadeBottom");

  switchOffStroke.disableStyle();
  switchOffFill.disableStyle();
  switchOffZero.disableStyle();
  switchOffOne.disableStyle();
  switchOffShadeTop.disableStyle();
  switchOffShadeBottom.disableStyle();

  fill(switchOuterRectStroke);
  shape(switchOffStroke, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(100, 20, 23);
  shape(switchOffFill, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(stripColor, 145);
  shape(switchOffZero, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(stripColor, 145);
  shape(switchOffOne, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(121, 99, 110);
  shape(switchOffShadeTop, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(0, 0, 0, 46);
  shape(switchOffShadeBottom, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
}

void drawSwitchOn() {
  switchOn = loadShape("switch_on.svg");

  shapeMode(CENTER);
  noStroke();

  PShape switchOnStroke = switchOn.getChild("stroke");
  PShape switchOnFill = switchOn.getChild("fill");
  PShape switchOnZero = switchOn.getChild("zero");
  PShape switchOnOne = switchOn.getChild("one");
  PShape switchOnShadeTop = switchOn.getChild("shadeTop");
  PShape switchOnShadeBottom = switchOn.getChild("shadeBottom");
  PShape switchOnShadeTopSmall = switchOn.getChild("shadeTopSmall");

  switchOnStroke.disableStyle();
  switchOnFill.disableStyle();
  switchOnZero.disableStyle();
  switchOnOne.disableStyle();
  switchOnShadeTop.disableStyle();
  switchOnShadeBottom.disableStyle();
  switchOnShadeTopSmall.disableStyle();

  fill(switchOuterRectStroke);
  shape(switchOnStroke, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(100, 20, 23);
  shape(switchOnFill, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(121, 99, 110);
  shape(switchOnShadeTopSmall, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(121, 99, 110);
  shape(switchOnShadeTop, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(stripColor, 145);
  shape(switchOnOne, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(stripColor, 145);
  shape(switchOnZero, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
  fill(0, 0, 0, 46);
  shape(switchOnShadeBottom, halfWidth + 432, powerStripBodyPosY, 31.436, 80);
}

void toggleSwitch() {
  clickSound.play();

  if (switchState) {
    drawSwitchOff();
    switchState = !switchState;
  } else {
    drawSwitchOn();
    switchState = !switchState;
  }
}

void drawIndicatorOff() {
  drawIndicatorGrill();

  rectMode(CENTER);
  stroke(cutLineColor);
  strokeWeight(strokeWeightTwo);
  fill(indicatorOffFill, 191);
  rect(powerStripBodyPosX - 614, powerStripBodyPosY, 37, 113, 3, 10, 10, 3);
}

void drawIndicatorOn() {
  drawIndicatorGrill();

  rectMode(CENTER);
  stroke(cutLineColor);
  strokeWeight(strokeWeightTwo);
  fill(indicatorOnFill, 191);
  rect(powerStripBodyPosX - 614, powerStripBodyPosY, 37, 113, 3, 10, 10, 3);
}

void drawIndicatorGrill() {
  stroke(cutLineColor, 65);
  strokeWeight(strokeWeightOne);

  float lineDistanceHorizontal = 37 / 5;
  float initialLineX = (powerStripBodyPosX - 632.5) + lineDistanceHorizontal;
  float lineY1 = powerStripBodyPosY - 56.5;
  float lineY2 = powerStripBodyPosY + 56.5;
  for (int lineCounter = 0; lineCounter < 4; lineCounter++) {
    line(initialLineX, lineY1, initialLineX, lineY2);
    initialLineX = initialLineX + lineDistanceHorizontal;
  }

  float lineDistanceVertical = 113 / 15.27;
  float initialLineY = (powerStripBodyPosY - 56.5) + lineDistanceVertical;
  float lineX1 = powerStripBodyPosX - 632.5;
  float lineX2 = powerStripBodyPosX - 595.5;
  for (int lineCounter = 0; lineCounter < 14; lineCounter++) {
    line(lineX1, initialLineY, lineX2, initialLineY);
    initialLineY = initialLineY + lineDistanceVertical;
  }

  rectMode(CENTER);
  noStroke();
  noFill();
  rect(powerStripBodyPosX - 614, powerStripBodyPosY, 37, 113, 3, 10, 10, 3);
}

void cleanIndicatorArea() {
  rectMode(CENTER);
  noStroke();
  fill(stripColor);
  rect(powerStripBodyPosX - 606.5, powerStripBodyPosY, 49, 125);
}

void toggleIndicator() {
  cleanIndicatorArea();

  if (indicatorState) {
    drawIndicatorOff();
    indicatorState = !indicatorState;
  } else {
    drawIndicatorOn();
    indicatorState = !indicatorState;
  }
}

void mousePressed() {
  if (mouseOverSwitchTop) {
    if (!switchState) {
      toggleSwitch();
      toggleIndicator();
      toggleBulb();
    }
  }

  if (mouseOverSwitchBottom) {
    if (switchState) {
      toggleSwitch();
      toggleIndicator();
      toggleBulb();
    }
  }
}

void mouseOverSwitch() {
  if (mouseX >= halfWidth + 416.282 && mouseX <= halfWidth + 447.718 && mouseY >= powerStripBodyPosY - 40 && mouseY <= powerStripBodyPosY - 5) {
    cursor(HAND);
    mouseOverSwitchTop = true;
  } else if (mouseX >= halfWidth + 416.282 && mouseX <= halfWidth + 447.718 && mouseY >= powerStripBodyPosY + 5 && mouseY <= powerStripBodyPosY + 40) {
    cursor(HAND);
    mouseOverSwitchBottom = true;
  } else {
    cursor(ARROW);
    mouseOverSwitchTop = false;
    mouseOverSwitchBottom = false;
  }
}

void drawBulbOff() {
  bulbOff = loadShape("bulb_off.svg");

  shapeMode(CENTER);
  noStroke();

  PShape bulbOffFilament = bulbOff.getChild("filament");
  PShape bulbOffGlassBulb = bulbOff.getChild("glassBulb");
  PShape bulbOffReflection = bulbOff.getChild("reflection");
  PShape bulbOffCap = bulbOff.getChild("cap");
  PShape bulbOffCapReflectionRight = bulbOff.getChild("capReflectionRight");
  PShape bulbOffCapReflectionLeft = bulbOff.getChild("capReflectionLeft");

  bulbOffFilament.disableStyle();
  bulbOffGlassBulb.disableStyle();
  bulbOffReflection.disableStyle();
  bulbOffCap.disableStyle();
  bulbOffCapReflectionRight.disableStyle();
  bulbOffCapReflectionLeft.disableStyle();

  fill(255);
  shape(bulbOffFilament, halfWidth, 400, 224.059, 400);
  fill(255);
  shape(bulbOffGlassBulb, halfWidth, 400, 224.059, 400);
  fill(255);
  shape(bulbOffReflection, halfWidth, 400, 224.059, 400);
  fill(51, 51, 51);
  shape(bulbOffCap, halfWidth, 400, 224.059, 400);
  fill(0);
  shape(bulbOffCapReflectionRight, halfWidth, 400, 224.059, 400);
  fill(255);
  shape(bulbOffCapReflectionLeft, halfWidth, 400, 224.059, 400);
}

void drawBulbOn() {
  bulbOn = loadShape("bulb_on.svg");

  shapeMode(CENTER);
  noStroke();

  PShape bulbOnFilament = bulbOn.getChild("filament");
  PShape bulbOnGlassBulb = bulbOn.getChild("glassBulb");
  PShape bulbOnReflection = bulbOn.getChild("reflection");
  PShape bulbOnCap = bulbOn.getChild("cap");
  PShape bulbOnCapReflectionRight = bulbOn.getChild("capReflectionRight");
  PShape bulbOnCapReflectionLeft = bulbOn.getChild("capReflectionLeft");

  bulbOnFilament.disableStyle();
  bulbOnGlassBulb.disableStyle();
  bulbOnReflection.disableStyle();
  bulbOnCap.disableStyle();
  bulbOnCapReflectionRight.disableStyle();
  bulbOnCapReflectionLeft.disableStyle();

  fill(255);
  shape(bulbOnFilament, halfWidth, 400, 224.059, 400);
  fill(255);
  shape(bulbOnGlassBulb, halfWidth, 400, 224.059, 400);
  fill(255);
  shape(bulbOnReflection, halfWidth, 400, 224.059, 400);
  fill(51, 51, 51);
  shape(bulbOnCap, halfWidth, 400, 224.059, 400);
  fill(0);
  shape(bulbOnCapReflectionRight, halfWidth, 400, 224.059, 400);
  fill(255);
  shape(bulbOnCapReflectionLeft, halfWidth, 400, 224.059, 400);
  fill(255, 255, 255, 25);
  circle(halfWidth, 478.5, 451.833);
}

void cleanBulbArea() {
  noStroke();
  fill(background);
  rect(halfWidth, 456.5, 456.833, 510);
}

void toggleBulb() {
  cleanBulbArea();

  if (bulbState) {
    drawBulbOff();
    bulbState = !bulbState;
  } else {
    drawBulbOn();
    bulbState = !bulbState;
  }
}

void drawPin(String name, float pinX, float pinWidth) {
  pin = loadShape(name);

  shapeMode(CENTER);
  noStroke();

  PShape mainLayer = pin.getChild("Layer 1");
  mainLayer.disableStyle();

  fill(255);
  shape(mainLayer, pinX, 70, pinWidth, 70);
}

void drawUSBC(float posX, float posY, float usbWidth, float usbHeight) {
  PShape usb = loadShape("usb_c.svg");

  shapeMode(CENTER);
  noStroke();

  PShape usbTop = usb.getChild("usbTop");
  PShape usbBottom = usb.getChild("usbBottom");
  PShape usbMiddle = usb.getChild("usbMiddle");

  usbTop.disableStyle();
  usbBottom.disableStyle();
  usbMiddle.disableStyle();

  fill(212, 222, 237);
  shape(usbTop, posX, posY, usbWidth, usbHeight);
  fill(196, 207, 227);
  shape(usbBottom, posX, posY, usbWidth, usbHeight);
  fill(225, 234, 246);
  shape(usbMiddle, posX, posY, usbWidth, usbHeight);
}

void drawUSBWire() {
  noFill();
  stroke(chargerBodyStrokeOut);
  strokeWeight(9.0);

  bezier(153.06036, 128.1321, 184.01764, 483.0255, 140.9642, 719.0565, 164.80034, 900.47595);
  bezier(153.56036, 126.81114, 132.42517, -9.246643, 540.55145, 87.93749, 866.8259, 82);
  bezier(868.52423, 82.83946, 954.7462, 76.73515, 968.1616, 64.726524, 960.6907, 131.26434);
  bezier(509.3911, 823.61194, 509.1189, 581.71936, 454.13138, 1038.7065, 278.22498, 1021.0939);
  bezier(277.87115, 1021.28265, 206.53987, 1018.6407, 189.4336, 903.6804, 272.58734, 948.0643);
  bezier(272.58734, 948.0643, 370.33755, 1004.86487, 187.90417, 1109.4675, 164.39229, 902.8878);

  stroke(cutLineColor);
  strokeWeight(strokeWeightOne);

  bezier(153.06036, 128.1321, 184.01764, 483.0255, 140.9642, 719.0565, 164.80034, 901.47595);
  bezier(153.56036, 127.81114, 132.42517, -9.246643, 540.55145, 87.93749, 866.8259, 82);
  bezier(866.52423, 82.83946, 954.7462, 76.73515, 968.1616, 64.726524, 960.6907, 134.26434);
  bezier(509.3911, 823.61194, 509.1189, 581.71936, 454.13138, 1038.7065, 285.22498, 1021.0939);
  bezier(260.87115, 1018.28265, 206.53987, 1000.6407, 189.4336, 903.6804, 272.58734, 948.0643);
  bezier(272.58734, 948.0643, 370.33755, 1004.86487, 187.90417, 1109.4675, 164.39229, 902.8878);

  stroke(chargerBodyStrokeOut);
  strokeWeight(strokeWeightOne);
  fill(chargerBodyColor);
  rect(halfWidth - 451, halfHeight + 284, 18, 30, 4, 4, 0, 0);
}
