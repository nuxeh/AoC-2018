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

#static:
var
  t = initTable[char, Symbol]()

t.add(' ', empty)
t.add('-', trackHorz)
t.add('|', trackVert)
t.add('/', curveRight)
t.add('\\', curveLeft)
t.add('<', cartLeft)
t.add('>', cartRight)
t.add('^', cartUp)
t.add('v', cartDown)
t.add('+', junction)

let sym_table = t # const

var
  file = newFileStream(filename, fmRead)
  line = ""

var
  map: seq[seq[Symbol]]
  carts: seq[Cart]

if not isNil(file):
  while file.readLine(line):
    var row = newSeq[Symbol]()
    for ch in line:
      row.add(sym_table[ch])
      if [cartUp, cartDown, cartLeft, cartRight].contains(sym_table[ch]):
        carts.add(Cart(cart_type: sym_table[ch], junctions_encountered: 0))
    map.add(row)
  file.close()

echo "found " & $len(carts) & " carts"
echo $map
