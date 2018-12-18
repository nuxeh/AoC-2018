let doc = """
Advent of code 2018, day 18: Settlers of The North Pole

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
  CellType = enum
    OpenGround,
    Trees,
    LumberYard

var
  file = newFileStream(filename, fmRead)
  line = ""
  inputData: seq[seq[CellType]]

if not isNil(file):
  while file.readLine(line):
    var row = newSeq[CellType]()
    for ch in line:
      case ch:
        of '.':
          row.add(OpenGround)
        of '#':
          row.add(LumberYard)
        of '|':
          row.add(Trees)
        else:
          echo fmt"unknown '{ch}'"
    inputData.add(row)
  file.close()

if args["--verbose"]:
  for e in inputData:
    echo $e

let
  height = len(inputData)
  width = len(inputData[0])

echo fmt"width={width} height={height}"

proc neighbours(inputMap: seq[seq[CellType]], yi, xi: int): CountTable[CellType] =
  var
    table = initCountTable[CellType]()

  for y in (yi - 1)..(yi + 1):
    for x in (xi - 1)..(xi + 1):
      if x >= 0 and y >= 0 and x < width and y < height:
        if not (x == xi and y == yi):
          table.inc(inputMap[y][x])

  result = table

echo "> " & $neighbours(inputData, 1, 1)

proc draw() =
  for row in inputData:
    for col in row:
      case col:
        of OpenGround:
          stdout.write '.'
        of Trees:
          stdout.write '|'
        of LumberYard:
          stdout.write '#'
    stdout.write '\n'

proc tick(inputMap: seq[seq[CellType]]): seq[seq[CellType]] =
  result = inputMap
  for x, row in inputMap:
    for y, col in row:
      let
        n = inputMap.neighbours(y, x)
      case col:
        of OpenGround:
          if getOrDefault(n, Trees) >= 3:
            result[y][x] = Trees
        of Trees:
          if getOrDefault(n, LumberYard) >= 3:
            result[y][x] = LumberYard
        of LumberYard:
          if not (getOrDefault(n, LumberYard) >= 1 and getOrDefault(n, Trees) >= 1):
            result[y][x] = OpenGround

inputData = tick(inputData)
draw()
