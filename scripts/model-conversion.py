#!/usr/bin/env python3
import argparse
import os
import itertools

class Vec3:
  def __init__(s, elem0, elem1=None, elem2=None):
    s.x = elem0;
    s.y = elem1 if (elem1 is not None) else elem0;
    s.z = elem2 if (elem2 is not None) else elem0;

  def __str__(s):
    return f"<{s.x}, {s.y}, {s.z}>"

def argToUp(upArg):
  translator = {
    "+z": Vec3(0.0, 0.0, +1.0),
    "-z": Vec3(0.0, 0.0, -1.0),
    "+y": Vec3(0.0, +1.0, 0.0),
    "-y": Vec3(0.0, -1.0, 0.0),
    "-x": Vec3(-1.0, 0.0, 0.0),
    "+x": Vec3(+1.0, 0.0, 0.0),
  };
  return translator[upArg];

class Scene:
  def __init__(s):
    s.origins = [] # vec3
    s.elements = [] # (int, int, int)

  def __str__(s):
    resultStr = "# MTR format converted by utility script\n"
    for elements in s.elements:
      for element in elements:
        origin = s.origins[element];
        resultStr += f"{origin.x}|{origin.y}|{origin.z}\n";
    return resultStr

def convertObj(inputFile):
  scene = Scene();

  file = open(inputFile);
  for line in file.readlines():
    line = line.rstrip();
    line = line.split()
    if (len(line) == 0):
      continue

    if (line[0] == 'f'):
      faceElements = list(f.split('/')[0] for f in line[1:4])
      scene.elements += [list((int(l)-1) for l in faceElements)]
    if (line[0] == 'v'):
      scene.origins += [Vec3(float(line[1]), float(line[2]), float(line[3]))]

  return scene

def convert(inputFile, upConversion):
  basename, ext = os.path.splitext(inputFile)

  scene = Scene();
  if (ext == ".obj"):
    scene = convertObj(inputFile)

  # TODO apply up conversion

  return scene

def main(args):
  if (args.from_up is None) != (args.to_up is None):
    raise Exception("must define none or both of from-up and to-up")

  fromUp = None;
  if (args.from_up is not None):
    fromUp = argToUp(args.from_up);

  toUp = None;
  if (args.from_up is not None):
    toUp = argToUp(args.to_up);

  from pathlib import Path

  if (args.input is None):
    raise Exception("input required")

  inputFile = args.input;

  outputFile = args.output;
  if (args.output is None):
    pre, ext = os.path.splitext(inputFile)
    outputFile = pre + ".mtr"

  print(f"input: {inputFile} output: {outputFile}")

  # convert
  result = convert(inputFile, (fromUp, toUp));

  if (outputFile == "stdout"):
    print(result)
  else:
    with open(outputFile, 'w') as f:
      f.write(str(result))


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.set_defaults(func=main)
  parser.add_argument('-i', '--input', metavar='input', default=None)
  parser.add_argument('-o', '--output', metavar='output', default=None)
  parser.add_argument('-fu', '--from-up', metavar='fup', default=None)
  parser.add_argument('-tu', '--to-up', metavar='tup', default=None)
  args = parser.parse_args()
  args.func(args)
