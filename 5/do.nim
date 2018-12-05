
import streams
let doc = """
Advent of code {}, day {}

Usage:
  day{} [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test data
"""
import docopt
import streams
import strutils
import tables
import terminal
import re
import awk
import sequtils

# A sequence:
let alphaSeq = toSeq 'a'..'z'
let alphaSeqUpper = toSeq 'A'..'Z'
#let zippedAlpha1 = zip(alphaSeq, alphaSeqUpper).map(proc(x: (string,string)): echo $x)

var zippedAlpha: array[52, string]
for i, a in alphaSeq:
  zippedAlpha[i * 2] = a & alphaSeqUpper[i]
  zippedAlpha[(i * 2) + 1] = alphaSeqUpper[i] & a

echo $zippedAlpha

var
  filename = ""

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  filename = "test.txt"
else:
  filename = "input.txt"

#if not args["<input>"] == nil:
#  filename = args["<input>"]

var
  file = newFileStream(filename, fmRead)
  line = ""
  data = newSeq[string]()

if not isNil(file):
  while file.readLine(line):
    data.add(line)
  file.close()

for entry in data:
  # part 1
  var
    str = entry
    l = 0
    ol = -1

  while ol != l:
    ol = l
    for a in zippedAlpha:
      str = str.replace(a)
      l = len(str)

  echo str
  echo $l

for entry in data:
  # part 2
  for a in zippedAlpha:
    var
      str = entry
      l = 0
      ol = -1

    while ol != l:
      ol = l
      str = str.replace(a)
      l = len(str)

    echo str
    echo a & " " & $l
