/*

 This example uses the extended version of FaceOSC to draw
 all of the face points tracked by FaceOSC and to display the
 original camera image via Syphon
 
 Download the extended version here:
 
 https://github.com/downloads/kylemcdonald/ofxFaceTracker/FaceOSC-osx+Syphon.zip
 
 Download the Syphon library for Processing here:
 
 http://code.google.com/p/syphon-implementations/downloads/list
 
 NOTE WELL: this example will not work with the standard FaceOSC app,
 which does not send the necessary OSC messages with all of the face points
 and does not publish the camera feed over Syphon.
 
 */

import oscP5.*;
//import codeanticode.syphon.*;

OscP5 oscP5;
//SyphonClient client;
PImage img;
PImage img2;

//PGraphics canvas;

boolean found;
PVector[] meshPoints;
PVector[] uvCoords;


//List of UV values
//3,47



// LISTS OF INDICES FOR EACH FACE PART
int[] faceOutline = { 
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
};
int[] leftEyebrow = {
  17, 18, 19, 20, 21
}; 
int[] rightEyebrow = {
  22, 23, 24, 25, 26
};
int[] nosePart1 = {
  27, 28, 29, 30
};
int[] nosePart2 = {
  31, 32, 33, 34, 35
};
int[] leftEye = {
  36, 37, 38, 39, 40, 41, 36
};
int[] rightEye = {
  42, 43, 44, 45, 46, 47, 42
};
int[] mouthPart1 = { 
  48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 48
};
int[] mouthPart2 = {
  60, 65
};
int[] mouthPart3 = {
  60, 61, 62, 63, 64, 65
};

int[][] connections = { 
  {
    20, 21, 23
  }
  , 
  {
    21, 22, 23
  }
  , 
  {
    0, 1, 36
  }
  , 
  {
    15, 16, 45
  }
  , 
  {
    0, 17, 36
  }
  , 
  {
    16, 26, 45
  }
  , 
  {
    17, 18, 37
  }
  , 
  {
    25, 26, 44
  }
  , 
  {
    17, 36, 37
  }
  , 
  {
    26, 44, 45
  }
  , 
  {
    18, 19, 38
  }
  , 
  {
    24, 25, 43
  }
  , 
  {
    18, 37, 38
  }
  , 
  {
    25, 43, 44
  }
  , 
  {
    19, 20, 38
  }
  , 
  {
    23, 24, 43
  }
  , 
  {
    20, 21, 39
  }
  , 
  {
    22, 23, 42
  }
  , 
  {
    20, 38, 39
  }
  , 
  {
    23, 42, 43
  }
  , 
  {
    21, 22, 27
  }
  , 
  {
    21, 27, 39
  }
  , 
  {
    22, 27, 42
  }
  , 
  {
    27, 28, 42
  }
  , 
  {
    27, 28, 39
  }
  , 
  {
    28, 42, 47
  }
  , 
  {
    28, 39, 40
  }
  , 
  {
    1, 36, 41
  }
  , 
  {
    15, 45, 46
  }
  , 
  {
    1, 2, 41
  }
  , 
  {
    14, 15, 46
  }
  , 
  {
    28, 29, 40
  }
  , 
  {
    28, 29, 47
  }
  , 
  {
    2, 40, 41
  }
  , 
  {
    14, 46, 47
  }
  , 
  {
    2, 29, 40
  }
  , 
  {
    14, 29, 47
  }
  , 
  {
    2, 3, 29
  }
  , 
  {
    13, 14, 29
  }
  , 
  {
    29, 30, 31
  }
  , 
  {
    29, 30, 35
  }
  , 
  {
    //stopped here
    3, 29, 31
  }
  , 
  {
    13, 29, 35
  }
  , 
  {
    30, 32, 33
  }
  , 
  {
    30, 33, 34
  }
  , 
  {
    30, 31, 32
  }
  , 
  {
    30, 34, 35
  }
  , 
  {
    3, 4, 31
  }
  , 
  {
    12, 13, 35
  }
  , 
  {
    4, 5, 48
  }
  , 
  {
    11, 12, 54
  }
  , 
  {
    5, 6, 48
  }
  , 
  {
    10, 11, 54
  }
  , 
  {
    6, 48, 59
  }
  , 
  {
    10, 54, 55
  }
  , 
  {
    6, 7, 59,
  }
  , 
  {
    9, 10, 55
  }
  , 
  {
    7, 58, 59
  }
  , 
  {
    9, 55, 56
  }
  , 
  {
    8, 57, 58
  }
  , 
  {
    8, 56, 57
  }
  , 
  {
    7, 8, 58,
  }
  , 
  {
    8, 9, 56,
  }
  , 
  {
    4, 31, 48
  }
  , 
  {
    12, 35, 54
  }
  , 
  {
    31, 48, 49
  }
  , 
  {
    35, 53, 54
  }
  , 
  {
    31, 49, 50
  }
  , 
  {
    35, 52, 53
  }
  , 
  {
    31, 32, 50
  }
  , 
  {
    34, 35, 52
  }
  , 
  {
    32, 33, 50
  }
  , 
  {
    33, 34, 52
  }
  , 
  {
    33, 50, 51
  }
  , 
  {
    33, 51, 52
  }
  , 
  {
    48, 49, 60
  }
  , 
  {
    49, 60, 50
  }
  , 
  {
    50, 60, 61
  }
  , 
  {
    50, 51, 61
  }
  , 
  {
    51, 52, 61
  }
  , 
  {
    61, 62, 52
  }
  , 
  {
    52, 53, 62
  }
  , 
  {
    53, 54, 62
  }
  , 
  {
    54, 55, 63
  }
  , 
  {
    55, 56, 63
  }
  , 
  {
    56, 63, 64
  }
  , 
  {
    56, 57, 64
  }
  , 
  {
    64, 65, 57
  }
  , 
  {
    57, 58, 65
  }
  , 
  {
    58, 59, 65
  }
  , 
  {
    48, 59, 65
  }
  , 
 //in eye balls

  {
  37, 36, 41
  } 
  , 
  {
  37, 38, 41
  } 
  , 
  {
  41, 40, 38
  } 
  , 
  {
   38, 39, 40
  }
  ,
  {
  42, 43, 47
  }
  ,
  {
  43, 44, 47
  }
  ,
  {
  44, 47, 46
  }
  ,
  {
 46, 44, 45
  }
  ,
  
};


// UNUSED VARIABLES FOR OTHER, LESS SPECIFIC FACE OSC DATA
/*
 float eyeLeftHeight;
 float eyeRightHeight;
 float mouthHeight;
 float mouthWidth;
 float nostrilHeight;
 float leftEyebrowHeight;
 float rightEyebrowHeight;
 */
//  PFont font;

 float poseScale;
PVector posePosition;


void setup() {
  size(640, 700, P3D); 
  frameRate(30);
  // img = loadImage("face_test1.png");
  //  img = loadImage("boy.jpg");
  img = loadImage("angryman.png");
  img2= loadImage("angryman.png");
  //textSize(20);


  // initialize meshPoints array with PVectors
  meshPoints = new PVector[66];
  for (int i = 0; i < meshPoints.length; i++) {
    meshPoints[i] = new PVector();
  }

  // initialize uvCoords to be an array of 66 PVectors
  uvCoords = new PVector[66];
  /*for (int i=0; i<uvCoords.length; i++) {
   uvCoords[i] = new PVector();
   }*/

  uvCoords[0] = new PVector(4, 42);
  uvCoords[1] = new PVector(4, 64);
  uvCoords[2] = new PVector(7, 84);  
  uvCoords[3] = new PVector(12, 102);  
  uvCoords[4] = new PVector(17, 122);  
  uvCoords[5] = new PVector(25, 142);
  uvCoords[6] = new PVector(40, 157);
  uvCoords[7] = new PVector(56, 169);  
  uvCoords[8] = new PVector(80, 172);
  uvCoords[9] = new PVector(101, 170);  
  uvCoords[10] = new PVector(120, 158);  
  uvCoords[11] = new PVector(137, 142);  
  uvCoords[12] = new PVector(145, 128);
  uvCoords[13] = new PVector(153, 108);
  uvCoords[14] = new PVector(156, 91);  
  uvCoords[15] = new PVector(155, 74);
  uvCoords[16] = new PVector(157, 46);  
  uvCoords[17] = new PVector(17, 18);  
  uvCoords[18] = new PVector(26, 8);  
  uvCoords[19] = new PVector(38, 8);
  uvCoords[20] = new PVector(51, 9);
  uvCoords[21] = new PVector(62, 13);  
  uvCoords[22] = new PVector(97, 13); 
  uvCoords[23] = new PVector(108, 9);
  uvCoords[24] = new PVector(120, 7);  
  uvCoords[25] = new PVector(133, 11);  
  uvCoords[26] = new PVector(141, 19);  
  uvCoords[27] = new PVector(77, 36);
  uvCoords[28] = new PVector(74, 55);
  uvCoords[29] = new PVector(73, 66);  
  uvCoords[30] = new PVector(72, 75);
  uvCoords[31] = new PVector(63, 89);  
  uvCoords[32] = new PVector(72, 89);  
  uvCoords[33] = new PVector(78, 89);  
  uvCoords[34] = new PVector(85, 89);
  uvCoords[35] = new PVector(89, 87);
  uvCoords[36] = new PVector(32, 39);  
  uvCoords[37] = new PVector(38, 31);
  uvCoords[38] = new PVector(49, 31);
  uvCoords[39] = new PVector(57, 41);
  uvCoords[40] = new PVector(50, 43);  
  uvCoords[41] = new PVector(40, 42);
  uvCoords[42] = new PVector(100, 39);  
  uvCoords[43] = new PVector(109, 30);  
  uvCoords[44] = new PVector(120, 32);  
  uvCoords[45] = new PVector(124, 39);
  uvCoords[46] = new PVector(119, 44);
  uvCoords[47] = new PVector(105, 45);  
  uvCoords[48] = new PVector(50, 122);
  uvCoords[49] = new PVector(61, 108);
  uvCoords[50] = new PVector(68, 103);
  uvCoords[51] = new PVector(78, 107);  
  uvCoords[52] = new PVector(85, 105);
  uvCoords[53] = new PVector(94, 109);  
  uvCoords[54] = new PVector(103, 123);  
  uvCoords[55] = new PVector(94, 132);  
  uvCoords[56] = new PVector(89, 134);
  uvCoords[57] = new PVector(78, 134);
  uvCoords[58] = new PVector(65, 131);  
  uvCoords[59] = new PVector(59, 128);
  uvCoords[60] = new PVector(69, 121);  
  uvCoords[61] = new PVector(78, 121);  
  uvCoords[62] = new PVector(89, 121);  
  uvCoords[63] = new PVector(89, 121);
  uvCoords[64] = new PVector(78, 121);
  uvCoords[65] = new PVector(69, 121);  


  // populate it with the right values
  // (based on something)

  oscP5 = new OscP5(this, 8338);
  // USE THESE 2 EVENTS TO DRAW THE 
  // FULL FACE MESH:
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "loadMesh", "/raw");
   oscP5.plug(this, "posePosition", "/pose/position");
   oscP5.plug(this, "poseScale", "/pose/scale");
  // THESE ARE ALSO AVAILABLE, BUT UNUSED
  /*oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
   oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
   oscP5.plug(this, "eyebrowLeftReceived", "/gesture/eyebrow/left");
   oscP5.plug(this, "eyebrowRightReceived", "/gesture/eyebrow/right");
   oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
   oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
   oscP5.plug(this, "jawReceived", "/gesture/jaw");
   oscP5.plug(this, "nostrilsReceived", "/gesture/nostrils");
   oscP5.plug(this, "poseOrientation", "/pose/orientation");
   oscP5.plug(this, "posePosition", "/pose/position");
   oscP5.plug(this, "poseScale", "/pose/scale");
   */

  // initialize the syphon client with the name of the server
  //  client = new SyphonClient(this, "FaceOSC");
  // prep the PGraphics object to receive the camera image
  //  canvas = createGraphics(640, 480, P3D);
}

void draw() {  

  stroke(255);
  background(0);
  // lights();
  // textureMode(IMAGE);


  //image(canvas, 0, 0, width, height);    
  //  if (client.available()) {
  //    canvas = client.getGraphics(canvas);
  //  }  
  //  
//  pushMatrix();
//  translate(0, 200);
//  beginShape(TRIANGLES);
//  texture(img);
//  vertex(10, 10, 0, 0);
//  vertex(10, 100, 0, img.height);
//  vertex(100, 100, map(mouseX, 0, width, 0, img.width), map(mouseY, 0, height, 0, img.height));
//
//  vertex(100, 100, map(mouseX, 0, width, 0, img.width), map(mouseY, 0, height, 0, img.height));
//  vertex(100, 10, img.width, 0);
//  vertex(10, 10, 0, 0);
//
//  endShape();
//  popMatrix();

  if (found) {
    fill(100);
    noFill();
          image(img, 0, 0);
// fill(255);
//    //rectMode(CENTER);
//    //rect(posePosition.x, posePosition.y, 200, 200);
//    image(img2, posePosition.x- (100* poseScale)/2, posePosition.y- (100* poseScale)/4, 100* poseScale, 100* poseScale);

  for (int i = 0; i < uvCoords.length; i++) {
    fill(255,0,0);
      ellipse(uvCoords[i].x, uvCoords[i].y, 5, 5);
      text(i, uvCoords[i].x, uvCoords[i].y);
    }
//
//    for (int i = 0; i < meshPoints.length; i++) {
//      text(i, meshPoints[i].x, meshPoints[i].y);
//      color(255, 0, 0);
//    }

    for (int i=0; i<connections.length; i++) {

      int[] currentConnection = connections[i];

      int index1 = currentConnection[0];
      int index2 = currentConnection[1];
      int index3 = currentConnection[2];

      //Tri(points[0], points[17], points[2], coords[0], coords[17], coords[2]);

      Tri t = new Tri(meshPoints[index1], meshPoints[index2], meshPoints[index3], uvCoords[index1], uvCoords[index2], uvCoords[index3]);

            println("MouseX=" + mouseX);
            println("MouseY=" +  mouseY);
      //      textureMode(IMAGE);

      noStroke();
      beginShape(TRIANGLES);
      texture(img);
      t.draw();
      
    //clear #s  
//    for (int g = 0; g < meshPoints.length; g++) {
//      text(g, meshPoints[g].x, meshPoints[g].y);
//      color(255, 0, 0);
//    }
      
      endShape();


      //triangle (connections[i].meshPoints[0].x, connections[i].meshPoints[0].y, connections[i].meshPoints[1].x, connections[i].meshPoints[1].y, connections[i].meshPoints[2].x, connections[i].meshPoints[2].y);
    }

   


    //    beginShape(LINES);
    //     vertex (meshPoints[16].x,meshPoints[16].y);
    //     vertex (meshPoints[26].x, meshPoints[26].y);
    //     vertex (meshPoints[0].x,meshPoints[0].y);
    //     vertex (meshPoints[17].x, meshPoints[17].y);
    //     endShape();


    //drawFeature(faceOutline);
    // drawFeature(leftEyebrow);
    // drawFeature(rightEyebrow);
    //    drawFeature(nosePart1);   
    //    drawFeature(nosePart2);           
    //    drawFeature(leftEye);     
    //    drawFeature(rightEye);    
    //    drawFeature(mouthPart1);  
    //    drawFeature(mouthPart2);  
    //    drawFeature(mouthPart3);
  }
}

//featurePointList is an array of indices (0-featurePointList.length)
void drawFeature(int[] featurePointList) {
  for (int i = 0; i < featurePointList.length; i++) {
    PVector meshVertex = meshPoints[featurePointList[i]];
    if (i > 0) {
      PVector prevMeshVertex = meshPoints[featurePointList[i-1]];
      line(meshVertex.x, meshVertex.y, prevMeshVertex.x, prevMeshVertex.y);
    }

    //ellipse(meshVertex.x, meshVertex.y, 3, 3);
    //text(i, meshPoints[i].x, meshPoints[i].y);
  }
}

public void found(int i) {
  // println("found: " + i); // 1 == found, 0 == not found
  found = i == 1;
}

// this method was generated programmatically. It's fugly.
public void loadMesh(float x0, float y0, float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4, float x5, float y5, float x6, float y6, float x7, float y7, float x8, float y8, float x9, float y9, float x10, float y10, float x11, float y11, float x12, float y12, float x13, float y13, float x14, float y14, float x15, float y15, float x16, float y16, float x17, float y17, float x18, float y18, float x19, float y19, float x20, float y20, float x21, float y21, float x22, float y22, float x23, float y23, float x24, float y24, float x25, float y25, float x26, float y26, float x27, float y27, float x28, float y28, float x29, float y29, float x30, float y30, float x31, float y31, float x32, float y32, float x33, float y33, float x34, float y34, float x35, float y35, float x36, float y36, float x37, float y37, float x38, float y38, float x39, float y39, float x40, float y40, float x41, float y41, float x42, float y42, float x43, float y43, float x44, float y44, float x45, float y45, float x46, float y46, float x47, float y47, float x48, float y48, float x49, float y49, float x50, float y50, float x51, float y51, float x52, float y52, float x53, float y53, float x54, float y54, float x55, float y55, float x56, float y56, float x57, float y57, float x58, float y58, float x59, float y59, float x60, float y60, float x61, float y61, float x62, float y62, float x63, float y63, float x64, float y64, float x65, float y65) {
  //println("loading mesh...");  

  meshPoints[0].x = x0; 
  meshPoints[0].y = y0; 
  meshPoints[1].x = x1; 
  meshPoints[1].y = y1;
  meshPoints[2].x = x2; 
  meshPoints[2].y = y2;
  meshPoints[3].x = x3; 
  meshPoints[3].y = y3;
  meshPoints[4].x = x4; 
  meshPoints[4].y = y4;
  meshPoints[5].x = x5; 
  meshPoints[5].y = y5;
  meshPoints[6].x = x6; 
  meshPoints[6].y = y6;
  meshPoints[7].x = x7; 
  meshPoints[7].y = y7;
  meshPoints[8].x = x8; 
  meshPoints[8].y = y8;
  meshPoints[9].x = x9; 
  meshPoints[9].y = y9;
  meshPoints[10].x = x10; 
  meshPoints[10].y = y10;
  meshPoints[11].x = x11; 
  meshPoints[11].y = y11;
  meshPoints[12].x = x12; 
  meshPoints[12].y = y12;
  meshPoints[13].x = x13; 
  meshPoints[13].y = y13;
  meshPoints[14].x = x14; 
  meshPoints[14].y = y14;
  meshPoints[15].x = x15; 
  meshPoints[15].y = y15;
  meshPoints[16].x = x16; 
  meshPoints[16].y = y16;
  meshPoints[17].x = x17; 
  meshPoints[17].y = y17;
  meshPoints[18].x = x18; 
  meshPoints[18].y = y18;
  meshPoints[19].x = x19; 
  meshPoints[19].y = y19;
  meshPoints[20].x = x20; 
  meshPoints[20].y = y20;
  meshPoints[21].x = x21; 
  meshPoints[21].y = y21;
  meshPoints[22].x = x22; 
  meshPoints[22].y = y22;
  meshPoints[23].x = x23; 
  meshPoints[23].y = y23;
  meshPoints[24].x = x24; 
  meshPoints[24].y = y24;
  meshPoints[25].x = x25; 
  meshPoints[25].y = y25;
  meshPoints[26].x = x26; 
  meshPoints[26].y = y26;
  meshPoints[27].x = x27; 
  meshPoints[27].y = y27;
  meshPoints[28].x = x28; 
  meshPoints[28].y = y28;
  meshPoints[29].x = x29; 
  meshPoints[29].y = y29;
  meshPoints[30].x = x30; 
  meshPoints[30].y = y30;
  meshPoints[31].x = x31; 
  meshPoints[31].y = y31;
  meshPoints[32].x = x32; 
  meshPoints[32].y = y32;
  meshPoints[33].x = x33; 
  meshPoints[33].y = y33;
  meshPoints[34].x = x34; 
  meshPoints[34].y = y34;
  meshPoints[35].x = x35; 
  meshPoints[35].y = y35;
  meshPoints[36].x = x36; 
  meshPoints[36].y = y36;
  meshPoints[37].x = x37; 
  meshPoints[37].y = y37;
  meshPoints[38].x = x38; 
  meshPoints[38].y = y38;
  meshPoints[39].x = x39; 
  meshPoints[39].y = y39;
  meshPoints[40].x = x40; 
  meshPoints[40].y = y40;
  meshPoints[41].x = x41; 
  meshPoints[41].y = y41;
  meshPoints[42].x = x42; 
  meshPoints[42].y = y42;
  meshPoints[43].x = x43; 
  meshPoints[43].y = y43;
  meshPoints[44].x = x44; 
  meshPoints[44].y = y44;
  meshPoints[45].x = x45; 
  meshPoints[45].y = y45;
  meshPoints[46].x = x46; 
  meshPoints[46].y = y46;
  meshPoints[47].x = x47; 
  meshPoints[47].y = y47;
  meshPoints[48].x = x48; 
  meshPoints[48].y = y48;
  meshPoints[49].x = x49; 
  meshPoints[49].y = y49;
  meshPoints[50].x = x50; 
  meshPoints[50].y = y50;
  meshPoints[51].x = x51; 
  meshPoints[51].y = y51;
  meshPoints[52].x = x52; 
  meshPoints[52].y = y52;
  meshPoints[53].x = x53; 
  meshPoints[53].y = y53;
  meshPoints[54].x = x54; 
  meshPoints[54].y = y54;
  meshPoints[55].x = x55; 
  meshPoints[55].y = y55;
  meshPoints[56].x = x56; 
  meshPoints[56].y = y56;
  meshPoints[57].x = x57; 
  meshPoints[57].y = y57;
  meshPoints[58].x = x58; 
  meshPoints[58].y = y58;
  meshPoints[59].x = x59; 
  meshPoints[59].y = y59;
  meshPoints[60].x = x60; 
  meshPoints[60].y = y60;
  meshPoints[61].x = x61; 
  meshPoints[61].y = y61;
  meshPoints[62].x = x62; 
  meshPoints[62].y = y62;
  meshPoints[63].x = x63; 
  meshPoints[63].y = y63;
  meshPoints[64].x = x64; 
  meshPoints[64].y = y64;
  meshPoints[65].x = x65; 
  meshPoints[65].y = y65;
}


 public void posePosition(float x, float y) {
 // println("pose position\tX: " + x + " Y: " + y );
 
 posePosition = new PVector(x, y);
 }
 
 public void poseScale(float s) {
 //println("scale: " + s);
 poseScale = s;
 }

//void oscEvent(OscMessage theOscMessage) {
//  if (theOscMessage.isPlugged()==false) {
//    println("UNPLUGGED: " + theOscMessage);
//  }
//}


/* OTHER UNUSED FACE OSC EVENTS: */
/*
public void mouthWidthReceived(float w) {
 //println("mouth Width: " + w);
 mouthWidth = w;
 }
 
 public void mouthHeightReceived(float h) {
 //println("mouth height: " + h);
 mouthHeight = h;
 }
 
 public void eyebrowLeftReceived(float h) {
 //println("eyebrow left: " + h);
 leftEyebrowHeight = h;
 }
 
 public void eyebrowRightReceived(float h) {
 //println("eyebrow right: " + h);
 rightEyebrowHeight = h;
 }
 
 public void eyeLeftReceived(float h) {
 //println("eye left: " + h);
 eyeLeftHeight = h;
 }
 
 public void eyeRightReceived(float h) {
 //println("eye right: " + h);
 eyeRightHeight = h;
 }
 
 public void jawReceived(float h) {
 // println("jaw: " + h);
 }
 
 public void nostrilsReceived(float h) {
 // println("nostrils: " + h);
 nostrilHeight = h;
 }
 

 
 public void poseOrientation(float x, float y, float z) {
 //println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
 }
 */
