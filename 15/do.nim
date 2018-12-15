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

  Player = object
    coords: Xy
    kind: PlayerType

  Cell = object
    coords: Xy
    kind: CellType
    player: int

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
        nC: Cell = Cell(coords: pos, kind: EmptySpace, player: -1)
        nP: Player
      nP.coords = pos
      case c:
        of '#':
          nC.kind = Wall
        of '.':
          nC.kind = EmptySpace
        of 'G':
          nP.kind = Goblin
          nC.kind = EmptySpace
          players.add(nP)
          nC.player = high(players)
        of 'E':
          nP.kind = Elf
          nC.kind = EmptySpace
          players.add(nP)
          nC.player = high(players)
        else:
          echo "unknown character: '" & c & "'"
      row.add(nC)
    grid.add(row)
    inc(curLine)
  file.close()

proc draw() =
  for y, l in grid:
    for x, c in l:
      if c.player > -1:
        case players[c.player].kind:
          of Goblin:
            stdout.write 'G'
          of Elf:
            stdout.write 'E'
        continue
      case c.kind:
        of Wall:
          stdout.write '#'
        of EmptySpace:
          stdout.write '.'
    stdout.write '\n'

echo "found " & $len(players) & " players"
if args["--verbose"]:
  draw()
  for p in players:
    echo $p
