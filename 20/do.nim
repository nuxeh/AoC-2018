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

type
  SeqNode = ref object
    parent: SeqNode
    children: seq[SeqNode]
    contents: string

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

var matches: array[3, string]
if match(inputData, re"^(\(.?\d+)$", matches, 0):
  echo $matches

proc addChild() =
  discard

var
  root: SeqNode

# iterate over characters
for ch in inputData:
  if ch == '^': continue

  # new branch
  if ch == '(':
    discard

  # close branch
  if ch == ')':
    discard
