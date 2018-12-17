let doc = """
Advent of code 2018, day 17: Reservoir Research

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
  ClayType = enum
    Vertical,
    Horizontal

  Clay = object
    kind: ClayType
    x, x2, y, y2: int

var
  file = newFileStream(filename, fmRead)
  line = ""
  inputData = newSeq[Clay]()

# x=495, y=2..7
# y=7, x=495..501
if not isNil(file):
  while file.readLine(line):
    var matches: array[3, string]
    if match(line, re"^y=(\d+), x=(\d+)..(\d+)$", matches, 0):
      var
        e: Clay
        i = matches.map(parseInt)
      e.kind = Horizontal
      e.y = i[0]
      e.x = i[1]
      e.x2 = i[2]
      inputData.add(e)
    if match(line, re"^x=(\d+), y=(\d+)..(\d+)$", matches, 0):
      var
        e: Clay
        i = matches.map(parseInt)
      e.kind = Vertical
      e.x = i[0]
      e.y = i[1]
      e.y2 = i[2]
      inputData.add(e)
  file.close()

for e in inputData:
  echo $e
