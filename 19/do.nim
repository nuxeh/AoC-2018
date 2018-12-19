let doc = """
Advent of code 2018, day 19: Go With The Flow

Usage:
  do [options] [<input>]

Options:
  -h --help       Show this help message.
  -v --verbose    Show extra information.
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

let args = docopt(doc, version = "0.1.0")

type
  Cpu = object
    regs: seq[int]
    pc: int

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
    inputA, inputB, output: int
    opName: OpcodeName

  Trace = object
    op: Opcode
    initialState: seq[int]
    finalState: seq[int]
    possibleOps: seq[OpcodeName]

var
  instrFile = newFileStream("input.txt", fmRead)
  line = ""
  program = newSeq[Opcode]()
  pcReg = 1

proc interpret(cpu: var Cpu, op: Opcode) =
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

# load and run programme

if not isNil(instrFile):
  var o: Opcode
  while instrFile.readLine(line):
    var matches: array[4, string]
    if match(line, re"^(.+) (\d+) (\d+) (\d+)$", matches, 0):
      var matchesInt = matches[1..3].map(parseInt)
      o.inputA = matchesInt[0]
      o.inputB = matchesInt[1]
      o.output = matchesInt[2]
      for op in OpcodeName:
        if toLowerAscii($op) == matches[0]:
          o.opName = op
      program.add(o)
  instrFile.close()

echo "found " & $len(program) & " opcodes"

var
  cpu: Cpu

cpu.regs.add(0)
cpu.regs.add(0)
cpu.regs.add(0)
cpu.regs.add(0)
cpu.regs.add(0)
cpu.regs.add(0)

echo $cpu

while true:
  if cpu.pc < 0 or cpu.pc > len(program):
    echo "program halted"
    echo $cpu
    quit(0)
  else:
    cpu.regs[pcReg] = cpu.pc
    cpu.interpret(program[cpu.pc]) # exception
    cpu.pc = cpu.regs[pcReg]
  cpu.pc += 1

echo $cpu
