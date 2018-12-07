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
  Task = tuple[
    id: int,
    dep: int,
  ]

var
  file = newFileStream(filename, fmRead)
  line = ""
  data = newSeq[Task]()
  stack = newSeq[Task]()

let alpha = toSeq 'A'..'Z'

if not isNil(file):
  while file.readLine(line):
    var matches: array[2, string]
    if match(line, re"^Step (.) must be finished before step (.) can begin.$", matches, 0):
      var entry: Task
      entry.id = alpha.find(matches[0][0])
      entry.dep = alpha.find(matches[1][0])
      data.add(entry)
  file.close()

proc find_root(d: seq[Task]) =
  var
    ids = toSeq 0..26

  for t in d:
    echo alpha[t.dep]
    ids.delete(t.dep)

  echo ids
  #result = smallest(ids)

find_root(data)

for entry in data:
  echo $entry
