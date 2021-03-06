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

echo "x max: " & $xmax & " x min: " & $xmin & " y max: " & $ymax & " y min: " & $ymin

if args["--test"]:
  for entry in data:
    echo $entry

proc manhattan_distance(a: Point, b: Point): int =
  result = abs(a.x - b.x) + abs(a.y - b.y)

proc write_s(s: string) =
  if args["--test"]:
    stdout.write s

proc evaluate(ymax: int, xmax: int): CountTable[int] =
  var
    all_values = initCountTable[int]()

  for y in -ymax..ymax:
    for x in -xmax..xmax:
      var
        distances = initCountTable[int]()
        dist_freq = initCountTable[int]()
        point = false
        shortest = 0
        shortest_key = 0

      for i, p in data:
        if (x, y) == p:
          all_values.inc(i)
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
        write_s "*"
      elif dist_freq[shortest] == 1:
        write_s $shortest_key
        all_values.inc(shortest_key)
      else:
        write_s "."
    write_s "\n"

    result = all_values

var areas1 = evaluate(ymax, xmax)
var areas2 = evaluate(ymax + 1, xmax + 1)

#sort(areas1)
#sort(areas2)

echo $areas1
echo $areas2

#let zip = zip(areas1, areas2)
#echo $zip

var largest = 0

for i, a in areas1:
  if a == areas2[i]:
    echo $i & " " & $a & " " & $areas2[i]
    if a > largest:
      largest = a

echo $largest & " (" & $(largest + 1) & ")"


# https://forum.nim-lang.org/t/3432
# also, what's the deal with let?

var
  safe_zone_area = 0
  threshold = 32

if not  args["--test"]:
  threshold = 10000

proc evaluate_part2(ymax: int, xmax: int) =
  for y in -ymax..ymax:
    for x in -xmax..xmax:
      var
        total_distance = 0

      for i, p in data:
        var d = p.manhattan_distance((x, y))
        inc(total_distance, d)

      if total_distance < threshold:
        write_s "#"
        inc(safe_zone_area)
      else:
        write_s "."

    write_s "\n"

evaluate_part2(ymax, xmax)
echo $safe_zone_area
