import argparse;

import std.range;
import std.stdio;
import std.utf;

static struct Arguments {
  @NamedArgument("input", "i")
  string inputFilename;

  @NamedArgument("output", "o")
  string outputFilename = "";

  @NamedArgument("normalize", "n")
  bool normalize;
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
      aiProcess_Triangulate
    | aiProcess_PreTransformVertices
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

  for (uint meshIt = 0; meshIt < scene.mNumMeshes; ++ meshIt) {
    writefln("mesh %s / %s", meshIt+1, scene.mNumMeshes);
    const(aiMesh) * mesh = scene.mMeshes[meshIt];
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

          file.writeVector(mesh.mVertices[index]);

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
});
