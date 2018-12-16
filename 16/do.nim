let doc = """
Advent of code 2018, day 16: Chronal Classification

Usage:
  do [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
  -t --test       Use test points
  --part2         Process for part 2
"""
import docopt
import streams
import strutils
import tables
import terminal
import re
import sequtils
import sets
import lists
import algorithm
import typetraits

var
  filename = ""

let args = docopt(doc, version = "0.1.0")
if args["--part2"]:
  filename = "prog.txt"
else:
  filename = "trace.txt"

type
  Cpu = object
    regA, regB, regC: int64

  Opcode = object
    op, inputA, inputB, output: int

  OpcodeName = enum
    Addr,
    Addi,
    Mulr,
    Muli,
    Borr,
    Bori,
    Setr,
    Seti,
    Gtir,
    Grri,
    Gtrr,
    Eqir,
    Eqri,
    Eqrr

  Trace = object
    op: Opcode
    initialState: seq[int]
    finalState: seq[int]
    opName: seq[OpcodeName]

var
  file = newFileStream(filename, fmRead)
  line = ""
  traces = newSeq[Trace]()
  program = newSeq[Opcode]()

if not isNil(file):
  var
    t: Trace
    o: Opcode
  while file.readLine(line):
    var
      matches: array[4, string]
    if match(line, re"^Before: \[(\d), (\d+), (\d+), (\d+)\]$", matches, 0):
      t.initialState = matches.map(parseInt)
    elif match(line, re"^After:  \[(\d+), (\d+), (\d+), (\d+)\]$", matches, 0):
      t.finalState = matches.map(parseInt)
      traces.add(t)
    elif match(line, re"^(\d+) (\d+) (\d+) (\d+)$", matches, 0):
      var matchesInt = matches.map(parseInt)
      o.op = matchesInt[0]
      o.inputA = matchesInt[1]
      o.inputB = matchesInt[2]
      o.output = matchesInt[3]
      t.op = o

  file.close()
var i = 0
for t in traces:
  echo $t
  inc(i)
echo $i
echo "found " & $len(traces) & " traces"
