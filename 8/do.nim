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

type
  Packet = tuple[
    num_children: int,
    num_meta: int,
    meta: seq[int],
  ]

var
  file = newFileStream(filename, fmRead)
  line = ""
  data_s = newSeq[string]()
  data = newSeq[int]()

if not isNil(file):
  while file.readLine(line):
    data_s = splitWhitespace(line)
  file.close()

data = data_s.map(proc(s: string): int = parseInt(s))

echo $data

#[
proc read_node(int: i): Packet =
  meta = 
  result = (num_children: i, num_meta: i + 1, meta: meta)

var
  nodes = newSeq[Packet]
]#

