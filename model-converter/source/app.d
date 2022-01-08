import argparse;

import std.math, std.algorithm;
import std.range;
import std.stdio;
import std.utf;
import std.json;

static struct Arguments {
  @NamedArgument("input", "i")
  string inputFilename;

  @NamedArgument("output", "o")
  string outputFilename = "";

  @NamedArgument("normalize", "n")
  bool normalize;

  @NamedArgument("up", "u")
  bool fixUp;
}

import assimp;

void writeVector(ref File file, aiVector3D vector) {
  float[3] vectorArr = [vector.x, vector.y, vector.z];
  file.rawWrite(vectorArr);
}

mixin Main.parseCLIArgs!(Arguments, (args) {
  if (args.inputFilename == "") {
    writefln("input filename is required");
    return;
  }
  if (args.outputFilename == "") {
    args.outputFilename = args.inputFilename ~ ".mtr";
  }

  if (args.inputFilename[$-4..$] == ".mtr") {
    writefln("no-op for MTR, will now exit");
    return;
  }

  writefln("loading assimp bindings");

  writefln("loading scene");
  auto scene = (
    aiImportFile(
      toUTFz!(char*)(args.inputFilename),
      0
    //  aiProcess_Triangulate
    //| aiProcess_PreTransformVertices
    //| aiProcess_GenUVCoords
    )
  );
  if (!scene) {
    writefln("unsupported file: %s", args.inputFilename);
    return;
  }
  scope(exit) aiReleaseImport(scene);

  File file = File(args.outputFilename, "wb");
  writefln("converting scene to %s", args.outputFilename);

  JSONValue j = [
    "version": "0.0",
  ];

  j.object["scene"].array ~= ;

  for (uint meshIt = 0; meshIt < scene.mNumMeshes; ++ meshIt) {
    writefln("mesh %s / %s", meshIt+1, scene.mNumMeshes);
    const(aiMesh) * mesh = scene.mMeshes[meshIt];
    // NOTE ; i think this won't be very correct if there are multiple meshes
    aiAABB bounding = mesh.mAABB;

    // Recompute AABB bc for some reason it is actually not always correct
    bounding.mMax.x = bounding.mMax.y = bounding.mMax.z = -99999.0f;
    bounding.mMin.x = bounding.mMin.y = bounding.mMin.z = +99999.0f;
    for (uint elementIt = 0; elementIt < mesh.mNumFaces; ++ elementIt) {
      const(aiFace) elements = mesh.mFaces[elementIt];
      if (elements.mNumIndices < 3) {
        writefln(
          "warn: number of indices is %s, must have at least 3",
          elements.mNumIndices
        );
        continue;
      }

      foreach (indexIts; (elements.mNumIndices).iota.slide(3)) {
        foreach (indexIt; indexIts) {
          uint index = elements.mIndices[indexIt];

          aiVector3D origin = mesh.mVertices[index];

          bounding.mMax.x = max(bounding.mMax.x, origin.x);
          bounding.mMax.y = max(bounding.mMax.y, origin.y);
          bounding.mMax.z = max(bounding.mMax.z, origin.z);

          bounding.mMin.x = min(bounding.mMin.x, origin.x);
          bounding.mMin.y = min(bounding.mMin.y, origin.y);
          bounding.mMin.z = min(bounding.mMin.z, origin.z);
        }
      }
    }

    auto centerOrigin = aiVector3D(
      (bounding.mMax.x - bounding.mMin.x)*0.5 - bounding.mMin.x,
      (bounding.mMax.y - bounding.mMin.y)*0.5 - bounding.mMin.y,
      (bounding.mMax.z - bounding.mMin.z)*0.5 - bounding.mMin.z,
    );

    bool hasShownExampleOrigin = true;

    if (args.normalize) {
      writefln("mesh aabb: %s", bounding);
      writefln(
        "  --> bounds: %s",
        aiVector3D(
          bounding.mMax.x-bounding.mMin.x,
          bounding.mMax.y-bounding.mMin.y,
          bounding.mMax.z-bounding.mMin.z,
        )
      );
      writefln("will move mesh from %s to %s", centerOrigin, aiVector3D(0,0,0));
      hasShownExampleOrigin = false;
    }

    assert(mesh);
    for (uint elementIt = 0; elementIt < mesh.mNumFaces; ++ elementIt) {
      const(aiFace) elements = mesh.mFaces[elementIt];
      if (elements.mNumIndices < 3) {
        writefln(
          "warn: number of indices is %s, must have at least 3",
          elements.mNumIndices
        );
        continue;
      }

      foreach (indexIts; (elements.mNumIndices).iota.slide(3)) {
        foreach (indexIt; indexIts) {
          uint index = elements.mIndices[indexIt];

          aiVector3D origin = mesh.mVertices[index];

          if (!hasShownExampleOrigin) {
            writefln("example normalized origin: %s", origin);
          }

          if (args.normalize) {
            origin.x += centerOrigin.x;
            origin.y += centerOrigin.y;
            origin.z += centerOrigin.z;
          }

          if (args.fixUp) {
            swap(origin.z , origin.y);
          }

          if (!hasShownExampleOrigin) {
            writefln("  --> %s", origin);
            hasShownExampleOrigin = true;
          }

          file.writeVector(origin);

          file.writeVector(
            mesh.mTextureCoords[0]
              ? mesh.mTextureCoords[0][index]
              : aiVector3D(0.0, 0.0, 0.0)
          );
        }
      }
    }
  }

  writefln("Success!");

  writefln(j.toString);
});
