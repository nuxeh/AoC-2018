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

  Block = object
    data: seq[Xy]
    dim: Xy

  Symbol = enum
    trackHorz = '-',
    curveRight = '/',
    cartLeft = '<',
    cartRight = '>',
    curveLeft = '\\',
    cartUp = '^',
    cartDown = 'v',
    trackVert = '|'

var syms = ['-', '/', '\\', '<', '>', 'v', '^', '|']
sort(syms, system.cmp[char])
echo $syms

var
  file = newFileStream(filename, fmRead)
  line = ""

var
  map: seq[seq[Symbol]]

if not isNil(file):
  while file.readLine(line):
    var row = newSeq[Symbol]()
    for ch in line:
      row.add(ch)
    map.add(row)
  file.close()



for p in points:
  echo $p
