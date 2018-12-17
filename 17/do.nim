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

  ClayDeposit = object
    kind: ClayType
    xs, ys: seq[int]

  GridType = enum
    Sand,
    Clay,
    Spring,
    Wet

var
  file = newFileStream(filename, fmRead)
  line = ""
  inputData = newSeq[ClayDeposit]()

# x=495, y=2..7
# y=7, x=495..501
if not isNil(file):
  while file.readLine(line):
    var matches: array[3, string]
    if match(line, re"^y=(\d+), x=(\d+)..(\d+)$", matches, 0):
      var
        e: ClayDeposit
        i = matches.map(parseInt)
      e.kind = Horizontal
      e.ys.add(i[0])
      e.xs.add(i[1])
      e.xs.add(i[2])
      inputData.add(e)
    if match(line, re"^x=(\d+), y=(\d+)..(\d+)$", matches, 0):
      var
        e: ClayDeposit
        i = matches.map(parseInt)
      e.kind = Vertical
      e.xs.add(i[0])
      e.ys.add(i[1])
      e.ys.add(i[2])
      inputData.add(e)
  file.close()

if args["--verbose"]:
  for e in inputData:
    echo $e

var
  maxX = inputData.foldl(max(a, b.xs.foldl(max(a, b), 0)), 0)
  maxY = inputData.foldl(max(a, b.ys.foldl(max(a, b), 0)), 0)
  minX = inputData.foldl(min(a, b.xs.foldl(min(a, b), maxX)), maxX)
  minY = 0
  map = newSeqWith(maxY - minY, newSeq[GridType](maxX - minX))
  w = maxX - minX
  h = maxY - minY

echo "maximum extents: x=" & $maxX & " y=" & $maxY
echo "minimum extents: x=" & $minX & " y=" & $minY
echo "w=" & $w & " h=" & $h

# initialise map
map[0][500 - minX] = Spring
for c in inputData:
  case c.kind:
    of Vertical:
      for y in c.ys[0]..<c.ys[1]:
        echo $y & " " & $(c.xs[0] - minX)
        map[y][c.xs[0] - minX] = Clay
    of Horizontal:
      discard

proc draw() =
  for y in map:
    for x in y:
      case x:
        of Sand:
          stdout.write '.'
        of Clay:
          stdout.write '#'
        of Spring:
          stdout.write '+'
        of Wet:
          stdout.write '~'
    stdout.write '\n'

draw()
