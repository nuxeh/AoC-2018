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

#[
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
]#

#[
L ← Empty list that will contain the sorted elements
S ← Set of all nodes with no incoming edge
while S is non-empty do
    remove a node n from S
    add n to tail of L
    for each node m with an edge e from n to m do
        remove edge e from the graph
        if m has no other incoming edges then
            insert m into S
if graph has edges then
    return error   (graph has at least one cycle)
else
    return L   (a topologically sorted order)
]#

var
  L = newSeq[char]()  # ← Empty list that will contain the sorted elements
  S = initSet[char]() # ← Set of all nodes with no incoming edge

for t in tasks:
  if not deps.contains(t):
    S.incl(t)

echo "no incoming edges: " & $S

while len(S) > 0:
  let n = S.pop()
  L.add(n)
  for k, d in deps:
    echo $d
    if d.contains(n):
      let i = d.find(n)
      deps[k].delete(i)
      if len(deps[k]) == 0:
        S.incl(k)

echo $S
echo $L
echo $L.join()
