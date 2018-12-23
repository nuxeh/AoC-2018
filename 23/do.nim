let doc = """
Advent of code 2018, day 23: Experimental Emergency Teleportation

Usage:
  do [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test points
  --part2         Process for part 2
"""
import re
import docopt
import terminal
import streams
import strutils
import sequtils
import algorithm
import tables
import sets
import lists
import typetraits
import strformat

var
  filename = ""

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  filename = "test.txt"
else:
  filename = "input.txt"

if args["<input>"]:
  filename = $args["<input>"]

type
  Xyz = object
    x, y, z: int

  Nanobot = object
    coords: Xyz
    radius: int

var
  file = newFileStream(filename, fmRead)
  line = ""
  inputData = newSeq[NanoBot]()

if not isNil(file):
  while file.readLine(line):
    var matches: array[4, string]
    if match(line, re"^pos=<(\d+),(\d+),(\d+)>, r=(\d+)$", matches, 0):
      var
        e: Nanobot
        i = matches.map(parseInt)
      e.coords.x = i[0]
      e.coords.y = i[1]
      e.coords.z = i[2]
      e.radius = i[3]
      inputData.add(e)
      if args["--verbose"]:
        echo line & " -> " & $e
  file.close()

if args["--verbose"]:
  for e in inputData:
    echo $e

proc manhattan3D(a, b: Xyz): int =
  result = abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)

var
  largestRadius = inputData.foldl do (a, b: Nanobot) -> Nanobot:
    result = if a.radius > b.radius: a
      else: b
