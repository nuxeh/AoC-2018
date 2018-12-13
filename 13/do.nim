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
  Symbol = enum
    empty,
    trackHorz,
    trackVert,
    curveRight,
    curveLeft,
    cartLeft,
    cartRight,
    cartUp,
    cartDown,
    junction

  Cart = object
    cart_type: Symbol
    junctions_encountered: int

var
  sym_table = initTable[char, Symbol]()

sym_table.add(' ', empty)
sym_table.add('-', trackHorz)
sym_table.add('|', trackVert)
sym_table.add('/', curveRight)
sym_table.add('\\', curveLeft)
sym_table.add('<', cartLeft)
sym_table.add('>', cartRight)
sym_table.add('^', cartUp)
sym_table.add('v', cartDown)
sym_table.add('+', junction)


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
      row.add(sym_table[ch])
    map.add(row)
  file.close()

echo $map
