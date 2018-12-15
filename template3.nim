let doc = """
Advent of code {}, day {}

Usage:
  day{} [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test points
"""
import docopt
import streams
import strutils
import tables
import terminal
import re
import sequtils
import sets
import algorithm

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
  Xy = tuple[
    x: int,
    y: int
  ]

  Point = tuple[
    position: Xy,
    velocity: Xy
  ]

  Space = tuple[
    data: seq[Xy],
    dim: Xy,
  ]

var
  file = newFileStream(filename, fmRead)
  line = ""
  points = newSeq[Point]()

# position=< 1,  6> velocity=< 1,  0>
if not isNil(file):
  while file.readLine(line):
    var matches: array[4, string]
    if match(line, re"^position=<(.*),(.*)> velocity=<(.*),(.*)>$", matches, 0):
      var entry: Point
      entry = ((parseInt(strip(matches[0])), parseInt(strip(matches[1]))),
               (parseInt(strip(matches[2])), parseInt(strip(matches[3]))))
      points.add(entry)
  file.close()


for p in points:
  echo $p
