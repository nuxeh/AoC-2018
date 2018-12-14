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
      if [cartUp, cartDown, cartLeft, cartRight].contains(s):
        carts.add(
          Cart(
            cart_type: s,
            junctions_encountered: 0,
            x: c,
            y: r
        ))
        if s == cartUp or s == cartDown:
          s = trackVert
        else:
          s = trackHorz
      row.add(s)
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

proc detect_collisions(): bool =
  for cartA in carts:
    for cartB in carts:
      if cartA.x == cartB.x and cartA.y == cartB.y and cartA != cartB:
        echo "collision at " & $cartA.x & "," & $cartB.y & "!"
        result = true

proc turn(s: Symbol, dir: int): Symbol =
  case dir:
    of 0:
      case s:
        of cartRight:
          result = cartUp
        of cartLeft:
          result = cartDown
        of cartUp:
          result = cartLeft
        of cartDown:
          result = cartRight
        else:
          discard
    of 1:
      result = s
    of 2:
      case s:
        of cartRight:
          result = cartDown
        of cartLeft:
          result = cartUp
        of cartUp:
          result = cartRight
        of cartDown:
          result = cartLeft
        else:
          discard
    else:
      discard

#proc move(self: ref Cart) =
#  self.cart_type = junction

proc tick(): bool =
  for cart in mitems(carts):
    #cart.move()
    case cart.cart_type:
      of cartRight:
        cart.x += 1
      of cartLeft:
        cart.x -= 1
      of cartUp:
        cart.y -= 1
      of cartDown:
        cart.y += 1
      else:
        discard

    case map[cart.y][cart.x]:
      of curveRight:
        case cart.cart_type:
          of cartRight:
            cart.cart_type = cartUp
          of cartLeft:
            cart.cart_type = cartDown
          of cartUp:
            cart.cart_type = cartRight
          of cartDown:
            cart.cart_type = cartLeft
          else:
            discard
      of curveLeft:
        case cart.cart_type:
          of cartRight:
            cart.cart_type = cartDown
          of cartLeft:
            cart.cart_type = cartUp
          of cartUp:
            cart.cart_type = cartLeft
          of cartDown:
            cart.cart_type = cartRight
          else:
            discard
      of junction:
        cart.cart_type = turn(cart.cart_type, cart.junctions_encountered)
        cart.junctions_encountered = (cart.junctions_encountered + 1) mod 3
      else:
        discard

  result = detect_collisions()

var
  ticks = 0

while true:
  if tick():
    echo "tick=" & $ticks
    break
  inc(ticks)
  if args["--verbose"]:
    draw()
