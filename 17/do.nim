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
    StandingWater,
    DampSand

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
  w = maxX - minX + 1
  h = maxY - minY + 1
  map = newSeqWith(h, newSeq[GridType](w))

echo "maximum extents: x=" & $maxX & " y=" & $maxY
echo "minimum extents: x=" & $minX & " y=" & $minY
echo "w=" & $w & " h=" & $h

proc draw() =
  stdout.write '\t'
  for x, elem in map[0]:
    stdout.write fmt"{x mod 16:X}"
  stdout.write '\n'

  for y, row in map:
    stdout.write $y & '\t'
    for x in row:
      case x:
        of Sand:
          stdout.write '.'
        of Clay:
          stdout.write '#'
        of Spring:
          stdout.write '+'
        of DampSand:
          stdout.write '|'
        of StandingWater:
          stdout.write '~'
    stdout.write '\n'

# initialise map
var
  springX = 500 - minX
  springY = 0
map[springY][springX] = Spring
for c in inputData:
  case c.kind:
    of Vertical:
      for y in c.ys[0]..c.ys[1]:
        map[y][c.xs[0] - minX] = Clay
    of Horizontal:
      for x in c.xs[0]..c.xs[1]:
        map[c.ys[0]][x - minX] = Clay

draw()

proc fill(y, x: int): bool =
  discard
#[
  if map[y - 1][x] == EmptySpace:
    return false
  if map[y][x + 1] == EmptySpace:
    return fill(y, x + 1)
  if map[y][x - 1] == EmptySpace:
    return fill(y, x - 1)
  if map[y][x + 1) == Clay:
    return true
]#

proc fall(y, x: int)

type
  Dir = enum
    Left,
    Right

proc spread(y, x: int, dir: Dir) =
  var
    queue = newSeq[int]()
    cx = x

  # spread right
  while map[y][cx] != Clay:
    map[y][cx] = DampSand
    queue.add(cx)
    if not [Clay, StandingWater].contains(map[y + 1][cx]):
      fall(y, cx)
      return
    if dir == Left:
      dec(cx)
    else:
      inc(cx)

  # fill queue
  for q in queue:
    map[y][q] = StandingWater

proc fall(y, x: int) =
  var
    curY = y
  while not [Clay, StandingWater].contains(map[curY + 1][x]):
    inc(curY)
    map[curY][x] = DampSand
    if curY >= maxY:
      return
  spread(curY, x, Left)
  spread(curY, x, Right)

proc count(): int =
  for y, row in map:
    for x, col in row:
      if [StandingWater, DampSand].contains(col):
        inc(result)

var lastCount = 0

for i in 0..20:
  fall(springY, springX)
  draw()
  echo $count()

# resizeable infinite grid lib
# serde file loading
# comonad, monoid, monad
