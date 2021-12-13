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

def convertObj(inputFile):
  scene = Scene();

  with open(inputFile) as file:
    total = len(file.readlines())
  print(f"total: {total}")

  with open(inputFile) as file:
    for index, line in enumerate(file.readlines()):
      line = line.rstrip().split()

      if not line:
        continue

      if (index % 10000 == 0):
        print(f"{index}/{total} :: {len(scene.elements)} :: {len(scene.origins)}")

      name, *args = line
      if (name == 'f'):
        elems = (int(f.split('/',1)[0]) - 1 for f in args)
        it = 0
        for e in sliding_window(elems, 3):
          it += 1
          if (it % 2 == 0):
            e = (e[0], e[2], e[1])
          scene.elements.extend(e)
      elif (name == 'v'):
        scene.origins.extend(float(v) for v in args)

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
  result = convert(inputFile, (fromUp, toUp));

  print(f"conversion finished now writing {len(result.elements)}")

  if (outputFile == "stdout"):
    print(result)
  else:
    with open(outputFile, 'w+b') as file:
      result.writeToFile(file);


if __name__ == '__main__':
  parser = argparse.ArgumentParser()
  parser.set_defaults(func=main)
  parser.add_argument('-i', '--input', metavar='input', default=None)
  parser.add_argument('-o', '--output', metavar='output', default=None)
  parser.add_argument('-fu', '--from-up', metavar='fup', default=None)
  parser.add_argument('-tu', '--to-up', metavar='tup', default=None)
  args = parser.parse_args()
  args.func(args)
