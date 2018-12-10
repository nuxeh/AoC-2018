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

var
  filename = ""

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  filename = "test.txt"
else:
  filename = "input.txt"

type
  Xy = tuple[
    x: int,
    y: int
  ]

type
  Point = tuple[
    position: Xy,
    velocity: Xy
  ]

type
  Space = tuple[
    data: seq[int],
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

proc tick(): Space =
  var
    max: Xy = (points.foldl(max(a, b.position.x), 0),
               points.foldl(max(a, b.position.y), 0))
    min: Xy = (points.foldl(min(a, b.position.x), 0),
               points.foldl(min(a, b.position.y), 0))
    space: Space
    offset: Xy

  space.dim = (max.x - min.x + 1, max.y - min.y + 1)

  offset.x = -1 * min.x
  offset.y = -1 * min.y

  for i in 0..<(space.dim.x * space.dim.y):
    space.data.add(0)

  # create map data
  for p in points:
    var
      x = p.position.x + offset.x
      y = p.position.y + offset.y
      index = (space.dim.x * y) + x
    #echo "x=" & $x & " y=" & $y & " index=" & $index
    if index < len(space.data):
      space.data[index] = 1

  # update positions
  for p in mitems(points):
    p.position.x += p.velocity.x
    p.position.y += p.velocity.y

  result = space

proc draw(s: Space) =
  echo "width: " & $s.dim.x & " height: " & $s.dim.y
  echo $s.dim & " size=" & $len(s.data)
  for y in 0..<s.dim.y:
    for x in 0..<s.dim.x:
      #echo $((s.dim.x * y) + x)
      if s.data[(s.dim.x * y) + x] > 0:
        stdout.write '#'
      else:
        stdout.write '.'
    stdout.write '\n'

draw(tick())
draw(tick())
draw(tick())
draw(tick())
