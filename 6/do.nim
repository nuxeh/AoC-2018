let doc = """
Advent of code {}, day {}

Usage:
  day{} [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test data
"""
import docopt
import streams
import strutils
import tables
import terminal
import re

var
  filename = ""

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  filename = "test.txt"
else:
  filename = "input.txt"

type
  Point = tuple[
    x: int,
    y: int,
  ]

var
  file = newFileStream(filename, fmRead)
  line = ""
  data = newSeq[Point]()

if not isNil(file):
  while file.readLine(line):
    var matches: array[5, string]
    if match(line, re"(\d*), (\d*)$", matches, 0):
      var entry: Point
      entry.x = parseInt(matches[0])
      entry.y = parseInt(matches[1])
      data.add(entry)
  file.close()

for entry in data:
  echo $entry
