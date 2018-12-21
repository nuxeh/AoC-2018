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

# iterate over characters
for i, ch in inputData:
  if ch == '^': continue
  if ch == '$': break

  # open branch
  if ch == '(':
    add(curNode.branches, new SeqNode)

  # close branch
  elif ch == ')':
    discard #node.addChild()

  # branch separator
  elif ch == '|':
    add(curNode.branches, new SeqNode)

  # character
  else:
    curNode.contents.add(ch)
