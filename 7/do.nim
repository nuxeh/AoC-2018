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
import sequtils

var
  filename = ""

let args = docopt(doc, version = "0.1.0")
if args["--test"]:
  filename = "test.txt"
else:
  filename = "input.txt"

var
  file = newFileStream(filename, fmRead)
  line = ""
  data = initTable[char, char]()

let alpha = toSeq 'A'..'Z'

if not isNil(file):
  while file.readLine(line):
    var matches: array[2, string]
    if match(line, re"^Step (.) must be finished before step (.) can begin.$", matches, 0):
      data[matches[1][0]] = matches[0][0]
  file.close()

echo $data

proc find_root() =
  var
    ids = data

  for k, t in data:
    echo k & " " & t

  echo ids
  #result = smallest(ids)

find_root()

for k, entry in data:
  echo $entry
