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
  Xy = object
    x: int
    y: int

  Map = enum
    EmptySpace,
    Wall

  Cell = object
    coords: Xy
    kind: Map

  PlayerType = enum
    Goblin,
    Elf

  Player = object
    coords: Xy
    kind: PlayerType

var
  file = newFileStream(filename, fmRead)
  line = ""
  grid = newSeq[Cell]()
  players = newSeq[Player]()
  curLine = 0

if not isNil(file):
  while file.readLine(line):
    for x, c in line:
      var
        pos: Xy = Xy(x: x, y: curLine)
        nC: Cell
        nP: Player
      nC.coords = pos
      nP.coords = pos
      case c:
        of '#':
          nC.kind = Wall
          grid.add(nC)
        of '.':
          nC.kind = EmptySpace
          grid.add(nC)
        of 'G':
          nP.kind = Goblin
          players.add(nP)
        of 'E':
          nP.kind = Elf
          players.add(nP)
        else: echo "unknown character: " & c
    inc(curLine)
  file.close()

echo "found " & $len(players) & " players"
if args["--verbose"]:
  for p in players:
    echo $p
