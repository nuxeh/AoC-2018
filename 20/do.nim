let doc = """
Advent of code 2018, day 20: A Regular Map

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

var
  file = newFileStream(filename, fmRead)
  line = ""
  inputData: string

if not isNil(file):
  while file.readLine(line):
    inputData = line
  file.close()

if args["--verbose"]:
  echo $inputData

type
  SeqNode = ref object
    next: SeqNode
    parent: SeqNode
    branches: seq[SeqNode]
    contents: seq[char]

proc addChild() =
  discard

var
  root: SeqNode = SeqNode()
  curNode = root
  lastCh: char

# iterate over characters
for i, ch in inputData:
  if ch == '^': continue
  if ch == '$': break

  if args["--verbose"]:
    echo inputData
    for j in 0..<i:
      stdout.write ' '
    echo '^'

  # open branch
  if ch == '(':
    add(curNode.branches, new SeqNode)
    curNode.branches[high(curNode.branches)].parent = curNode
    curNode = curNode.branches[high(curNode.branches)]

  # close branch
  elif ch == ')':
    curNode = curNode.parent

  # branch separator
  elif ch == '|':
    curNode = curNode.parent
    add(curNode.branches, new SeqNode)
    curNode.branches[high(curNode.branches)].parent = curNode
    curNode = curNode.branches[high(curNode.branches)]

  # character
  else:
    if lastCh == ')':
      var newNode = SeqNode()
      curNode.next = newNode
      curNode = newNode
    curNode.contents.add(ch)

  lastCh = ch

proc `$`(a: SeqNode): string =
  result = "[" & join(a.contents) & "]"

proc printWithDepth(n: SeqNode, d: int) =
  for i in 0..<d:
    stdout.write ". "
  echo $n

proc drawTree(root: SeqNode, depth: int = 0) =
  var
    c = root
  while c != nil:
    printWithDepth(c, depth)
    for b in c.branches:
      drawTree(b, depth + 1)
    c = c.next

drawTree(root)

iterator items(a: SeqNode): SeqNode =
  var x = a
  while x != nil:
    yield x
    for b in x.branches:
      yield b
    x = x.next

#for n in root:
#  echo $n
