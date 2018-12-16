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
    regs: seq[int]
    pc: int64

  OpcodeName = enum
    None,
    Addr,
    Addi,
    Mulr,
    Muli,
    Banr,
    Bani,
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

  Opcode = object
    op, inputA, inputB, output: int
    opName: OpcodeName

  Trace = object
    op: Opcode
    initialState: seq[int]
    finalState: seq[int]
    possibleOps: seq[OpcodeName]

var
  traceFile = newFileStream("trace.txt", fmRead)
  instrFile = newFileStream("prog.txt", fmRead)
  line = ""
  traces = newSeq[Trace]()
  program = newSeq[Opcode]()

if not isNil(traceFile):
  var
    t: Trace
    o: Opcode
  while traceFile.readLine(line):
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

  traceFile.close()

echo "found " & $len(traces) & " traces"

proc interpret(op: Opcode, cpu: var Cpu) =
  case op.opName:
    of Addr:
      cpu.regs[op.output] = cpu.regs[op.inputA] + cpu.regs[op.inputB]
    of Addi:
      cpu.regs[op.output] = cpu.regs[op.inputA] + op.inputB
    of Mulr:
      cpu.regs[op.output] = cpu.regs[op.inputA] * cpu.regs[op.inputB]
    of Muli:
      cpu.regs[op.output] = cpu.regs[op.inputA] * op.inputB
    of Banr:
      cpu.regs[op.output] = cpu.regs[op.inputA] and cpu.regs[op.inputB]
    of Bani:
      cpu.regs[op.output] = cpu.regs[op.inputA] and op.inputB
    of Borr:
      cpu.regs[op.output] = cpu.regs[op.inputA] or cpu.regs[op.inputB]
    of Bori:
      cpu.regs[op.output] = cpu.regs[op.inputA] or op.inputB
    of Setr:
      cpu.regs[op.output] = cpu.regs[op.inputA]
    of Seti:
      cpu.regs[op.output] = op.inputA
    of Gtir:
      cpu.regs[op.output] = cast[int](op.inputA > cpu.regs[op.inputB])
    of Grri:
      cpu.regs[op.output] = cast[int](cpu.regs[op.inputA] > op.inputB)
    of Gtrr:
      cpu.regs[op.output] = cast[int](cpu.regs[op.inputA] > cpu.regs[op.inputB])
    of Eqir:
      cpu.regs[op.output] = cast[int](op.inputA == cpu.regs[op.inputB])
    of Eqri:
      cpu.regs[op.output] = cast[int](cpu.regs[op.inputA] == op.inputB)
    of Eqrr:
      cpu.regs[op.output] = cast[int](cpu.regs[op.inputA] == cpu.regs[op.inputB])
    else:
      discard

for t in mitems(traces):
  var
    cpu: Cpu
    trace: Trace = t
  for opcode in OpcodeName:
    if opcode != None:
      cpu.regs = t.initialState
      trace.op.opName = opcode
      interpret(trace.op, cpu)
      if cpu.regs == t.finalState:
        if args["--verbose"]:
          echo "opcode matches " & $t.initialState & " -> " & $cpu.regs & " " & $opcode
        t.possibleOps.add(opcode)

# part 1: find traces with 3 or more possible opcodes

var
  moreThanThree = 0
for t in traces:
  if len(t.possibleOps) >= 3:
    if args["--verbose"]:
      echo $len(t.possibleOps) & " " & $t.possibleOps
    inc(moreThanThree)

echo $moreThanThree & " with more than 3 possible opcodes"

# part 2: find mapping of opcode to integer opcode

var
  opTable = newTable[int, OpcodeName]()

for o in OpcodeName:
  if o == None:
    continue

  var
    matchesAll = true
    opId: int

  for t in traces:
    var
      cpu: Cpu
      trace: Trace = t
    if t.possibleOps.contains(o):
      cpu.regs = t.initialState
      trace.op.opName = o
      interpret(trace.op, cpu)
      if cpu.regs != t.finalState:
        matchesAll = false
        break
    opId = t.op.op
    echo ": " & $opId

  echo $matchesAll & " " & $opId
  if matchesAll:
    opTable.add(opId, o)

echo $opTable
