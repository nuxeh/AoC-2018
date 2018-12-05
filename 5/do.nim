
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
echo alphaSeq
echo alphaSeqUpper
#let zippedAlpha1 = zip(alphaSeq, alphaSeqUpper).map(proc(x: (string,string)): echo $x)

var zippedAlpha = newSeq[string]()
for i, a in alphaSeq:
  zippedAlpha.add(a & alphaSeqUpper[i])

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
  var str = entry
  #while true:
  str = str.gsub("aA", "")
  str = str.gsub("cC", "")
  echo $str
  echo $entry

