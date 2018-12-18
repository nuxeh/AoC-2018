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
        of '|':
          row.add(LumberYard)
        of '#':
          row.add(Trees)
        else:
          echo fmt"unknown '{ch}'"
    inputData.add(row)
  file.close()

if args["--verbose"]:
  for e in inputData:
    echo $e
