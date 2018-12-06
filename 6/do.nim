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
import sequtils
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

var
  xmax = data.foldl(max(a, b.x), 0)
  xmin = data.foldl(min(a, b.x), 0)
  ymax = data.foldl(max(a, b.y), 0)
  ymin = data.foldl(min(a, b.y), 0)
  all_values = initCountTable[int]()

echo "x max: " & $xmax & " x min: " & $xmin & " y max: " & $ymax & " y min: " & $ymin

if args["--test"]:
  for entry in data:
    echo $entry

proc manhattan_distance(a: Point, b: Point): int =
  result = abs(a.x - b.x) + abs(a.y - b.y)

for y in (-2 * ymax)..(2 * ymax):
  for x in (-2 * xmax)..(2 * xmax):
    var
      distances = initCountTable[int]()
      dist_freq = initCountTable[int]()
      point = false
      shortest = 0
      shortest_key = 0

    for i, p in data:
      if (x, y) == p:
        point = true
      else:
        var d = p.manhattan_distance((x, y))
        distances.inc(i, d)
        dist_freq.inc(d)

    if args["--verbose"]:
      echo $distances

    shortest = smallest(distances).val
    shortest_key = smallest(distances).key

    if point:
      stdout.write '*'
    elif dist_freq[shortest] == 1:
      stdout.write shortest_key
      all_values.inc(shortest_key)
    else:
      stdout.write '.'

  stdout.write '\n'

var smallest_area = smallest(all_values).val

echo $smallest_area

# https://forum.nim-lang.org/t/3432
