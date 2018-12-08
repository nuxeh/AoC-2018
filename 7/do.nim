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
import sets

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
  tasks = initSet[char]() # <- use a set

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

      # log all tasks seen
      tasks.incl(task)
      tasks.incl(dep)
  file.close()

echo $tasks
echo $deps

proc find_root(): char =
  for t in tasks:
    stdout.write $t
    if not deps.contains(t):
      stdout.write " *"
      result = t
      break
    stdout.write '\n'

var
  root = find_root()
  stack = newSeq[char]()

proc print_deps() =
  for k, t in deps:
    echo k & " " & $t

proc pop_dependency(target: char) =
  print_deps()
  if not stack.contains(target):
    stack.add(target)
  for t in tasks: # always in order
    if deps.contains(t):
      if deps[t].len() <= 1:
        var d = deps[t].find(target)
        if d >= 0:
          deps[t].delete(d)
          pop_dependency(t)

echo root

pop_dependency(root)
echo $stack

echo $('C' > 'B')
