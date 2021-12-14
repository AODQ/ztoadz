#!/usr/bin/env python3
import argparse
import itertools
import os
import sys
import struct
from pathlib import Path

class Scene:
  def __init__(s):
    s.origins = [] # vec3
    s.elements = [] # (int, int, int)

  def writeToFile(s, file):
    for elements in zip(*([iter(s.elements)]*3)): # iterate chunks of 3 trick
      for element in elements:
        file.write(struct.pack("fff", *s.origins[element*3:element*3+3]))
    file.close()

  def __str__(s):
    resultStr = "# MTR format converted by utility script\n"
    for elements in s.elements:
      for element in elements:
        origin = s.origins[element];
        resultStr += f"{origin.x}|{origin.y}|{origin.z}\n";
    return resultStr

def sliding_window(iterable, n):
  import collections
  from itertools import islice
  # sliding_window('ABCDEFG', 4) -> ABCD BCDE CDEF DEFG
  it = iter(iterable)
  window = collections.deque(islice(it, n), maxlen=n)
  if len(window) == n:
      yield tuple(window)
  for x in it:
      window.append(x)
      yield tuple(window)

def convert(inputFile, outputFile, upConversion, normalize):
  basename, ext = os.path.splitext(inputFile)

  #scene = Scene();

  print("importing scene");
  import pyassimp
  scene = pyassimp.load(inputFile);

  minbounds = [999999.0, 999999.0, 9999999.0]
  maxbounds = [-999999.0, -999999.0, -9999999.0]

  for mesh in scene.meshes:
    for elements in zip(*([iter(mesh.faces)])):
      assert len(elements) == 1
      for element in elements[0]:
        for i in range(0, 3):
          minbounds[i] = min(mesh.vertices[element][i], minbounds[i])
          maxbounds[i] = max(mesh.vertices[element][i], maxbounds[i])

  lenbounds = [
    maxbounds[0]-minbounds[0],
    maxbounds[1]-minbounds[1],
    maxbounds[2]-minbounds[2]
  ];

  print(
    f"scene dimensions:\n\t   {minbounds}\n\t-> {maxbounds}\n\t== {lenbounds}"
  )

  file = open(outputFile, 'w+b')
  print(f"scene: {scene}")
  print("converting scene");
  for mesh in scene.meshes:
    for elements in zip(*([iter(mesh.faces)])):
      assert len(elements) == 1
      for element in elements[0]:
        vtx = mesh.vertices[element];
        if (normalize):
          vtx[0] = vtx[0] + 0.5;
          vtx[1] = vtx[1] + 0.5;
          vtx[2] = vtx[2] + 0.5;
          #for i in range(0, 3):
          #  vtx[i] = vtx[i]*0.5;

        file.write(struct.pack("fff", *vtx));
        if (len(mesh.texturecoords) == 0):
          file.write(struct.pack("fff", *(0.0, 0.0, 0.0)))
        else:
          file.write(struct.pack("fff", *mesh.texturecoords[0][element]));

  file.close()

def main(args):
  if (args.from_up is None) != (args.to_up is None):
    raise Exception("must define none or both of from-up and to-up")

  fromUp = None;
  #if (args.from_up is not None):
  #  fromUp = argToUp(args.from_up);

  toUp = None;
  #if (args.from_up is not None):
  #  toUp = argToUp(args.to_up);

  if (args.input is None):
    raise Exception("input required")

  inputFile = args.input;

  outputFile = args.output;
  if (args.output is None):
    pre, ext = os.path.splitext(inputFile)
    outputFile = pre + ".mtr"

  print(f"input: {inputFile} output: {outputFile}")

  # convert
  result = (
    convert(inputFile, outputFile, (fromUp, toUp), args.normalize is not None)
  );

  print(f"conversion finished")


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.set_defaults(func=main)
  parser.add_argument('-i', '--input', metavar='input', default=None)
  parser.add_argument('-n', '--normalize', action='store_true', default=None)
  parser.add_argument('-o', '--output', metavar='output', default=None)
  parser.add_argument('-fu', '--from-up', metavar='fup', default=None)
  parser.add_argument('-tu', '--to-up', metavar='tup', default=None)
  args = parser.parse_args()
  args.func(args)
