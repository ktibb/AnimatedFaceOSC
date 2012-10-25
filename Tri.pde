class Tri {
  PVector[]  mVerts;
  PVector[] uvC;

  // This class is built to store the three vertices of a triangle
  // and also provides a method of drawing these vertices as triangles
  // from within the TriContainer class.

  Tri(PVector vertexA, PVector vertexB, PVector vertexC, PVector uvA, PVector uvB, PVector uvD) {
    // Create an array to store the three vertices of a triangle
    mVerts    = new PVector[3];

    // initialize the array of uvCoords
    uvC = new PVector[3];

    // Store each vertex of the triangle within this array
    mVerts[0] = vertexA;
    mVerts[1] = vertexB;
    mVerts[2] = vertexC;

    // populate the array of PVectors of uvCoords
    uvC[0] = uvA;
    uvC[1] = uvB;
    uvC[2] = uvD;
  }

  void draw() {
    // Draw each vertex of the current triangle    
    for (int i = 0; i < 3; i++) {
      vertex( mVerts[i].x, mVerts[i].y, mVerts[i].z, uvC[i].x, uvC[i].y);
    }
  }

  void detatchVertices() {
    // PVector's get() method creates a clone of the PVector object.
    // After calling this method on a Tri, its vertices
    // will no longer be shared with any other Tri.
    // Of course, this will mean that the vertices in TriContainer's
    // mVertices list will no longer control this triangle.
    // We're not going to do anything with this now, just a thought.
    mVerts[0] = mVerts[0].get();
    mVerts[1] = mVerts[1].get();
    mVerts[2] = mVerts[2].get();
  }
}

