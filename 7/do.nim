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
  deps = initTable[char, seq[char]]()
  tasks = newSeq[char]()

let alpha = toSeq 'A'..'Z'

if not isNil(file):
  while file.readLine(line):
    var
      matches: array[2, string]
    if match(line, re"^Step (.) must be finished before step (.) can begin.$", matches, 0):
      var
        task = matches[1][0]
        dep = matches[0][0]

      discard deps.hasKeyOrPut(task, newSeq[char]())
      deps[task].add(dep)

      if tasks.find(task) == -1:
        tasks.add(task)
      if tasks.find(dep) == -1:
        tasks.add(dep)
  file.close()

echo $tasks
echo $deps

proc find_root() =
  var
    ids = deps

  for t in tasks:
    echo $t
    

  echo ids
  #result = smallest(ids)

find_root()

for k, entry in deps:
  echo $entry
