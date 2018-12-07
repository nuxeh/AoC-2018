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

type
  Entry = tuple[
    id: int,
    dep: int,
  ]

var
  file = newFileStream(filename, fmRead)
  line = ""
  data = newSeq[Entry]()

let alpha = toSeq 'A'..'Z'

if not isNil(file):
  while file.readLine(line):
    var matches: array[5, string]
    if match(line, re"^Step (.) must be finished before step (.) can begin.$", matches, 0):
      var entry: Entry
      entry.id = alpha.find(cast[char](matches[1]))
      entry.dep = alpha.find(cast[char](matches[0]))
      data.add(entry)
  file.close()

for entry in data:
  echo $entry
