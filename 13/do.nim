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
    x: int
    y: int

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
  r = 0

if not isNil(file):
  while file.readLine(line):
    var row = newSeq[Symbol]()
    for c, ch in line:
      var s = sym_table[ch]
      row.add(s)
      if [cartUp, cartDown, cartLeft, cartRight].contains(s):
        carts.add(
          Cart(
            cart_type: s,
            junctions_encountered: 0,
            x: c,
            y: r
        ))
    map.add(row)
    inc(r)
  file.close()

proc char_from_sym(s: Symbol): char =
  for sym in pairs(sym_table):
    if sym[1] == s:
      result = sym[0]

proc draw() =
  for y, row in map:
    for x, col in row:
      var
        c = char_from_sym(col)
      for cart in carts:
        if cart.x == x and cart.y == y:
          c = char_from_sym(cart.cart_type)
      stdout.write c
    stdout.write '\n'

echo "found " & $len(carts) & " carts"
if args["--verbose"]:
  for cart in carts:
    echo $cart
  draw()

proc tick() =
  for cart in carts:
    echo "moo" #move_cart()
