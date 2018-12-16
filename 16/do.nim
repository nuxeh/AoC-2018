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
    regs: array[4, int64]
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
      cpu.regs[op.output] = cast[int64](op.inputA > cpu.regs[op.inputB])
    of Grri:
      cpu.regs[op.output] = cast[int64](cpu.regs[op.inputA] > op.inputB)
    of Gtrr:
      cpu.regs[op.output] = cast[int64](cpu.regs[op.inputA] > cpu.regs[op.inputB])
    of Eqir:
      cpu.regs[op.output] = cast[int64](op.inputA == cpu.regs[op.inputB])
    of Eqri:
      cpu.regs[op.output] = cast[int64](cpu.regs[op.inputA] == op.inputB)
    of Eqrr:
      cpu.regs[op.output] = cast[int64](cpu.regs[op.inputA] == cpu.regs[op.inputB])
    else:
      echo "invalid opcode (" & $op.opName & ")!"