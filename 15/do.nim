let doc = """
Advent of code 2018, day 15: Beverage Bandits

Usage:
  ./do [options] [<input>]

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
  Xy = object
    x, y: int

  CellType = enum
    EmptySpace,
    Wall

  PlayerType = enum
    Goblin,
    Elf

  Cell = object
    coords: Xy
    kind: CellType

  Player = object
    coords: Xy
    kind: PlayerType

var
  file = newFileStream(filename, fmRead)
  line = ""
  grid: seq[seq[Cell]]
  players = newSeq[Player]()
  curLine = 0

if not isNil(file):
  while file.readLine(line):
    var
      row = newSeq[Cell]()
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
          row.add(nC)
        of '.':
          nC.kind = EmptySpace
          row.add(nC)
        of 'G':
          nP.kind = Goblin
          players.add(nP)
        of 'E':
          nP.kind = Elf
          players.add(nP)
        else: echo "unknown character: " & c
      grid.add(row)
    inc(curLine)
  file.close()

proc draw() =
  for y, l in grid:
    for c in l:
      echo $c.type.name
#[
      case cell.kind:
        of Wall:
          stdout.write '#'
        of EmptySpace:
          stdout.write '.'
]#
    stdout.write '\n'

echo "found " & $len(players) & " players"
if args["--verbose"]:
  draw()
  for p in players:
    echo $p
