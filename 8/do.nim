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

if args["<input>"]:
  filename = $args["<input>"]

type
  Node = ref object
    children:seq[Node]
    packet: Packet

  Packet = object
    offset: int
    num_children: int
    num_meta: int
    meta: seq[int]

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

proc read_node(i: int): int =
  echo $i

  var
    num_children = data[i]
    num_meta = data[i + 1]
    meta_offset = 0
    packet_length = 0
    meta = newSeq[int]()

  echo "meta " & $num_meta

  for j in 0..<num_children:
    echo "j=" & $j
    meta_offset += read_node(i + 2 + meta_offset) # recurse

  for k in 0..<num_meta:
    let offset = i + 2 + meta_offset + k
    echo "k=" & $k & " (" & $offset & ")"
    meta.add(data[offset])

  echo "meta " & $num_meta

  packet_length = 2 + meta_offset + num_meta

  let node = (offset: i, num_children: num_children, num_meta: num_meta, meta: meta)
  echo $node & " length=" & $packet_length

  result = packet_length

echo len(data)
echo read_node(0)

#[
var
  nodes = newSeq[Packet]
]#


